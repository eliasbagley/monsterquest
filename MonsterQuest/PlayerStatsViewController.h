//
//  PlayerStatsViewController.h
//  MonsterQuest
//
//  Created by Alexander W Doub on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "World.h"

@interface PlayerStatsViewController : UIViewController
{
    Player* _player;
}


-(id) initWithPlayer:(Player*) player;

@end
