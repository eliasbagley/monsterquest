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
#import "ChatView.h"
#import "AnimatedMonster.h"
#import "MonsterTableView.h"
#import "AnimatedMonsterball.h"

#define UpperHUDySize 100
#define LowerHUDyOffset 320


@interface BattleView : UIView 
{
    //data
    Player* _player;
    NPC* _NPC;
    
    //views
    UpperHUD* _upperHUD;
    LowerHUD* _lowerHUD;
    ChatView* _chatView;

    AnimatedMonster* _leftMonster;
    AnimatedMonster* _rightMonster;
    
    AnimatedMonsterball* _monsterballview;    
    
    NSObject<BattleDelegate>* _delegate;
}

-(void) updateSkills;
-(void) resetBattleMenu;
-(void) performAction:(Skill*)action;
-(void) setPlayer:(Player*)player;
-(void) setNPC:(NPC*)NPC;
-(void) animate;
-(void) startRightAttackAnimation;
-(void) startLeftAttackAnimation;

-(void) startLeftDyingAnimation;
-(void) startRightDyingAnimation;

-(void) resetLeftAnimation;
-(void) resetRightAnimation;

-(void) startRightCaptureAnimation;
-(void) stopRightCaptureAnimation;

-(void) setLowerHUDHidden:(BOOL)hidden;

@property(nonatomic, assign) NSObject<BattleDelegate>* delegate;
@property(nonatomic, retain) ChatView* chatView;
@property(nonatomic, retain) UpperHUD* upperHud;


@end
