//
//  TitleScreenController.m
//  LazyQuest
//
//  Created by u0565496 on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TitleScreenController.h"
#import "SaveGameController.h"
#import "LoadGameController.h"


@implementation TitleScreenController

-(id) init
{
	
	self = [super init];
	if (self == nil)
		return nil;
	
	
	return self;
}

-(void) dealloc
{
    [_audioPlayer release];
	[super dealloc];
}

-(TitleScreen*) contentView
{
	return (TitleScreen*)[self view];
}

-(void) loadView
{
	TitleScreen* titleScreen = [[TitleScreen alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[self setView:titleScreen];
    [titleScreen release];
	[self.navigationController setNavigationBarHidden:TRUE animated:NO];
    
    NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/menu theme.mp3", [[NSBundle mainBundle] resourcePath]]];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
}

-(void) viewDidLoad
{
	[[self contentView] setDelegate:self];
}
-(void) viewWillAppear:(BOOL)animated
{
    [_audioPlayer play];
}
-(void) newCharacterButtonPressed
{
    NewCharacterController* newCharacterController = [[NewCharacterController alloc] init];
	[self.navigationController pushViewController:newCharacterController animated:YES];
    [newCharacterController release];
}

-(void) loadCharacterButtonPressed
{
	LoadGameController* loadGameController = [[LoadGameController alloc] init];
	[self.navigationController pushViewController:loadGameController animated:YES];
	[loadGameController release];	
}

-(void) stopMusic
{
    [_audioPlayer stop];
    NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/menu theme.mp3", [[NSBundle mainBundle] resourcePath]]];
    [_audioPlayer initWithContentsOfURL:url error:nil];
}

@end
