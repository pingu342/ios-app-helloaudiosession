//
//  ViewController.m
//  HelloAudioSession
//
//  Created by Masakiyo on 2015/04/06.
//  Copyright (c) 2015年 jp.saka. All rights reserved.
//

#import "ViewController.h"
#import "AudioSessionManager.h"
#import "Log.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *mixWithOthersSwitch;
@property (nonatomic, weak) IBOutlet UITextView *logTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[Log sharedLog] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[Log sharedLog] setDelegate:nil];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)activateButtonTapped:(id)sender {
	AudioSessionManager *audioSession = [AudioSessionManager sharedManager];
	[Log logd:@"Activate button is tapped."];
	[audioSession activateAudioSessionMixWithOthers:self.mixWithOthersSwitch.on];
}

- (IBAction)playButtonTapped:(id)sender {
	[Log logd:@"Play button is tapped."];
	[[AudioSessionManager sharedManager] play];
}

- (IBAction)stopButtonTapped:(id)sender {
	[Log logd:@"Stop button is tapped."];
	[[AudioSessionManager sharedManager] stop];
}

- (IBAction)toggleButtonTapped:(id)sender {
	[Log logd:@"Toggle button is tapped."];
	[[AudioSessionManager sharedManager] toggle];
}

- (IBAction)playAfter30secButtonTapped:(id)sender {
	[Log logd:@"PlayAfter30sec button is tapped."];
	[[AudioSessionManager sharedManager] playAfter30sec];
}

- (void)changed {
	[self.logTextView setText:[[Log sharedLog] text]];
}

@end
