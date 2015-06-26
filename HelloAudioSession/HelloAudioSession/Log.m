//
//  Log.m
//  HelloAudioSession
//
//  Created by Masakiyo on 2015/04/12.
//  Copyright (c) 2015年 jp.saka. All rights reserved.
//

#import "Log.h"

@interface Log ()

@property (nonatomic, readwrite) NSMutableString *text;

@end

@implementation Log

static Log *sharedLog_;

+ (Log *)sharedLog {
	@synchronized(self){
		if (!sharedLog_) {
			[[self alloc] init]; // ここでは代入していない
		}
	}
	return sharedLog_;
}

- (id)init {
	self = [super init];
	if (self != nil) {
		self.text = [[NSMutableString alloc] initWithCapacity:0];
	}
	return self;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedLog_ == nil) {
			sharedLog_ = [super allocWithZone:zone];
			return sharedLog_;  // 最初の割り当てで代入し、返す
		}
	}
	return nil; // 以降の割り当てではnilを返すようにする
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

+ (void)logd:(NSString *)message {
	NSLog(@"%@", message);
	
	Log *log = [Log sharedLog];
	[log.text appendFormat:@"%@\n", message];
	
	if ([NSThread isMainThread]) {
		[log callDelegate];
	} else {
		[log performSelector:@selector(callDelegate) withObject:nil afterDelay:0.0];
	}
}

- (void)callDelegate {
	[self.delegate changed];
}

@end
