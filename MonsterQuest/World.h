//
//
//  Created by u0565496 on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Zone.h"
#import "NPC.h"

#define FPS 60.0
#define MovementSpeed 4.0//Grid coordinates per second
#define collisionTolerance .8 //number between 0 and 1. how close he can move to the neighboring cell if it collides. 0 = center of current cell 1 = wall of current cell
#define ppb 32  //PIXELS PER BLOCK

//32 = normal
//16 = retina display

@protocol WorldDelegate
-(void) playerChanged:(Player*)player;
-(void) loadZones:(Zone*)zone NorthZone:(Zone*)nZone SouthZone:(Zone*)sZone WestZone:(Zone*)wZone EastZone:(Zone*)eZone NorthWestZone:(Zone*)nwZone SouthWestZone:(Zone*)swZone NorthEastZone:(Zone*)neZone SouthEastZone:(Zone*)seZone;
-(void) movePlayerOneStep;
-(void) setPlayerMoveDirection:(int)direction;
-(void) toggleMenu;
-(void) interactWithNPC:(NPC *)npc;
@end

@protocol BattleDelegate
-(void) useSkillOnEnemy:(Skill*)skill;
-(void) attemptRun;
@end

@interface World : NSObject 
{
    
	NSObject<WorldDelegate>* _delegate;
	Player* _player;
    Zone* _zone;
    
    Zone* _nZone;
    Zone* _sZone;
    Zone* _wZone;
    Zone* _eZone;
    
    Zone* _nwZone;
    Zone* _swZone;
    Zone* _neZone;
    Zone* _seZone;
}


-(id) initWithPlayer:(Player*)player;
-(void) updatePlayer;
-(void) movePlayerOneStep;
-(void) loadZones;
-(BOOL) playerWillCollideAtDirection:(int)direction;

@property(nonatomic, assign) NSObject<WorldDelegate>* delegate;
@property(nonatomic, retain) Zone* zone;
@property(nonatomic, retain) Player* player;

@end

