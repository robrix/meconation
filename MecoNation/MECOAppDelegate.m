//
//  MECOAppDelegate.m
//  MecoNation
//
//  Created by Rob Rix on 2012-12-28.
//  Copyright (c) 2012 Micah Merswolke. All rights reserved.
//

#import "MECOAppDelegate.h"
#import "TestFlight.h"

static NSString * const MECOTestFlightAppToken = @"9c331c6d-1a78-458d-9493-c49d7ae16e12";

@protocol MECOUniqueIdentifying <NSObject>
@property (nonatomic, readonly) NSString *uniqueIdentifier;
@end

@interface UIDevice (MECOUniqueIdentifying) <MECOUniqueIdentifying>
@end

@implementation MECOAppDelegate

@synthesize window = _window;

-(void)applicationDidFinishLaunching:(UIApplication *)application {
	id<MECOUniqueIdentifying> device = [UIDevice currentDevice];
	[TestFlight setDeviceIdentifier:device.uniqueIdentifier];
	[TestFlight takeOff:MECOTestFlightAppToken];
}

@end
