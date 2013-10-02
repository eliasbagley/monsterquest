//
//
//  Created by u0565496 on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "World.h"
#import "WorldView.h"
#import "BattleController.h"
#import "InventoryTableViewController.h"
#import "SwapTableViewController.h"
#import "SaveGameController.h"
#import "PlayerStatsViewController.h"
#import <GameKit/GameKit.h>


@interface WorldController : UIViewController <WorldDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate, UIAlertViewDelegate>
{
    World* _world;
    NPC* _NPCToFight;
    int _willInitiateSpecialNPC;
    CADisplayLink* _frameLink;
    
    //multiplayer shit
    GKSession* _gameSession;
    GKPeerPickerController* _picker;    
    NSString* _peerID;
    
    //music
    AVAudioPlayer* _bgmPlayer;
    AVAudioPlayer* _sfxPlayer;
}

-(id) initWithWorld:(World*)world;
+(NSMutableArray*) generateVendorEquipment;

@property (nonatomic, retain) GKSession *gameSession;
@property (nonatomic, retain) GKPeerPickerController* picker;



@end


//-1 = stay
// 0 = wander
// 1 = consumables
// 2 = equipment
// 3 = nurse
// 4 = monster stash
// 5 = 
// 6 = 
// 7 =
// 8 = 
// 9 =
//10 = badge 0
// up to
//18 = badge 8