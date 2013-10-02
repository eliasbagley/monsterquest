//
//  BattleViewHUDButton.h
//  MonsterQuest
//
//  Created by u0605593 on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BattleViewHUDButton : UIView 
{
    UILabel* _label; 
    
}


- (id)initWithFrame:(CGRect)frame andText:(NSString*)text;

@end
