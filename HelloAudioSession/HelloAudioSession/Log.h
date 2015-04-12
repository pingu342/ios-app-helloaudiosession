//
//  Log.h
//  HelloAudioSession
//
//  Created by Masakiyo on 2015/04/12.
//  Copyright (c) 2015年 jp.saka. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LogDelegate

- (void)changed;

@end

@interface Log : NSObject

@property (nonatomic, readonly) NSMutableString *text;

@property (nonatomic, weak) id<LogDelegate> delegate;

+ (Log *)sharedLog;
+ (void)logd:(NSString *)message;

@end
