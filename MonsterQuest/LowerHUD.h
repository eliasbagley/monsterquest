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

@interface LowerHUD : UIView 
{
    UILabel* _buttonLabel1;  //top left
    UILabel* _buttonLabel2;  //top right
    UILabel* _buttonLabel3;  //bottom left
    UILabel* _buttonLabel4;  //bottom right
    
    UILabel* _buttonLabel5;  //long thin one below 3 and 4. 'back' button
    
    Skill* _skill1;
    Skill* _skill2;
    Skill* _skill3;
    Skill* _skill4;
}

-(void) setSkill:(int)skillNumber withSkill:(Skill*)skill;

@property(nonatomic, readonly) Skill* skill1;
@property(nonatomic, readonly) Skill* skill2;
@property(nonatomic, readonly) Skill* skill3;
@property(nonatomic, readonly) Skill* skill4;


@end
