//
//  MainMenuController.m
//  LazyQuest
//
//  Created by u0565496 on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewCharacterController.h"


@implementation NewCharacterController


-(void) dealloc
{
    
	[super dealloc];
}

-(NewCharacter*) contentView
{
	return (NewCharacter*)[self view];
}

-(void) loadView
{
	NewCharacter* mainMenu = [[[NewCharacter alloc] initWithFrame:CGRectMake(10, 30, 300, 430)] autorelease];
	[self setView:mainMenu];
}

-(void) viewDidLoad
{
	[[self contentView] setDelegate:self];
}


-(void) startGameButtonPressedWithName:(NSString *)name
{
    Player* player = [[Player alloc] initWithName:name];
    World* world = [[World alloc] initWithPlayer:player];
    WorldController* worldController = [[WorldController alloc] initWithWorld:world];
    [self.navigationController pushViewController:worldController animated:YES];
    
    [player release];
    [world release];
	[worldController release];
}
-(void) backButtonPressed
{
	[self.navigationController popViewControllerAnimated:TRUE];
}

@end
