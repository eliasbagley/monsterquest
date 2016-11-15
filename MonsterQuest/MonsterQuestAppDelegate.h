//
//  MonsterQuestAppDelegate.h
//  MonsterQuest
//
//  Created by u0605593 on 1/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorldController.h"



@class WorldController;

@interface MonsterQuestAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow* _window;
    Player* _player;
    World* _world;
    UIImage* _picture;
    WorldController* _worldController;
    
    
	UINavigationController* _navController;

}


@end
