//
//  MLPAutoCompleteTextFieldDelegate.h
//  MLPAutoCompleteDemo
//
//  Created by Eddy Borja on 2/5/13.
//  Copyright (c) 2013 Mainloop. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MLPAutoCompleteTextField;
@protocol MLPAutoCompleteTextFieldDelegate <NSObject>

@optional
- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
    shouldStyleAutoCompleteTableView:(UITableView *)autoCompleteTableView
                      forBorderStyle:(UITextBorderStyle)borderStyle;

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
            forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
            forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView;

@end
