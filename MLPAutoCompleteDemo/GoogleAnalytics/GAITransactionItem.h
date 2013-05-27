/*!
 @header    GAITransactionItem.h
 @abstract  Google Analytics iOS SDK Transaction Item Header
 @version   2.0
 @copyright Copyright 2011 Google Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

/*! A simple class to hold transaction item data. */
@interface GAITransactionItem : NSObject

/*! The item code, as a string. */
@property(nonatomic, copy, readonly)  NSString *productCode;

/*! The item name. */
@property(nonatomic, copy) NSString *productName;

/*! The item variation. */
@property(nonatomic, copy) NSString *productCategory;

/*! The item price in micros (millionths of a currency unit). */
@property(nonatomic, assign) int64_t priceMicros;

/*! The item quantity. */
@property(nonatomic, assign) NSInteger quantity;

/*!
 Create and initialize an item.

 @param productCode The item product code; must not be `nil` or empty.

 @param productName The item product name; must not be `nil` or empty.

 @param productCategory The item product category; may be `nil`.

 @param priceMicros The item price, in micros (millionths of a currency unit).

 @param quantity The item quantity, as an NSInteger.

 @return The newly initialized item.
 */
+ (GAITransactionItem *)itemWithCode:(NSString *)productCode
                                name:(NSString *)productName
                            category:(NSString *)productCategory
                         priceMicros:(int64_t)priceMicros
                            quantity:(NSInteger)quantity;

@end
