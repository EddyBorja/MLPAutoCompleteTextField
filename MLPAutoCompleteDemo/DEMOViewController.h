//
//  MLPViewController.h
//  MLPAutoCompleteDemo
//
//  Created by Eddy Borja on 1/23/13.
//  Copyright (c) 2013 Mainloop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPAutoCompleteTextFieldDataSource.h"
#import "MLPAutoCompleteTextFieldDelegate.h"

@class MLPAutoCompleteTextField;
@interface DEMOViewController : UIViewController <UITextFieldDelegate, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate>

@property (weak) IBOutlet MLPAutoCompleteTextField *autocompleteTextField;
@property (strong, nonatomic) IBOutlet UILabel *demoTitle;
@property (strong, nonatomic) IBOutlet UILabel *author;

//Set this to true to prevent auto complete terms from returning instantly.
@property (assign) BOOL simulateLatency;
@end
