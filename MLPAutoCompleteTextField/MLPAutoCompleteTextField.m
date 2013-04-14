/*
 //  MLPAutoCompleteTextField.m
 //  
 //
 //  Created by Eddy Borja on 12/29/12.
 //  Copyright (c) 2013 Mainloop LLC. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "MLPAutoCompleteTextField.h"
#import "NSString+Levenshtein.h"
#import <QuartzCore/QuartzCore.h>

@interface MLPAutoCompleteOperation: NSOperation
@property (strong) NSString *incompleteString;
@property (strong) NSArray *possibleCompletions;
@property (strong) id <MLPAutoCompleteOperationDelegate> delegate;
@property (strong) NSDictionary *boldTextAttributes;
@property (strong) NSDictionary *regularTextAttributes;

- (id)initWithDelegate:(id<MLPAutoCompleteOperationDelegate>)aDelegate
      incompleteString:(NSString *)string
   possibleCompletions:(NSArray *)possibleStrings;

- (NSArray *)autocompleteSuggestionsForString:(NSString *)inputString
                          withPossibleStrings:(NSArray *)possibleTerms;
@end


static NSString *BorderStyleKeyPath = @"borderStyle";
static NSString *AutoCompleteTableViewHiddenKeyPath = @"autoCompleteTableView.hidden";
static NSString *BackgroundColorKeyPath = @"backgroundColor";
static NSTimeInterval kAutoCompleteRequestDelay = 0.5;

@interface MLPAutoCompleteTextField ()
@property (strong) UITableView *autoCompleteTableView;
@property (strong) NSArray *autoCompleteSuggestions;
@property (strong) NSOperationQueue *autoCompleteQueue;
@property (strong) NSString *reuseIdentifier;
@property (assign) CGColorRef originalShadowColor;
@property (assign) CGSize originalShadowOffset;
@property (assign) CGFloat originalShadowOpacity;

- (void)initialize;
- (void)beginObservingKeyPathsAndNotifications;
- (void)setDefaultValuesForVariables;
+ (UITableView *)newAutoCompleteTableViewForTextField:(MLPAutoCompleteTextField *)textField;
- (void)unregisterAutoCompleteCellForReuseIdentifier:(NSString *)reuseIdentifier;
- (UITableViewCell *)autoCompleteTableViewCellWithReuseIdentifier:(NSString *)identifier;
- (void)textFieldDidChangeWithNotification:(NSNotification *)aNotification;
- (void)fetchAutoCompleteSuggestions;
- (void) finishedSearching;
- (void)expandAutoCompleteTableViewForNumberOfRows:(NSInteger)numberOfRows;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
withAutoCompleteString:(NSString *)string;
+ (CGRect)autoCompleteTableViewFrameForTextField:(MLPAutoCompleteTextField *)textField
                                 forNumberOfRows:(NSInteger)numberOfRows;
+ (CGRect)autoCompleteTableViewFrameForTextField:(MLPAutoCompleteTextField *)textField;
- (void)closeAutoCompleteTableView;
- (void)styleAutoCompleteTableForBorderStyle:(UITextBorderStyle)borderStyle;
- (void)setRoundedRectStyleForAutoCompleteTableView;
- (void)setLineStyleForAutoCompleteTableView;
- (void)setNoneStyleForAutoCompleteTableView;
- (void)saveCurrentShadowProperties;
- (void)restoreOriginalShadowProperties;
- (NSAttributedString *)boldedString:(NSString *)string withRange:(NSRange)boldRange;
- (void)stopObservingKeyPathsAndNotifications;
@end



@implementation MLPAutoCompleteTextField

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Init

- (void)initialize
{
    [self beginObservingKeyPathsAndNotifications];
    
    [self setDefaultValuesForVariables];
    
    UITableView *newTableView = [[self class] newAutoCompleteTableViewForTextField:self];    
    [self setAutoCompleteTableView:newTableView];
    
    [self styleAutoCompleteTableForBorderStyle:self.borderStyle];
}


- (void)beginObservingKeyPathsAndNotifications
{
    [self addObserver:self
           forKeyPath:BorderStyleKeyPath
              options:NSKeyValueObservingOptionNew context:nil];
    
    
    [self addObserver:self
           forKeyPath:AutoCompleteTableViewHiddenKeyPath
              options:NSKeyValueObservingOptionNew context:nil];
    
    
    [self addObserver:self
           forKeyPath:BackgroundColorKeyPath
              options:NSKeyValueObservingOptionNew context:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeWithNotification:)
                                                 name:UITextFieldTextDidChangeNotification object:self];
}


- (void)setDefaultValuesForVariables
{
    [self setClipsToBounds:NO];
    [self setSortAutoCompleteSuggestionsByClosestMatch:YES];
    [self setApplyBoldEffectToAutoCompleteSuggestions:YES];
    [self setShowTextFieldDropShadowWhenAutoCompleteTableIsOpen:YES];
    [self setAutoCompleteRowHeight:40];
    [self setAutoCompleteFontSize:13];
    [self setMaximumNumberOfAutoCompleteRows:3];
    
    UIFont *regularFont = [UIFont systemFontOfSize:13];
    [self setAutoCompleteRegularFontName:regularFont.fontName];
    
    UIFont *boldFont = [UIFont boldSystemFontOfSize:13];
    [self setAutoCompleteBoldFontName:boldFont.fontName];
    
    [self setAutoCompleteSuggestions:[NSMutableArray array]];
    
    [self setAutoCompleteQueue:[[NSOperationQueue alloc] init]];
    self.autoCompleteQueue.name = [NSString stringWithFormat:@"Autocomplete Queue %i", arc4random()];
}


+ (UITableView *)newAutoCompleteTableViewForTextField:(MLPAutoCompleteTextField *)textField
{
    CGRect dropDownTableFrame = [[self class] autoCompleteTableViewFrameForTextField:textField];
    
    UITableView *newTableView = [[UITableView alloc] initWithFrame:dropDownTableFrame
                                                             style:UITableViewStylePlain];
    [newTableView setDelegate:textField];
    [newTableView setDataSource:textField];
    [newTableView setScrollEnabled:YES];
    [newTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    return newTableView;
}


- (BOOL)autoCompleteTableViewHidden
{
    return self.autoCompleteTableView.hidden;
}


- (void)setAutoCompleteTableViewHidden:(BOOL)autoCompleteTableViewHidden
{
    [self.autoCompleteTableView setHidden:autoCompleteTableViewHidden];
}


- (void)registerAutoCompleteCellNib:(UINib *)nib forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    NSAssert(self.autoCompleteTableView, @"Must have an autoCompleteTableView to register cells to.");
    
    if(self.reuseIdentifier){
        [self unregisterAutoCompleteCellForReuseIdentifier:self.reuseIdentifier];
    }
    
    [self.autoCompleteTableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    [self setReuseIdentifier:reuseIdentifier];
}


- (void)registerAutoCompleteCellClass:(Class)cellClass forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    NSAssert(self.autoCompleteTableView, @"Must have an autoCompleteTableView to register cells to.");
    
    if(self.reuseIdentifier){
        [self unregisterAutoCompleteCellForReuseIdentifier:self.reuseIdentifier];
    }
    
    [self.autoCompleteTableView registerClass:cellClass forCellReuseIdentifier:reuseIdentifier];
    [self setReuseIdentifier:reuseIdentifier];
}


- (void)unregisterAutoCompleteCellForReuseIdentifier:(NSString *)reuseIdentifier
{
    [self.autoCompleteTableView registerNib:nil forCellReuseIdentifier:reuseIdentifier];
}

#pragma mark - Table View Delegation and Data Sourcing

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.autoCompleteSuggestions count];
    [self expandAutoCompleteTableViewForNumberOfRows:numberOfRows];
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.autoCompleteRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *DefaultCellIdentifier = @"_DefaultAutoCompleteCellIdentifier";
    
    if(!self.reuseIdentifier){
        cell = [tableView dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
        if (cell == nil) {
            cell = [self autoCompleteTableViewCellWithReuseIdentifier:DefaultCellIdentifier];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    }
    
    NSAssert(cell, @"Unable to create cell for autocomplete table");
    
    NSString *suggestedString = self.autoCompleteSuggestions[indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withAutoCompleteString:suggestedString];
    
    return cell;
}

- (UITableViewCell *)autoCompleteTableViewCellWithReuseIdentifier:(NSString *)identifier
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:self.textColor];
    [cell.textLabel setFont:self.font];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
withAutoCompleteString:(NSString *)string
{
    NSAttributedString *boldedString = nil;
    if(self.applyBoldEffectToAutoCompleteSuggestions){
        NSRange boldedRange = [[string lowercaseString]
                               rangeOfString:[self.text lowercaseString]];
        boldedString = [self boldedString:string withRange:boldedRange];
    }
    
    if([self.autoCompleteDelegate respondsToSelector:@selector(autoCompleteTextField:shouldConfigureCell:withAutoCompleteString:withAttributedString:forRowAtIndexPath:)])
    {
        if(![self.autoCompleteDelegate autoCompleteTextField:self shouldConfigureCell:cell withAutoCompleteString:string withAttributedString:boldedString forRowAtIndexPath:indexPath])
        {
            return;
        }
    }
    
    [cell.textLabel setTextColor:self.textColor];
    
    if(boldedString){
        [cell.textLabel setAttributedText:boldedString];
    } else {
        [cell.textLabel setText:string];
        [cell.textLabel setFont:[UIFont fontWithName:self.font.fontName size:self.autoCompleteFontSize]];
    }
    
    if(self.autoCompleteTableCellTextColor){
        [cell.textLabel setTextColor:self.autoCompleteTableCellTextColor];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self closeAutoCompleteTableView];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *autoCompleteString = selectedCell.textLabel.text;
    self.text = autoCompleteString;
    
    if([self.autoCompleteDelegate respondsToSelector:@selector(autoCompleteTextField:didSelectAutoCompleteString:forRowAtIndexPath:)]){
        [self.autoCompleteDelegate autoCompleteTextField:self
                             didSelectAutoCompleteString:autoCompleteString
                                       forRowAtIndexPath:indexPath];
    }
    
    [self finishedSearching];
}

#pragma mark - AutoComplete Operation Delegate


- (void)autoCompleteTermsDidLoad:(NSArray *)autocompletions
{
    [self setAutoCompleteSuggestions:autocompletions];
    [self.autoCompleteTableView reloadData];
}


#pragma mark - Notification

- (void)textFieldDidChangeWithNotification:(NSNotification *)aNotification
{
    if(aNotification.object == self){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fetchAutoCompleteSuggestions) object:nil];
        [self performSelector:@selector(fetchAutoCompleteSuggestions) withObject:nil afterDelay:kAutoCompleteRequestDelay];
    }
}

- (void)fetchAutoCompleteSuggestions
{
    [self.autoCompleteTableView setUserInteractionEnabled:NO];
    [self.autoCompleteQueue cancelAllOperations];
    [self.autoCompleteDataSource possibleAutoCompleteSuggestionsForString:self.text callback:^(NSArray *suggestions) {
        if(self.sortAutoCompleteSuggestionsByClosestMatch){
            MLPAutoCompleteOperation *operation =
            [[MLPAutoCompleteOperation alloc] initWithDelegate:self
                                              incompleteString:self.text
                                           possibleCompletions:suggestions];
            [self.autoCompleteQueue addOperation:operation];
        } else {
            [self autoCompleteTermsDidLoad:suggestions];
        } 
    }];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"borderStyle"]) {
        [self styleAutoCompleteTableForBorderStyle:self.borderStyle];
    } else if ([keyPath isEqualToString:@"autoCompleteTableView.hidden"]) {
        if(self.autoCompleteTableView.hidden){
            [self closeAutoCompleteTableView];
        } else {
            [self.autoCompleteTableView reloadData];
        }
    } else if ([keyPath isEqualToString:@"backgroundColor"]){
        [self styleAutoCompleteTableForBorderStyle:self.borderStyle];
    }
}

- (BOOL)becomeFirstResponder
{    
    [self saveCurrentShadowProperties];
    
    if(self.showAutoCompleteTableWhenEditingBegins){
        [self fetchAutoCompleteSuggestions];
    }
    
    return [super becomeFirstResponder];
}

- (void) finishedSearching
{
    [self resignFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [self restoreOriginalShadowProperties];
    [self closeAutoCompleteTableView];
    return [super resignFirstResponder];
}


#pragma mark - Open/Close

- (void)expandAutoCompleteTableViewForNumberOfRows:(NSInteger)numberOfRows
{
    NSAssert(numberOfRows >= 0,
             @"Number of rows given for auto complete table was negative, this is impossible.");
    
    if(!self.isFirstResponder){
        return;
    }
    
    [self.autoCompleteTableView.layer setCornerRadius:self.autoCompleteTableCornerRadius];
    [self.autoCompleteTableView setContentInset:self.autoCompleteContentInsets];
    [self.autoCompleteTableView setScrollIndicatorInsets:self.autoCompleteScrollIndicatorInsets];
    
    [self.autoCompleteTableView.layer setBorderColor:[self.autoCompleteTableBorderColor CGColor]];
    [self.autoCompleteTableView.layer setBorderWidth:self.autoCompleteTableBorderWidth];
    
    CGRect newAutoCompleteTableViewFrame = [[self class]
                                            autoCompleteTableViewFrameForTextField:self
                                            forNumberOfRows:numberOfRows];
    
    if(self.backgroundColor){
        [self.autoCompleteTableView setBackgroundColor:self.autoCompleteTableBackgroundColor];
    }
    
    [self.autoCompleteTableView setFrame:newAutoCompleteTableViewFrame];
    [self.autoCompleteTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    if(numberOfRows && (self.autoCompleteTableViewHidden == NO)){
        if(!self.autoCompleteTableView.superview){
            if([self.autoCompleteDelegate
                respondsToSelector:@selector(autoCompleteTextField:willShowAutoCompleteTableView:)]){
                [self.autoCompleteDelegate autoCompleteTextField:self
                                   willShowAutoCompleteTableView:self.autoCompleteTableView];
            }
        }
        
        [self.superview bringSubviewToFront:self];
        [self.superview insertSubview:self.autoCompleteTableView
                         belowSubview:self];
        [self.autoCompleteTableView setUserInteractionEnabled:YES];
        if(self.showTextFieldDropShadowWhenAutoCompleteTableIsOpen){
            [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
            [self.layer setShadowOffset:CGSizeMake(0, 1)];
            [self.layer setShadowOpacity:0.35];
        }
    } else {
        [self closeAutoCompleteTableView];
        [self restoreOriginalShadowProperties];
        [self.autoCompleteTableView.layer setShadowOpacity:0.0];
    }
}

+ (CGRect)autoCompleteTableViewFrameForTextField:(MLPAutoCompleteTextField *)textField
                                 forNumberOfRows:(NSInteger)numberOfRows
{
    CGRect newTableViewFrame = [[self class] autoCompleteTableViewFrameForTextField:textField];
    
    CGFloat maximumHeightMultiplier = (textField.maximumNumberOfAutoCompleteRows - 0.5);
    CGFloat heightMultiplier;
    if(numberOfRows >= textField.maximumNumberOfAutoCompleteRows){
        heightMultiplier = maximumHeightMultiplier;
    } else {
        heightMultiplier = numberOfRows;
    }
    
    newTableViewFrame.size.height = textField.autoCompleteRowHeight * heightMultiplier;
    newTableViewFrame.size.height += textField.autoCompleteTableView.contentInset.top;
    
    return newTableViewFrame;
}

+ (CGRect)autoCompleteTableViewFrameForTextField:(MLPAutoCompleteTextField *)textField
{
    CGRect frame = textField.frame;
    frame.origin.y += textField.frame.size.height;
    frame.origin.x += textField.autoCompleteTableOriginOffset.width;
    frame.origin.y += textField.autoCompleteTableOriginOffset.height;
    frame = CGRectInset(frame, 1, 0);
    
    return frame;
}

- (void)closeAutoCompleteTableView
{
    [self.autoCompleteTableView removeFromSuperview];
    [self restoreOriginalShadowProperties];
}

#pragma mark - Aesthetic

- (void)styleAutoCompleteTableForBorderStyle:(UITextBorderStyle)borderStyle
{
    if([self.autoCompleteDelegate respondsToSelector:@selector(autoCompleteTextField:shouldStyleAutoCompleteTableView:forBorderStyle:)]){
        if(![self.autoCompleteDelegate autoCompleteTextField:self
                            shouldStyleAutoCompleteTableView:self.autoCompleteTableView
                                              forBorderStyle:borderStyle]){
            return;
        }
    }
    
    switch (borderStyle) {
        case UITextBorderStyleRoundedRect:
            [self setRoundedRectStyleForAutoCompleteTableView];
            break;
        case UITextBorderStyleBezel:
        case UITextBorderStyleLine:
            [self setLineStyleForAutoCompleteTableView];
            break;
        case UITextBorderStyleNone:
            [self setNoneStyleForAutoCompleteTableView];
            break;
        default:
            break;
    }
}

- (void)setRoundedRectStyleForAutoCompleteTableView
{
    [self setAutoCompleteTableCornerRadius:8.0];
    [self setAutoCompleteTableOriginOffset:CGSizeMake(0, -18)];
    [self setAutoCompleteScrollIndicatorInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
    [self setAutoCompleteContentInsets:UIEdgeInsetsMake(18, 0, 0, 0)];
    [self setAutoCompleteTableBorderWidth:1.0];
    [self setAutoCompleteTableBorderColor:[UIColor colorWithWhite:0.0 alpha:0.25]];
    
    if(self.backgroundColor == [UIColor clearColor]){
        [self setAutoCompleteTableBackgroundColor:[UIColor whiteColor]];
    } else {
        [self setAutoCompleteTableBackgroundColor:self.backgroundColor];
    }
}

- (void)setLineStyleForAutoCompleteTableView
{
    [self setAutoCompleteTableCornerRadius:0.0];
    [self setAutoCompleteTableOriginOffset:CGSizeZero];
    [self setAutoCompleteScrollIndicatorInsets:UIEdgeInsetsZero];
    [self setAutoCompleteContentInsets:UIEdgeInsetsZero];
    [self setAutoCompleteTableBorderWidth:1.0];
    [self setAutoCompleteTableBorderColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    
    if(self.backgroundColor == [UIColor clearColor]){
        [self setAutoCompleteTableBackgroundColor:[UIColor whiteColor]];
    } else {
        [self setAutoCompleteTableBackgroundColor:self.backgroundColor];
    }
}

- (void)setNoneStyleForAutoCompleteTableView
{
    [self setAutoCompleteTableCornerRadius:8.0];
    [self setAutoCompleteTableOriginOffset:CGSizeMake(0, 7)];
    [self setAutoCompleteScrollIndicatorInsets:UIEdgeInsetsZero];
    [self setAutoCompleteContentInsets:UIEdgeInsetsZero];
    [self setAutoCompleteTableBorderWidth:1.0];
    
    
    UIColor *lightBlueColor = [UIColor colorWithRed:181/255.0
                                              green:204/255.0
                                               blue:255/255.0
                                              alpha:1.0];
    [self setAutoCompleteTableBorderColor:lightBlueColor];
    
    
    UIColor *blueTextColor = [UIColor colorWithRed:23/255.0
                                             green:119/255.0
                                              blue:206/255.0
                                             alpha:1.0];
    [self setAutoCompleteTableCellTextColor:blueTextColor];
    
    if(self.backgroundColor == [UIColor clearColor]){
        [self setAutoCompleteTableBackgroundColor:[UIColor whiteColor]];
    } else {
        [self setAutoCompleteTableBackgroundColor:self.backgroundColor];
    }
}

- (void)saveCurrentShadowProperties
{
    [self setOriginalShadowColor:self.layer.shadowColor];
    [self setOriginalShadowOffset:self.layer.shadowOffset];
    [self setOriginalShadowOpacity:self.layer.shadowOpacity];
}

- (void)restoreOriginalShadowProperties
{
    [self.layer setShadowColor:self.originalShadowColor];
    [self.layer setShadowOffset:self.originalShadowOffset];
    [self.layer setShadowOpacity:self.originalShadowOpacity];
}


- (NSAttributedString *)boldedString:(NSString *)string withRange:(NSRange)boldRange
{
    UIFont *boldFont = [UIFont fontWithName:self.autoCompleteBoldFontName
                                       size:self.autoCompleteFontSize];
    UIFont *regularFont = [UIFont fontWithName:self.autoCompleteRegularFontName
                                          size:self.autoCompleteFontSize];
    
    NSDictionary *boldTextAttributes = @{NSFontAttributeName : boldFont};
    NSDictionary *regularTextAttributes = @{NSFontAttributeName : regularFont};
    NSDictionary *firstAttributes;
    NSDictionary *secondAttributes;
    
    if(self.reverseAutoCompleteSuggestionsBoldEffect){
        firstAttributes = regularTextAttributes;
        secondAttributes = boldTextAttributes;
    } else {
        firstAttributes = boldTextAttributes;
        secondAttributes = regularTextAttributes;
    }
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:string
                                           attributes:firstAttributes];
    [attributedText setAttributes:secondAttributes range:boldRange];
    
    return attributedText;
}

#pragma mark - Deallocation

- (void)dealloc
{
    [self closeAutoCompleteTableView];
    [self stopObservingKeyPathsAndNotifications];
}


- (void)stopObservingKeyPathsAndNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self removeObserver:self forKeyPath:BorderStyleKeyPath];
    [self removeObserver:self forKeyPath:AutoCompleteTableViewHiddenKeyPath];
    [self removeObserver:self forKeyPath:BackgroundColorKeyPath];
}

@end












#pragma mark - 
#pragma mark - MLPAutoCompleteOperation

@implementation MLPAutoCompleteOperation

- (void)main
{
    @autoreleasepool {
        
        if (self.isCancelled){
            return;
        }
        
        NSArray *results = [self autocompleteSuggestionsForString:self.incompleteString
                                              withPossibleStrings:self.possibleCompletions];
        
        if (self.isCancelled){
            return;
        }
        
        if(!self.isCancelled){
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(autoCompleteTermsDidLoad:)
                                                        withObject:results
                                                     waitUntilDone:NO];
        }
    }
}

- (id)initWithDelegate:(id<MLPAutoCompleteOperationDelegate>)aDelegate
      incompleteString:(NSString *)string
   possibleCompletions:(NSArray *)possibleStrings
{
    self = [super init];
    if (self) {
        [self setDelegate:aDelegate];
        [self setIncompleteString:string];
        [self setPossibleCompletions:possibleStrings];
    }
    return self;
}

- (NSArray *)autocompleteSuggestionsForString:(NSString *)inputString withPossibleStrings:(NSArray *)possibleTerms
{
    if([inputString isEqualToString:@""]){
        return [NSArray array];
    }
    
    if(self.isCancelled){
        return [NSArray array];
    }
    
    NSMutableArray *editDistances = [NSMutableArray arrayWithCapacity:possibleTerms.count];
    
    
    float editDistanceOfCurrentString;
    NSDictionary *stringsWithEditDistances;
    NSUInteger maximumRange;
    for(NSString *currentString in possibleTerms) {
        
        if(self.isCancelled){
            return [NSArray array];
        }
        
        maximumRange = (inputString.length < currentString.length) ? inputString.length : currentString.length;
        editDistanceOfCurrentString = [inputString asciiLevenshteinDistanceWithString:[currentString substringWithRange:NSMakeRange(0, maximumRange)]];
        
        stringsWithEditDistances = @{@"string" : currentString ,
                                     @"editDistance" : [NSNumber numberWithFloat:editDistanceOfCurrentString]};
        [editDistances addObject:stringsWithEditDistances];
    }
    
    if(self.isCancelled){
        return [NSArray array];
    }
    
    [editDistances sortUsingComparator:^(NSDictionary *string1Dictionary,
                                         NSDictionary *string2Dictionary){
        
        return [string1Dictionary[@"editDistance"] compare:string2Dictionary[@"editDistance"]];
    }];
    
    
    NSString *suggestedString;
    NSMutableArray *prioritySuggestions = [NSMutableArray array];
    NSMutableArray *otherSuggestions = [NSMutableArray array];
    for(NSDictionary *stringsWithEditDistances in editDistances){
        
        if(self.isCancelled){
            return [NSArray array];
        }
        
        suggestedString = stringsWithEditDistances[@"string"];
        NSRange occurrenceOfInputString = [[suggestedString lowercaseString]
                                           rangeOfString:[inputString lowercaseString]];
        
        if (occurrenceOfInputString.length != 0 && occurrenceOfInputString.location == 0) {
            [prioritySuggestions addObject:suggestedString];
        } else{
            [otherSuggestions addObject:suggestedString];
        }
    }
    
    NSMutableArray *results = [NSMutableArray array];
    [results addObjectsFromArray:prioritySuggestions];
    [results addObjectsFromArray:otherSuggestions];
    
    
    return [NSArray arrayWithArray:results];
}

- (void)dealloc
{
    [self setDelegate:nil];
    [self setIncompleteString:nil];
    [self setPossibleCompletions:nil];
}

@end

