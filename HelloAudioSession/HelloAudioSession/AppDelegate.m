//
//  AppDelegate.m
//  HelloAudioSession
//
//  Created by Masakiyo on 2015/04/06.
//  Copyright (c) 2015年 jp.saka. All rights reserved.
//

#import "AppDelegate.h"
#import "Log.h"

@interface AppDelegate ()

@property (nonatomic) UIBackgroundTaskIdentifier taskid;
@property (nonatomic) NSTimer *timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	
	NSLog(@"%s", __FUNCTION__);
	self.taskid = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void){
		NSLog(@"%s ExpirationHandler", __FUNCTION__);
		[[UIApplication sharedApplication] endBackgroundTask:self.taskid];
	}];
	self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	[[UIApplication sharedApplication] endBackgroundTask:self.taskid];
	[self.timer invalidate];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)timer:(id)timer {
	[Log logd:[NSString stringWithFormat:@"backgroundTimeRemaining=%1.2e", [[UIApplication sharedApplication] backgroundTimeRemaining]]];
}

@end
