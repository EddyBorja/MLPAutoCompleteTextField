/*
//  MLPAutoCompleteTextField.h
//
//
//  Created by Eddy Borja on 12/29/12.
//  Copyright (c) 2013 Mainloop LLC. All rights reserved.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"

@protocol MLPAutoCompleteOperationDelegate <NSObject>
- (void)autoCompleteTermsDidLoad:(NSArray *)autocompletions;
@end


@interface MLPAutoCompleteTextField : UITextField <UITableViewDataSource, UITableViewDelegate, MLPAutoCompleteOperationDelegate>

@property (weak) IBOutlet id <MLPAutoCompleteTextFieldDataSource> autoCompleteDataSource;
@property (weak) IBOutlet id <MLPAutoCompleteTextFieldDelegate> autoCompleteDelegate;

@property (assign) BOOL applyBoldEffectToAutoCompleteSuggestions;
@property (assign) BOOL reverseAutoCompleteSuggestionsBoldEffect;
@property (assign) BOOL showTextFieldDropShadowWhenAutoCompleteTableIsOpen;
@property (assign) BOOL showAutoCompleteTableWhenEditingBegins;

@property (assign) BOOL autoCompleteTableViewHidden;

@property (assign) CGFloat autoCompleteFontSize;
@property (strong) NSString *autoCompleteBoldFontName;
@property (strong) NSString *autoCompleteRegularFontName;

@property (assign) NSInteger maximumNumberOfAutoCompleteRows;
@property (assign) CGFloat autoCompleteRowHeight;
@property (assign) CGSize autoCompleteTableOriginOffset;
@property (assign) CGFloat autoCompleteTableCornerRadius;
@property (assign) UIEdgeInsets autoCompleteContentInsets;
@property (assign) UIEdgeInsets autoCompleteScrollIndicatorInsets;
@property (strong) UIColor *autoCompleteTableBorderColor;
@property (assign) CGFloat autoCompleteTableBorderWidth;
@property (strong) UIColor *autoCompleteTableBackgroundColor;
@property (strong) UIColor *autoCompleteTableCellTextColor;


- (void)registerAutoCompleteCellNib:(UINib *)nib forCellReuseIdentifier:(NSString *)reuseIdentifier;

- (void)registerAutoCompleteCellClass:(Class)cellClass forCellReuseIdentifier:(NSString *)reuseIdentifier;

@end


