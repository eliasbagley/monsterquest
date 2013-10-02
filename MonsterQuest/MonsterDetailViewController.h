//
//  MonsterDetailViewController.h
//  MonsterQuest
//
//  Created by u0605593 on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Monster.h"
#import "World.h"
#import "BattleView.h"
#import "SkillDetailViewController.h"


@interface MonsterDetailViewController : UIViewController <EquipmentDelegate>
{
    Monster* _monster;
    
    UIImageView* itemView1Item;
    UIImageView* itemView2Item;
    UIImageView* itemView3Item;
    
    UILabel* detailLabel;
    
    
    NSObject<WorldDelegate>* _worldDelegate;
    NSObject<BattleDelegate>* _battleDelegate;
}

-(id) initWithMonster:(Monster*) monster;
-(void) updateStats;

@property(nonatomic, assign) NSObject<BattleDelegate>* battleDelegate;
@property(nonatomic, assign) NSObject<WorldDelegate>* worldDelegate;

@end
