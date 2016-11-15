//
//  Controller.m
//  LazyQuest
//
//  Created by u0565496 on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorldController.h"


@interface WorldController() 
@end

@implementation WorldController

-(id) initWithWorld:(World*)world
{
	
	self = [super init];
	if (self == nil)
		return nil;
    
    _world=world;
    
    //Set initial delegeates. Remaining delegates go in loadView
    [_world setDelegate:self];
    [_world.delegate playerChanged:_world.player];    
    
	return self;
}

-(void) dealloc
{
	[super dealloc];
}


-(WorldView*) contentView
{
	return (WorldView*)[self view];
}


-(void) loadView
{    
	WorldView* worldView = [[[WorldView alloc] initWithFrame:CGRectMake(0, 20, 320, 480)] autorelease];
    
    //set delegates
    [worldView setDelegate:self];
    [worldView.playerView setMyDelegate:self];
    [worldView.NPCsView setDelegate:self];
	[self setView:worldView];
}

-(void) viewDidLoad
{
    CADisplayLink* frameLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop)];
    frameLink.frameInterval = 1;
    [frameLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_world loadZones];
}

-(void) viewWillAppear:(BOOL)animated
{
    [_world updatePlayer];
}

-(void) gameLoop
{          
    //If player is moving, keep him moving
    if(_world.player.moving)
        [_world movePlayerOneStep];

    //draw chat if its up
    if ([self.contentView.chatView stepChatOnce])   //draw chat if it needs to
        [self.contentView.chatView setNeedsDisplay];
    
    //draw menu if its up
    [self.contentView.menuView setNeedsDisplay];
    

}


//
//DELEGATE METHODS
-(void) playerChanged:(Player*)player
{
    [[self contentView] setPlayer:player]; //calls WorldView.setPlayer
}


-(void) loadZones:(Zone *)zone NorthZone:(Zone *)nZone SouthZone:(Zone *)sZone WestZone:(Zone *)wZone EastZone:(Zone *)eZone NorthWestZone:(Zone *)nwZone SouthWestZone:(Zone *)swZone NorthEastZone:(Zone *)neZone SouthEastZone:(Zone *)seZone
{
    [[self contentView] loadZones:zone NorthZone:nZone SouthZone:sZone WestZone:wZone EastZone:eZone NorthWestZone:nwZone SouthWestZone:swZone NorthEastZone:neZone SouthEastZone:seZone]; //calls WorldView.loadZones
    
}

-(void) movePlayerOneStep
{
    [_world movePlayerOneStep];
}
-(void) setPlayerMoveDirection:(int)direction;
{
    if(direction == -1)
    {
        _world.player.moving = 0;
        [_world updatePlayer];
        return;
    }
    
    _world.player.direction = direction;
    _world.player.moving = 1;
}
-(void) toggleMenu
{
    [[self contentView] toggleMenu];
}

//NPC interacted with
//fight or talk
-(void) interactWithNPC:(NPC *)npc
{
    if ([[npc monsters]count] != 0) 
    {
        [self.contentView.chatView setChatDialog:npc.chatText];
    }
    else
    {
        [self initiateCombatWithEnemy:npc];
    }
}

-(void) initiateCombatWithEnemy:(NPC*)NPC
{
    BattleController* battleController = [[BattleController alloc] 
                                          initWithPlayer:[_world player] andEnemy:NPC];
    [self.navigationController pushViewController:battleController animated:YES];
    
}
@end
