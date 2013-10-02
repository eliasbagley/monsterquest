//
//  tacotaco.h
//  MonsterQuest
//
//  Created by Alexander W Doub on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "World.h"
#import "MonsterTableViewController.h"


#define buysellButtonWidth 80
#define buttonOffsetFromSide 8

@interface SwapTableViewController : UITableViewController
{
    NSMutableArray* _leftInventory;
    NSMutableArray* _rightInventory;
    
    UILabel* _headerLabel;
    UILabel* _categoryLabel;
    UILabel* _goldLabel;
    
    UIButton* _leftInventoryButton;
    UIButton* _rightInventoryButton;
    
    
    
    int _tab; //0=left side. 1=rightside 
    int _monsterTradingMode;
    
    NSObject<WorldDelegate>* _worldDelegate;
}


-(id) initWithLeftSide:(NSMutableArray*)leftInventory andRightSide:(NSMutableArray*)rightInventory;
-(void) setCategory:(NSString*)string;
-(void) setToMonsterTradingMode;

@property(nonatomic, assign) NSObject<WorldDelegate>* worldDelegate;
@property(nonatomic, assign) int tab;



@end

