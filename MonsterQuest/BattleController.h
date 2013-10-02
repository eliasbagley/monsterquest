//
//  BattleController.h
//  MonsterQuest
//
//  0Created by u0605593 on 2/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "World.h"
#import "Skill.h"
#import "BattleView.h"
#import "MonsterTableViewController.h"
#import "InventoryTableViewController.h"


#import <GameKit/GameKit.h>

#define maxMonsterballHangTime 5
#define successfulRunChance .5
#define flatDamageMultiplier 1.0 //2.0 is good
#define damageVariation .15

@interface BattleController : UIViewController <BattleDelegate, GKSessionDelegate>
{
    Player* _player;
    NPC* _NPC;
    
    GKSession* _gameSession;
    NSString* _peerID;
    
    Skill* _playerSelectedSkill; 
    Skill* _enemySelectedSkill;
    
    bool _playerHasUsedTurn;
    bool _enemyHasUsedTurn;
    bool _playerWillAttack;
    bool _enemyWillAttack;
    
    float _monsterballHangTime;
    
    bool _willGivePlayerXP;
    bool _willReceiveLoot;
    bool _willEndBattle;
    bool _willShowDefeatText;
    bool _willReceiveXP;
    bool _playerWillSwitchMonster;
    bool _NPCWillSwitchMonster;
    bool _playerWillSwitchToChosenMonster;
    bool _playerLeveledUp;
    bool _playerEvolved;
    bool _enemyMonsterWillSufferMonsterball;
    bool _willCaptureMonster;
    int _waitForPlayer;
    int _playerWillSwitchToChosenMonsterIndex;
    
    NSString* _oldName;
    CADisplayLink* _frameLink;
    bool _enemyIsDone;
    GKPeerConnectionState _gameState;
    
    //music
    AVAudioPlayer* _bgmPlayer;
    AVAudioPlayer* _sfxPlayer;
}

-(id) initWithPlayer:(Player*)player andEnemy:(NPC*)NPC andSession:(GKSession*)session andPeerID:(NSString*)peerID;

-(void) receiveLoot;
-(void) npcChooseNextMonster;
-(BOOL) checkIfGameOver;
-(void) endBattle;
-(void) updateViewWithPlayer;
-(void) updateViewWithNPC;
-(bool) playerIsFaster;
-(void) resetTurns;
-(Skill*) chooseEnemySkill;
-(void) monsterUseSkillOnMonster:(Monster*)attacker usesSkill:(Skill *)skill onTarget:(Monster*) target;



@end
