//
//  MonsterQuestAppDelegate.h
//  MonsterQuest
//
//  Created by u0605593 on 1/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleScreenController.h"


@class WorldController;

@interface MonsterQuestAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow* _window;
    Player* _player;
    World* _world;
    UIImage* _picture;
    //WorldController* _worldController;
    TitleScreenController* _titleController;
    
	UINavigationController* _navController;

}


@end
