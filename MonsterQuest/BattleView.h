//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 2/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleController.h"
#import "UpperHUD.h"
#import "LowerHUD.h"

#define LowerHUDxOffset 320



@interface BattleView : UIView 
{
    //data
    Player* _player;
    NPC* _NPC;
    
    //views
    UpperHUD* _upperHUD;
    LowerHUD* _lowerHUD;
    
    NSObject<BattleDelegate>* _delegate;
}

-(void) updateSkills;
-(void) resetBattleMenu;
-(void) performAction:(Skill*)action;
-(void) setPlayer:(Player*)player;
-(void) setNPC:(NPC*)NPC;


@property(nonatomic, assign) NSObject<BattleDelegate>* delegate;

@end
