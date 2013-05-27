/*!
 @header    GAI.h
 @abstract  Google Analytics iOS SDK Header
 @version   2.0
 @copyright Copyright 2011 Google Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "GAITracker.h"
#import "GAITrackedViewController.h"

/*! Google Analytics product string.  */
extern NSString *const kGAIProduct;

/*! Google Analytics version string.  */
extern NSString *const kGAIVersion;

/*!
 NSError objects returned by the Google Analytics SDK may have this error domain
 to indicate that the error originated in the Google Analytics SDK.
 */
extern NSString *const kGAIErrorDomain;

/*! Google Analytics error codes.  */
typedef enum {
  // This error code indicates that there was no error. Never used.
  kGAINoError = 0,

  // This error code indicates that there was a database-related error.
  kGAIDatabaseError,

  // This error code indicates that there was a network-related error.
  kGAINetworkError,
} GAIErrorCode;

/*!
 Google Analytics iOS top-level class. Provides facilities to create trackers
 and set behaviorial flags.
 */
@interface GAI : NSObject

/*!
 For convenience, this class exposes a default tracker instance.
 This is initialized to `nil` and will be set to the first tracker that is
 instantiated in trackerWithTrackingId:. It may be overridden as desired.

 The GAITrackedViewController class will, by default, use this tracker instance.
 */
@property(nonatomic, assign) id<GAITracker> defaultTracker;

/*!
 If true, Google Analytics debug messages will be logged with `NSLog()`. This is
 useful for debugging calls to the Google Analytics SDK.

 By default, this flag is set to `NO`. */
@property(nonatomic, assign) BOOL debug;

/*!
 When this is true, no tracking information will be gathered; tracking calls
 will effectively become no-ops. When set to true, all tracking information that
 has not yet been submitted. The value of this flag will be persisted
 automatically by the SDK.  Developers can optionally use this flag to implement
 an opt-out setting in the app to allows users to opt out of Google Analytics
 tracking.

 This is set to `NO` the first time the Google Analytics SDK is used on a
 device, and is persisted thereafter.
 */
@property(nonatomic, assign) BOOL optOut;

/*!
 If this value is negative, tracking information must be sent manually by
 calling dispatch. If this value is zero, tracking information will
 automatically be sent as soon as possible (usually immediately if the device
 has Internet connectivity). If this value is positive, tracking information
 will be automatically dispatched every dispatchInterval seconds.

 When the dispatchInterval is non-zero, setting it to zero will cause any queued
 tracking information to be sent immediately.

 By default, this is set to `120`, which indicates tracking information should
 be dispatched automatically every 120 seconds.
 */
@property(nonatomic, assign) NSTimeInterval dispatchInterval;

/*!
 When set to true, the SDK will record the currently registered uncaught
 exception handler, and then register an uncaught exception handler which tracks
 the exceptions that occurred using defaultTracker. If defaultTracker is not
 `nil`, this function will track the exception on the tracker and attempt to
 dispatch any outstanding tracking information for 5 seconds. It will then call
 the previously registered exception handler, if any. When set back to false,
 the previously registered uncaught exception handler will be restored.
 */
@property(nonatomic, assign) BOOL trackUncaughtExceptions;

/*! Get the shared instance of the Google Analytics for iOS class. */
+ (GAI *)sharedInstance;

/*!
 Create or retrieve a GAITracker implementation with the specified tracking
 ID. If the tracker for the specified tracking ID does not already exist, then
 it will be created and returned; otherwise, the existing tracker will be
 returned. If defaultTracker is not set, it will be set to the tracker instance
 returned here.

 @param trackingId The tracking ID (a string that begins with "UA-"). Must not
 be `nil` or empty.

 @return A GAITracker associated with the specified tracking ID. The tracker
 can be used to send tracking data to Google Analytics. The first time this
 method is called with a particular tracking ID, the tracker for that tracking
 ID will be returned, and subsequent calls with the same tracking ID will return
 the same instance. It is not necessary to retain the tracker because the
 tracker will be retained internally by the library.

 If an error occurs or the tracker ID is not valid, this method will return
 `nil`.
 */
- (id<GAITracker>)trackerWithTrackingId:(NSString *)trackingId;

/*!
 Dispatches any pending tracking information.

 It would be wise to call this when application is exiting to initiate the
 submission of any unsubmitted tracking information. Note that this does not
 have any effect on dispatchInterval, and can be used in conjuntion with
 periodic dispatch. */
- (void)dispatch;

@end
