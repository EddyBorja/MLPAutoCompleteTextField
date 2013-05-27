/*!
 @header    GAITransaction.h
 @abstract  Google Analytics iOS SDK Transaction Header
 @version   2.0
 @copyright Copyright 2011 Google Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "GAITransactionItem.h"

/*! A simple class to hold transaction data. */
@interface GAITransaction : NSObject

/*! Transaction ID. */
@property(nonatomic, copy, readonly) NSString *transactionId;

/*! Transaction affiliation. */
@property(nonatomic, copy, readonly) NSString *affiliation;

/*! Revenue in micros (millionths of a currency unit). Note that this must be
 set manually because it is not updated when items are added. */
@property(nonatomic, assign) int64_t revenueMicros;

/*! Tax in micros (millionths of a currency unit). Note that this must be set
 * manually because it is not updated when items are added. */
@property(nonatomic, assign) int64_t taxMicros;

/*! Shipping cost in micros (millionths of a currency unit). Note that
 this must be set manually because it is not updated when items are added. */
@property(nonatomic, assign) int64_t shippingMicros;

/*! Transaction items, as an immutable array. */
@property(nonatomic, readonly) NSArray *items;

/*!
 Create and initialize a transaction.

 @param transactionId The transaction ID. Required (must not be `nil`).

 @param affiliation The transaction affiliation. May be `nil`.

 @return A GAITransaction object with the specified transaction ID and
 affiliation.
 */
+ (GAITransaction *)transactionWithId:(NSString *)transactionId
                      withAffiliation:(NSString *)affiliation;

/*!
 Add an item to the transaction. If an item with the same SKU already
 exists in the transaction, that item will be replaced with this one.

 @param item The GAITransactionItem to add to the transaction.
 */
- (void)addItem:(GAITransactionItem *)item;

/*!
 Add an item to the transaction. If an item with the same SKU already
 exists in the transaction, that item will be replaced with this one.

 @param productCode The item product code; must not be `nil` or empty.

 @param productName The item product name; may be `nil`.

 @param productCategory The item product category; may be `nil`.

 @param priceMicros The item price, in micros (millionths of a currency unit).

 @param quantity The item quantity, as an NSInteger.

 @return The newly initialized item.
 */
- (void)addItemWithCode:(NSString *)productCode
                   name:(NSString *)productName
               category:(NSString *)productCategory
            priceMicros:(int64_t)priceMicros
               quantity:(NSInteger)quantity;

@end
