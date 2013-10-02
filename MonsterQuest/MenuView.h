//
//  MenuView.h
//  MonsterQuest
//
//  Created by u0605593 on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"

#define buttonHeight 30
#define buttonWidth 140
#define buttonSpacing 5
#define xOrigin 10
#define yOrigin 10


@interface MenuView : UIView 
{
    
    UIColor* _backgroundColor;
    
    UIButton* _monsterdexButton;
    UIButton* _monstersButton;
    UIButton* _inventoryButton;
    UIButton* _playerStatsButton;
    //UIButton* _storeButton;
    UIButton* _saveGameButton;
    //UIButton* _optionsButton;
    UIButton* _multiplayerButton;
    UIButton* _closeMenuButton;
    UIButton* _titleScreenButton;
    
    
    

	NSObject<WorldDelegate>* _delegate;
    
}


@property(nonatomic, assign) NSObject<WorldDelegate>* delegate;

@end
