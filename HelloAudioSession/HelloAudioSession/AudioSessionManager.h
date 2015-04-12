//
//  AudioSessionManager.h
//  HelloAudioSession
//
//  Created by Masakiyo on 2015/04/06.
//  Copyright (c) 2015年 jp.saka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioSessionManager : NSObject

+ (AudioSessionManager *)sharedManager;
- (void)activateAudioSessionMixWithOthers:(BOOL)mixWithOthers;
- (void)deactivateAudioSession;
- (void)play;
- (void)playAfter30sec;
- (void)stop;
- (void)toggle;

@end
