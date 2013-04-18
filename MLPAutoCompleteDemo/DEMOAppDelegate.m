//
//  MLPAppDelegate.m
//  MLPAutoCompleteDemo
//
//  Created by Eddy Borja on 1/23/13.
//  Copyright (c) 2013 Mainloop. All rights reserved.
//

#import "DEMOAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "DEMOViewController.h"

@implementation DEMOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[DEMOViewController alloc] initWithNibName:@"View" bundle:[NSBundle mainBundle]];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self.window.layer setCornerRadius:4];
    [self.window.layer setMasksToBounds:YES];
    [self.window setBackgroundColor:self.viewController.view.backgroundColor];
    return YES;
}

@end
