//
//  AudioSessionManager.m
//  HelloAudioSession
//
//  Created by Masakiyo on 2015/04/06.
//  Copyright (c) 2015年 jp.saka. All rights reserved.
//

#import "AudioSessionManager.h"
#import "Log.h"

static AudioSessionManager *sharedManager_ = nil;

@interface AudioSessionManager ()
@property (nonatomic) BOOL activated;
@property (nonatomic) AVAudioPlayer *player;
@end

@implementation AudioSessionManager

+ (AudioSessionManager *)sharedManager
{
	@synchronized(self){
		if (!sharedManager_) {
			[[self alloc] init]; // ここでは代入していない
		}
	}
	return sharedManager_;
}

- (id)init
{
	self = [super init];
	if (self != nil) {
	}
	return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (sharedManager_ == nil) {
			sharedManager_ = [super allocWithZone:zone];
			return sharedManager_;  // 最初の割り当てで代入し、返す
		}
	}
	return nil; // 以降の割り当てではnilを返すようにする
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (void)activateAudioSessionMixWithOthers:(BOOL)mixWithOthers {
	NSError *error;
	
	if (self.activated) {
		[Log logd:@"Audio Session is Active"];
		return;
	}
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	if (mixWithOthers) {
		[Log logd:@"Activate Audio Session with MixWithOthers option."];
		if (![audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error]) {
			[Log logd:@"Audio Session Category Error."];
		}
	} else {
		[Log logd:@"Activate Audio Session without MixWithOthers option."];
		if (![audioSession setCategory:AVAudioSessionCategoryPlayback error:&error]) {
			[Log logd:@"Audio Session Category Error."];
		}
	}
	
	if (![audioSession setActive:YES error:&error]) {
		[Log logd:@"Audio Session Activation Failuer."];
	} else {
		[Log logd:@"Audio Session Activation Success."];
	}
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self
			   selector:@selector(SessionInterruption:)
				   name:AVAudioSessionInterruptionNotification
				 object:nil];
	
	self.activated = YES;
}

- (void)deactivateAudioSession {
	NSError *error;
	
	if (!self.activated) {
		[Log logd:@"Audio Session is NOT active"];
		return;
	}
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	if (![audioSession setActive:NO error:&error]) {
		[Log logd:@"Audio Session Deactivation Success."];
	} else {
		[Log logd:@"Audio Session Deactivation Failuer."];
	}
	
	self.activated = NO;
}

- (void)play {
	NSError *error;
	
	if (self.player) {
		[Log logd:@"Playing."];
		return;
	}
	
	//NSString *path = [[NSBundle mainBundle] pathForResource:@"GoogleMoog-DQ-16000hz" ofType:@"wav"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Google Moogでドラクエの序曲弾いてみた" ofType:@"mp3"];
	NSURL *url = [NSURL fileURLWithPath:path];
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	self.player.numberOfLoops = -1;	//infinite loop
	[self.player prepareToPlay];
	if ([self.player play]) {
		[Log logd:@"Play Audio Player Success."];
	} else {
		[Log logd:@"Play Audio Player Failuer."];
		self.player = nil;
	}
}

- (void)after30sec {
	[self activateAudioSessionMixWithOthers:YES];
	[self play];
}

- (void)playAfter30sec {
	[self performSelector:@selector(after30sec) withObject:nil afterDelay:30.0];
}

- (void)stop {
	
	if (self.player == nil) {
		[Log logd:@"Audio Player Not Playing."];
		return;
	}
	
	[self.player stop];
	self.player = nil;
	[Log logd:@"Stop Audio Player."];
}

- (void)toggle {
	
	if (self.player == nil) {
		[Log logd:@"Audio Player Not Playing."];
		return;
	}
	
	if (self.player.playing) {
		[self.player stop];
		[self.player prepareToPlay];
		[Log logd:@"一時停止 Audio Player."];
	} else {
		[self.player play];
		[Log logd:@"一時再開 Audio Player."];
	}
}

- (void)SessionInterruption: (NSNotification *)notification {
	AVAudioSessionInterruptionType interruptionType = [notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
	AVAudioSessionInterruptionOptions interruptionOptions = [notification.userInfo[AVAudioSessionInterruptionOptionKey] intValue];
	if (interruptionType == AVAudioSessionInterruptionTypeBegan) {
		[Log logd:@"Audio Interruption Began."];
		if (self.player) {
			[Log logd:@"Stop Audio Player."];
			[self.player stop];
		}
	} else if (interruptionType == AVAudioSessionInterruptionTypeEnded) {
		if (interruptionOptions == AVAudioSessionInterruptionOptionShouldResume) {
			[Log logd:@"Audio Interruption Ended with ShouldResume option."];
#if 0
			if (self.player) {
				AVAudioSession *audioSession = [AVAudioSession sharedInstance];
				NSError *error;
				if (![audioSession setActive:YES error:&error]) {
					[Log logd:@"Audio Session Activation Failuer."];
				} else {
					[Log logd:@"Audio Session Activation Success."];
					if ([self.player play]) {
						[Log logd:@"Resume Audio Player Success."];
					} else {
						[Log logd:@"Resume Audio Player Failuer."];
						self.player = nil;
					}
				}
			}
#endif
		} else {
			[Log logd:@"Audio Interruption Ended without ShouldResume option."];
		}
	}
}

@end
