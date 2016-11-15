//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define healthBarWidth 140
#define healthBarHeight 10

#define healthBarXOffset 10
#define healthBarYOffset 35

#define nameYOffset 10



@interface UpperHUD : UIView 
{
    UILabel* _leftName;
    int _leftMaxHP;
    int _leftCurrentHP;
    int _leftLevel;
    
    UILabel* _rightName;
    int _rightMaxHP;
    int _rightCurrentHP;
    int _rightLevel;
    
}

@end
