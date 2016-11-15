//
//  BattleController.m
//  MonsterQuest
//
//  Created by u0605593 on 2/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BattleController.h"


@implementation BattleController

-(id) initWithPlayer:(Player*)player andEnemy:(NPC*)NPC
{
	
	self = [super init];
	if (self == nil)
		return nil;
    
    _player = [player retain];
    _NPC    = [NPC retain];
            
	return self;
}

-(BattleView*) contentView
{
	return (BattleView*)[self view];
}

-(void) loadView
{   
	BattleView* _battleView = [[[BattleView alloc] initWithFrame:CGRectMake(0, 20, 320, 480)] autorelease];
    [_battleView setDelegate:self];
    [_battleView setPlayer:_player];
    [_battleView setNPC:_NPC];
    [_battleView resetBattleMenu];
    [self setView:_battleView];
}

-(void) endBattle
{
    [self.navigationController popViewControllerAnimated:TRUE];
}


//delegate methods
-(void) useSkillOnEnemy:(Skill*)skill
{
    NSLog(@"controller perform skill");
}

-(void) attemptRun
{
    [self endBattle];
}


@end
