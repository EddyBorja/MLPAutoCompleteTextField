//
//  MLPAutoCompleteTextFieldDataSource.h
// 
//
//  Created by Eddy Borja on 12/29/12.
//  Copyright (c) 2013 Mainloop LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLPAutoCompleteTextFieldDataSource <NSObject>

@required
- (NSArray *)possibleAutoCompleteSuggestionsForString:(NSString *)string;

@end
