//
//  MonsterTableViewController.h
//  MonsterQuest
//
//  Created by u0605593 on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Monster.h"
#import "MonsterDetailViewController.h"

#define monsterNameLabelXOffset 140
#define monsterInfoLabelXOffset 145

#define monsterNameLabelYOffset 5
#define monsterInfoLabelYOffset 40

@interface MonsterTableViewController : UITableViewController
{
    UIView *containerView;
    UILabel *headerLabel;
    
    UIButton* _backButton;
    UIButton* _arrangementButton;
    
    NSMutableArray* _monsters;
    Consumable* _consumableToUse;
    bool _monsterdexMode;
    bool _seenMonsters[maxMonsterCount];
    
    NSObject<WorldDelegate>* _worldDelegate;
    NSObject<BattleDelegate>* _battleDelegate;
}


-(id) initWithMonsters:(NSMutableArray*)monsters;
-(void) setMainText:(NSString*)string;
-(void) hideBackButton:(bool)isHidden;
-(void) setToMonsterdexMode:(bool[])seenList;

@property(nonatomic, assign) NSObject<BattleDelegate>* battleDelegate;
@property(nonatomic, assign) NSObject<WorldDelegate>* worldDelegate;
@property(nonatomic, retain) Consumable* consumableToUse;

@end
