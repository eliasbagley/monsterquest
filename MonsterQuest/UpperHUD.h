//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Monster.h"
#import "World.h"


#define nameYOffset 7

#define healthBarWidth 140
#define healthBarHeight 10
#define healthBarXOffset 10
#define healthBarYOffset 35

#define expBarWidth 100
#define expBarHeight 5
#define expBarXOffset 10
#define expBarYOffset 45

#define infoXOffset 10
#define infoYOffset 45

#define BarChangeRate .3 //percent per second


@interface UpperHUD : UIView 
{
    UILabel* _leftName;
    UILabel* _leftInfo;
    float _leftHPPercent;
    float _leftHPPercentDisplayed;
    float _leftXPPercent;
    float _leftXPPercentDisplayed;
    
    UILabel* _rightName;
    UILabel* _rightInfo;
    float _rightHPPercent;
    float _rightHPPercentDisplayed;
}

-(void) setPlayerMonster:(Monster*)monster;
-(void) setOpponentMonster:(Monster*)monster;
-(bool) animate;
+(float) absoluteValueDifference:(float)a andB:(float)b;
@end

//todo: make health bars "slide" to where the health bar is.
//make "show value" and "real value" of health.
//set it up like chatview so it only draws if it has to.