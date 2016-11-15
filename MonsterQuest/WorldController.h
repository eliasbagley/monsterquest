//
//
//  Created by u0565496 on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "World.h"
#import "WorldView.h"
#import "BattleController.h"



@interface WorldController : UIViewController <WorldDelegate>
{
    World* _world;
}



-(id) initWithWorld:(World*)world;
-(void) initiateCombatWithEnemy:(NPC*)NPC;

@end
