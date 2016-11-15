//
//  BattleController.h
//  MonsterQuest
//
//  Created by u0605593 on 2/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"
#import "Skill.h"
#import "BattleView.h"




@interface BattleController : UIViewController <BattleDelegate>
{
    Player* _player;
    NPC* _NPC;
}

-(id) initWithPlayer:(Player*)player andEnemy:(NPC*)NPC;
-(void) endBattle;

@end
