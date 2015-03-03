//
//  main.m
//  MLPAutoCompleteDemo
//
//  Created by Eddy Borja on 1/23/13.
//  Copyright (c) 2013 Mainloop. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DEMOAppDelegate.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

#import <sys/utsname.h>

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        NSString *device =
            [[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)] ? [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)] : nil;
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *model = [NSString stringWithCString:systemInfo.machine
                                             encoding:NSUTF8StringEncoding];
        [GAI sharedInstance].trackUncaughtExceptions = YES;
        [GAI sharedInstance].dispatchInterval = 0;
        [[GAI sharedInstance] trackerWithTrackingId:@"UA-41220983-2"];

        [[GAI sharedInstance].defaultTracker send:[[[GAIDictionaryBuilder createEventWithCategory:model
                                                                                           action:@"Demo Launch"
                                                                                            label:device
                                                                                            value:nil]
                                                         set:@"start"
                                                      forKey:kGAISessionControl] build]];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([DEMOAppDelegate class]));
    }
}
