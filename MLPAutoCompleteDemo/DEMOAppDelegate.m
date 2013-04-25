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
    [self customizeAppearance];
    [self.window.layer setCornerRadius:4];
    [self.window.layer setMasksToBounds:YES];
    [self.window setBackgroundColor:self.viewController.view.backgroundColor];
    return YES;
}



- (void)customizeAppearance
{
    
    [[UISegmentedControl appearance] setBackgroundImage:self.blueBarBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setBackgroundImage:self.darkBlueBarBackground forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:self.blueDivider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}


- (UIImage *)blueBarBackground
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGRect rect = CGRectMake(0, 0, 44, 44);
    
    CGContextRef composedImageContext = CGBitmapContextCreate(NULL,
                                                              rect.size.width,
                                                              rect.size.height,
                                                              8,
                                                              rect.size.height*4,
                                                              colorSpace,
                                                              kCGImageAlphaPremultipliedFirst);
    
    
    CGPathRef path = [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 4, 4)
                                                 cornerRadius:1] CGPath];
    
    CGContextAddPath(composedImageContext, path);
    
    CGContextSetFillColorWithColor(composedImageContext, [self.mainloopBlueColor CGColor]);
    
    CGContextSaveGState(composedImageContext);
    UIColor *shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    CGContextSetShadowWithColor(composedImageContext, CGSizeMake(1, -1), 2, [shadowColor CGColor]);
   
    CGContextFillPath(composedImageContext);
    CGContextRestoreGState(composedImageContext);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(composedImageContext);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(composedImageContext);
    
    UIImage *image = [[UIImage imageWithCGImage:cgImage]
                      resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGImageRelease(cgImage);
    return image;
}


- (UIImage *)darkBlueBarBackground
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGRect rect = CGRectMake(0, 0, 44, 44);
    
    CGContextRef composedImageContext = CGBitmapContextCreate(NULL,
                                                              rect.size.width,
                                                              rect.size.height,
                                                              8,
                                                              rect.size.height*4,
                                                              colorSpace,
                                                              kCGImageAlphaPremultipliedFirst);
    
    CGRect pathRect = CGRectInset(rect, 4, 4);
    CGPathRef path = [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 4, 4)
                                                 cornerRadius:1] CGPath];
    
    CGContextAddPath(composedImageContext, path);
    
    CGContextSetFillColorWithColor(composedImageContext, [self.darkBlueColor CGColor]);
    
    CGContextFillPath(composedImageContext);
    
    CGMutablePathRef outerRectPath = CGPathCreateMutable();
    CGPathAddRect(outerRectPath, NULL, CGRectInset(pathRect, -30, -30));
    CGPathAddPath(outerRectPath, NULL, path);
    CGPathCloseSubpath(outerRectPath);
    CGContextAddPath(composedImageContext, path);
    CGContextClip(composedImageContext);
    
    UIColor *shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    CGContextSetShadowWithColor(composedImageContext, CGSizeMake(1, -1), 2, [shadowColor CGColor]);
    CGContextSetBlendMode(composedImageContext, kCGBlendModeMultiply);
    CGContextSaveGState(composedImageContext);
    CGContextAddPath(composedImageContext, outerRectPath);
    CGContextEOFillPath(composedImageContext);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(composedImageContext);
    
    CGPathRelease(outerRectPath);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(composedImageContext);
    
    UIImage *image = [[UIImage imageWithCGImage:cgImage]
                      resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGImageRelease(cgImage);
    return image;
}



- (UIImage *)blueDivider
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGRect rect = CGRectMake(0, 0, 1, 44);
    
    CGContextRef composedImageContext = CGBitmapContextCreate(NULL,
                                                              rect.size.width,
                                                              rect.size.height,
                                                              8,
                                                              rect.size.height*4,
                                                              colorSpace,
                                                              kCGImageAlphaPremultipliedFirst);
    
    
    CGPathRef path = CGPathCreateWithRect(CGRectInset(rect, 0, 4), NULL);
    
    CGContextAddPath(composedImageContext, path);
    
    CGContextSetFillColorWithColor(composedImageContext, [self.darkBlueColor CGColor]);
    
    CGContextSaveGState(composedImageContext);
    UIColor *shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    CGContextSetShadowWithColor(composedImageContext, CGSizeMake(0, -1), 2, [shadowColor CGColor]);
 
    CGContextFillPath(composedImageContext);
    CGContextRestoreGState(composedImageContext);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(composedImageContext);
    CGContextRelease(composedImageContext);
    CGColorSpaceRelease(colorSpace);
    CGPathRelease(path);
    
    UIImage *image = [[UIImage imageWithCGImage:cgImage]
                      resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    CGImageRelease(cgImage);
    return image;
}


- (UIColor *)mainloopBlueColor
{
    return [UIColor colorWithRed:0.0542516 green:0.44115  blue:0.699654 alpha:1];
}


- (UIColor *)darkBlueColor
{
    return [UIColor colorWithRed:0.0542516*0.75 green:0.44115*0.75  blue:0.699654*0.75 alpha:1];
}


@end
