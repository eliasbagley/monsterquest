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
#define MovementSpeed 8.0//Grid coordinates per second //8.0
#define npcMovementSpeed 1.5               //1.5
#define collisionTolerance .25 //number between 0 and 1. how close he can move to the neighboring cell if it collides. 0 = center of current cell 1 = wall of current cell
#define sideTolerance 1.00
#define worldScale 1  //note: this is the scale of what you see.
#define chanceToEncounterWildMonster .01 //.01

#define realPPB 16 //pixels per block



@protocol WorldDelegate
-(Player*) getPlayer;
-(void) playerChanged:(Player*)player;
-(void) loadZones:(Zone*)zone NorthZone:(Zone*)nZone SouthZone:(Zone*)sZone WestZone:(Zone*)wZone EastZone:(Zone*)eZone NorthWestZone:(Zone*)nwZone SouthWestZone:(Zone*)swZone NorthEastZone:(Zone*)neZone SouthEastZone:(Zone*)seZone;
-(void) movePlayerOneStep;
-(void) setPlayerMoveDirection:(int)direction;
-(void) toggleMenu;
-(void) interactWithNPC:(NPC *)npc;
-(void) initiateCombatWithEnemy:(NPC*)NPC;
-(void) seenByHostileNPC:(NPC*)npc;
-(void) openMonsterdex;
-(void) openMonsters;
-(void) openInventory;
-(void) openStats;
-(void) backToTitleScreen;
-(void) saveGame;
-(void) healMonsters;
-(void) useConsumable:(Consumable*)consumable onMonster:(Monster*)monster;
-(bool) chargePlayerGold:(int)amount;
-(void) startMultiplayer;
@end

@protocol BattleDelegate
-(Player*) getPlayer;
-(void) playerChoosesSkill:(Skill*)skill;
-(void) attemptRun;
-(void) showChangeMonsterScreen:(bool)isCancellable;
-(void) showInventoryScreen;
-(void) changeToMonster:(Monster*)monster;
-(void) useConsumable:(Consumable*)consumable onMonster:(Monster*)monster;
-(void) useMonsterball:(Consumable*)monsterball;
@end

@protocol EquipmentDelegate
-(void) equipEquipmentAtSlot1:(Equipment*)equipment;
-(void) equipEquipmentAtSlot2:(Equipment*)equipment;
-(void) equipEquipmentAtSlot3:(Equipment*)equipment;
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
    
    Zone* _tempA;
    Zone* _tempB;
    Zone* _tempC;
    
    CGPoint _centeredZone;
    
    double _time;
    volatile int _zoneLock;
}


-(id) initWithPlayer:(Player*)player;
-(BOOL) npcWillCollide:(NPC*)npc;
-(void) updatePlayer;
-(void) stepWorldOnce;
-(void) moveNPCsOneStep;
-(void) movePlayerOneStep;
-(void) loadZones;
-(BOOL) playerWillCollideAtDirection:(int)direction;
-(void) walkingInGrass;
-(void) teleportCheck;
-(void) loadEastZones;
-(void) loadWestZones;
-(void) NPCAggroCheck;
-(void) loadNorthZones;


@property(nonatomic, assign) NSObject<WorldDelegate>* delegate;
@property(nonatomic, retain) Zone* zone;
@property(nonatomic, retain) Player* player;

@end

