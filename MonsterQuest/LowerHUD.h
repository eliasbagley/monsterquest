//
//  LowerHUD.h
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monster.h"
#import "BattleViewHUDButton.h"
#import "Skill.h"

#define buttonOffset 5

enum {
    BUTTON_DISABLED = -1,
    BUTTON_NORMAL   = 0,
    BUTTON_FIRE     = 1,
    BUTTON_WATER    = 2,
    BUTTON_GRASS    = 3,
    BUTTON_ELECTRIC = 4,
    BUTTON_ROCK     = 5,
    BUTTON_PSYCHIC  = 6,
    BUTTON_GHOST    = 7
} buttonStatus;

@interface LowerHUD : UIView 
{
    UIImageView* tlButton;
    UIImageView* trButton;
    UIImageView* blButton;
    UIImageView* brButton;
    UIImageView* cButton;
    
    UILabel* _buttonLabel1;  //top left
    UILabel* _buttonLabel2;  //top right
    UILabel* _buttonLabel3;  //bottom left
    UILabel* _buttonLabel4;  //bottom right
    UILabel* _buttonLabel5;  //long thin one below 3 and 4. 'back' button
    
    Skill* _skill1;
    Skill* _skill2;
    Skill* _skill3;
    Skill* _skill4;
    Skill* _skill5;
    
}

-(void) setSkill:(int)skillNumber withSkill:(Skill*)skill;
-(void) setButton:(int)buttonIndex toState:(int)buttonStatus;
-(void) removeCancelButtonFromView;
-(void) setAllButtonsToHidden:(bool)hidden;
-(bool) buttonsAreHidden;

@property(nonatomic, readonly) Skill* skill1;
@property(nonatomic, readonly) Skill* skill2;
@property(nonatomic, readonly) Skill* skill3;
@property(nonatomic, readonly) Skill* skill4;
@property(nonatomic, readonly) Skill* skill5;


@end


//NOTE: Sometimes these skills may be dummy skills like "Items" or something. This is so we don't have 2 classes, "attacks" and "menu commands". Both are "skills".