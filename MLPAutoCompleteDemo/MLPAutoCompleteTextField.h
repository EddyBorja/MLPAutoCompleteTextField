//
//  MLPAutoCompleteTextField.h
//
//
//  Created by Eddy Borja on 12/29/12.
//  Copyright (c) 2013 Mainloop LLC. All rights reserved.
//

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


