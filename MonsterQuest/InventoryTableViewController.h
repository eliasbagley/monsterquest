//
//  MonsterTableViewController.h
//  MonsterQuest
//
//  Created by u0605593 on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "World.h"
#import "Consumable.h"
#import "MonsterTableViewController.h"


#define consumableNameLabelXOffset 65
#define consumableInfoLabelXOffset 65

#define consumableNameLabelYOffset 2
#define consumableInfoLabelYOffset 17

#define infoLabelWidth 240

#define cellBufferRoom 30

@interface InventoryTableViewController : UITableViewController
{
    Player* _player;    
    int _tab;           //0=both,1=consumables,2=equipment
    
    NSIndexPath* _selectedRow;
    
    NSObject<WorldDelegate>* _worldDelegate;
    NSObject<BattleDelegate>* _battleDelegate;
    NSObject<EquipmentDelegate>* _equipmentDelegate;
    int _equipmentDelegateSlot;
}


-(id) initWithPlayer:(Player*) player;

@property(nonatomic, assign) NSObject<BattleDelegate>* battleDelegate;
@property(nonatomic, assign) NSObject<WorldDelegate>* worldDelegate;
@property(nonatomic, assign) NSObject<EquipmentDelegate>* equipmentDelegate;
@property(nonatomic, assign) int equipmentDelegateSlot;
@property(nonatomic, assign) int tab;



@end


//change equipment background picture to be slightly darker
//add tab buttons to switch tabs
//in monster detail view controller allow equipping items