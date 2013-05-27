/*!
 @header    GAITracker.h
 @abstract  Google Analytics iOS SDK Tracker Header
 @version   2.0
 @copyright Copyright 2011 Google Inc. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "GAITransaction.h"

/*!
 Google Analytics tracking interface. Obtain instances of this interface from
 [GAI trackerWithTrackingId:] to track screens, events, transactions, timing,
 and exceptions. The implementation of this interface is thread-safe, and no
 calls are expected to block or take a long time.  All network and disk activity
 will take place in the background.
 */
@protocol GAITracker<NSObject>

/*!
 The tracking identifier (the string that begins with "UA-") this tracker is
 associated with.

 This property is read-only.
 */
@property(nonatomic, copy, readonly) NSString *trackingId;

/*!
 The application name associated with this tracker. By default, this property is
 populated with the `CFBundleName` string from the application bundle. If you
 wish to override this property, you must do so before making any tracking
 calls.
 */
@property(nonatomic, copy) NSString *appName;

/*!
 The application identifier associated with this tracker. This should be set to
 the iTunes Connect application identifier assigned to your application. By
 default, this property is `nil`. If you wish to set this property, you must do
 so before making any tracking calls.

 Note that this is not your app's bundle id (e.g. com.example.appname), but the
 identifier used by the App Store.
 */
@property(nonatomic, copy) NSString *appId;

/*!
 The application version associated with this tracker. By default, this property
 is populated with the `CFBundleShortVersionString` string from the application
 bundle. If you wish to override this property, you must do so before making any
 tracking calls.
 */
@property(nonatomic, copy) NSString *appVersion;

/*!
 Tracking data collected while this is true will be anonymized by the Google
 Analytics servers by zeroing out some of the least significant bits of the
 IP address.

 In the case of IPv4 addresses, the last octet is set to zero. For
 IPv6 addresses, the last 10 octets are set to zero, although this is subject to
 change in the future.

 By default, this flag is false.
 */
@property(nonatomic, assign) BOOL anonymize;

/*!
 Tracking information collected while this is true will be submitted to Google
 Analytics using HTTPS connection(s); otherwise, HTTP will be used. Note that
 there may be additional overhead when sending data using HTTPS in terms of
 processing costs and/or battery consumption.

 By default, this flag is true.
 */
@property(nonatomic, assign) BOOL useHttps;

/*!
 The sampleRate parameter controls the probability that the visitor will be
 sampled. By default, sampleRate is 100, which signifies no sampling. sampleRate
 may be set to any value between 0 and 100, inclusive. A value of 90 means 90%
 of visitors should be sampled (10% of visitors to be sampled out).

 When a visitor is not sampled, no data is collected by Google Analytics for iOS
 library about that visitor's activity. If your application is subject to heavy
 traffic spikes, you may wish to adjust the sample rate to ensure uninterrupted
 report tracking. Sampling in Google Analytics occurs consistently across unique
 visitors, ensuring integrity in trending and reporting even when sampling is
 enabled, because unique visitors remain included or excluded from the sample,
 as set from the initiation of sampling.
 */
@property(nonatomic, assign) double sampleRate;

/*!
 The client ID for the tracker.

 This is a persistent unique identifier generated the first time the library is
 called and persisted unchanged thereafter. It is used to identify the client
 across multiple application sessions.
 */
@property(nonatomic, copy, readonly) NSString *clientId;

/*!
 The current screen set for this tracker.

 Calling trackView: will also update this property before it dispatches tracking
 information to Google Analytics. However, if you wish to update the current
 screen without sending any tracking information, set this property directly.
 The updated screen will be reflected in subsequent tracking information.
 */
@property(nonatomic, copy) NSString *appScreen;

/*!
 The referrer URL for this tracker. Changing this value causes it to be sent
 with the next dispatch of tracking information.
 */
@property(nonatomic, copy) NSString *referrerUrl;

/*!
 The campaign URL for this tracker. This is not directly propagated to Google
 Analytics, but if there are campaign parameter(s), either manually or
 auto-tagged, present in this URL, the SDK will include those parameters in the
 next dispatch of tracking information. Google Analytics treats tracking
 information with differing campaign information as part of separate sessions.

 For more information on auto-tagging, see
 http://support.google.com/googleanalytics/bin/answer.py?hl=en&answer=55590

 For more information on manual tagging, see
 http://support.google.com/googleanalytics/bin/answer.py?hl=en&answer=55518
 */
@property(nonatomic, copy) NSString *campaignUrl;

/*!
 If true, indicates the start of a new session. Note that when a tracker is
 first instantiated, this is initialized to true. To prevent this default
 behavior, set this to `NO` when the tracker is first obtained.

 By itself, setting this does not send any data. If this is true, when the next
 tracking call is made, a parameter will be added to the resulting tracking
 information indicating that it is the start of a session, and this flag will be
 cleared.
 */
@property(nonatomic, assign) BOOL sessionStart;

/*!
 If non-negative, indicates how long, in seconds, the application must
 transition to the inactive or background state for before the tracker will
 automatically indicate the start of a new session when the app becomes active
 again by setting sessionStart to true. For example, if this is set to 30
 seconds, and the user receives a phone call that lasts for 45 seconds while
 using the app, upon returning to the app, the sessionStart parameter will be
 set to true. If the phone call instead lasted 10 seconds, sessionStart will not
 be modified.

 To disable automatic session tracking, set this to a negative value. To
 indicate the start of a session anytime the app becomes inactive or
 backgrounded, set this to zero.

 By default, this is 30 seconds.
 */
@property(nonatomic, assign) NSTimeInterval sessionTimeout;

/*!
 Track that the current screen (as set in appScreen) was displayed. If appScreen
 has not been set, this will not generate any tracking information.

 If [GAI optOut] is true, this will not generate any tracking information.

 @return `YES` if the tracking information was queued for dispatch, or `NO` if
 there was an error (e.g. the tracker was closed or appScreen is not set).
 */
- (BOOL)sendView;

/*!
 This method is deprecated.  See sendView.
 */
- (BOOL)trackView;

/*!
 Track that the specified view or screen was displayed. This call sets
 the appScreen property and generates tracking information to be sent to Google
 Analytics.

 If [GAI optOut] is true, this will not generate any tracking information.

 @param screen The name of the screen. Must not be `nil`.

 @return `YES` if the tracking information was queued for dispatch, or `NO` if
 there was an error (e.g. the tracker was closed).
 */
- (BOOL)sendView:(NSString *)screen;

/*!
 This method is deprecated.  See sendView.
 */
- (BOOL)trackView:(NSString *)screen;

/*!
 Track an event.

 If [GAI optOut] is true, this will not generate any tracking information.

 @param category The event category, or `nil` if none.

 @param action The event action, or `nil` if none.

 @param label The event label, or `nil` if none.

 @param value The event value, to be interpreted as a 64-bit signed integer, or
 `nil` if none.

 @return `YES` if the tracking information was queued for dispatch, or `NO` if
 there was an error (e.g. the tracker was closed).
 */
- (BOOL)sendEventWithCategory:(NSString *)category
                   withAction:(NSString *)action
                    withLabel:(NSString *)label
                    withValue:(NSNumber *)value;

/*!
 This method is deprecated. See sendEventWithCategory.
 */
- (BOOL)trackEventWithCategory:(NSString *)category
                    withAction:(NSString *)action
                     withLabel:(NSString *)label
                     withValue:(NSNumber *)value;

/*!
 Track a transaction.

 If [GAI optOut] is true, this will not generate any tracking information.

 @param transaction The GAITransaction object.

 @return `YES` if the tracking information was queued for dispatch, or `NO` if
 there was an error (e.g. the tracker was closed).
 */
- (BOOL)sendTransaction:(GAITransaction *)transaction;

/*!
 This method is deprecated. see sendTransaction.
 */
- (BOOL)trackTransaction:(GAITransaction *)transaction;

/*!
 Track an exception.

 If [GAI optOut] is true, this will not generate any tracking information.

 @param isFatal A boolean indicating whether the exception is fatal.

 @param format A format string that will be used to create the exception
 description.

 @param ... An optional list of arguments to be substituted using the format
 string.

 @return `YES` if the tracking information was queued for dispatch, or `NO` if
 there was an error (e.g. the tracker was closed).
 */
- (BOOL)sendException:(BOOL)isFatal
      withDescription:(NSString *)format, ...;

/*!
 This method is deprecated. See sendException.
 */
- (BOOL)trackException:(BOOL)isFatal
       withDescription:(NSString *)format, ...;

/*! Convenience method for tracking an NSException that passes the exception
 name to trackException:withDescription:.

 If [GAI optOut] is true, this will not generate any tracking information.

 @param isFatal A boolean indicating whether the exception is fatal.

 @param exception The NSException exception object.

 @return `YES` if the tracking information was queued for dispatch, or `NO` if
 there was an error (e.g. the tracker was closed).
 */
- (BOOL)sendException:(BOOL)isFatal
      withNSException:(NSException *)exception;

/*!
 This method is deprecated. See sendException.
 */
- (BOOL)trackException:(BOOL)isFatal
       withNSException:(NSException *)exception;

/*! Convenience method for tracking an NSError that passes the domain, code, and
 description to trackException:withDescription:.

 If [GAI optOut] is true, this will not generate any tracking information.

 @param isFatal A boolean indicating whether the exception is fatal.

 @param error The NSError error object.

 @return `YES` if the tracking information was queued for dispatch, or `NO` if
 there was an error (e.g. the tracker was closed).
 */
- (BOOL)sendException:(BOOL)isFatal
          withNSError:(NSError *)error;

/*!
 This method is deprecated. See sendException.
 */
- (BOOL)trackException:(BOOL)isFatal
           withNSError:(NSError *)error;

/*!
 Track user timing.

 If [GAI optOut] is true, this will not generate any tracking information.

 @param category A string representing a timing category.

 @param time A timing value.

 @param name A string representing a timing name, or `nil` if none.

 @param label A string representing a timing variable label, or `nil` if none.

 @return `YES` if the tracking information was queued for dispatch, or `NO` if
 there was an error (e.g. the tracker was closed).
 */
- (BOOL)sendTimingWithCategory:(NSString *)category
                     withValue:(NSTimeInterval)time
                      withName:(NSString *)name
                     withLabel:(NSString *)label;

/*!
 This method is deprecated. See sendTimingWithCategory.
 */
- (BOOL)trackTimingWithCategory:(NSString *)category
                      withValue:(NSTimeInterval)time
                       withName:(NSString *)name
                      withLabel:(NSString *)label;

/*!
 Track social action.

 If [GAI optOut] is true, this will not generate any tracking information.

 @param network A string representing social network. Must not be nil.

 @param action A string representing a social action. Must not be nil.

 @param target A string representing the target. May be nil.

 @return `YES` if the tracking information was queued for dispatch, or `NO` if
 there was an error (e.g. the tracker was closed).
 */
- (BOOL)sendSocial:(NSString *)network
        withAction:(NSString *)action
        withTarget:(NSString *)target;

/*!
 This method is deprecated. See sendSocial.
 */
- (BOOL)trackSocial:(NSString *)network
         withAction:(NSString *)action
         withTarget:(NSString *)target;

/*!
 Set a tracking parameter.

 @param parameterName The parameter name.

 @param value The value to set for the parameter. If this is `nil`, the
 value for the parameter will be cleared.

 @returns `YES` if the parameter was set to the given value, or `NO` if there
 was an error (e.g. unknown parameter).
 */
- (BOOL)set:(NSString *)parameterName
      value:(NSString *)value;

/*!
 Get a tracking parameter.

 @param parameterName The parameter name.

 @returns The parameter value, or `nil` if no value for the given parameter is
 set.
 */
- (NSString *)get:(NSString *)parameterName;

/*!
 Queue tracking information with the given parameter values.

 @param trackType The type of tracking information, e.g., @"appview".

 @param parameters A map from parameter names to parameter values which will be
 set just for this piece of tracking information.

 @return `YES` if the tracking information was queued for submission, or `NO`
 if an error occurred (e.g. bad track type).
 */
- (BOOL)send:(NSString *)trackType
      params:(NSDictionary *)parameters;

/*!
 Set a custom dimension value, to be sent at the next tracking call.

 @param index The index at which to set the dimension. Must be positive.

 @param dimension The dimension value, or `nil` if the dimension at the given
 index is to be cleared.

 @return `YES` on success, or `NO` if an error occurred.
 */
- (BOOL)setCustom:(NSInteger)index
        dimension:(NSString *)dimension;

/*!
 Set a custom metric value, to be sent at the next tracking call.

 @param index The index at which to set the metric. Must be positive.

 @param metric The metric value, which will be interpreted as a signed 64-bit
 integer, or `nil` if the metric at the given index is to be cleared.

 @return `YES` on success, or `NO` if an error occurred.
 */
- (BOOL)setCustom:(NSInteger)index
           metric:(NSNumber *)metric;

/*!
 Close the tracker. This will mark it as closed and remove it from the list of
 trackers accessible through [GAI trackerWithTrackingId:], thus decrementing its
 reference count (and causing it to be dealloced unless it has been retained by
 the application). Once this method has been called, it is an error to call any
 of the tracking methods, and they will not result in the generation of any
 tracking information to be submitted to Google Analytics.
 */
- (void)close;

@end
