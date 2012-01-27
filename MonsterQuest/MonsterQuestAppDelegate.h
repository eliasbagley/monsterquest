//
//  MonsterQuestAppDelegate.h
//  MonsterQuest
//
//  Created by u0605593 on 1/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonsterQuestViewController;

@interface MonsterQuestAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MonsterQuestViewController *viewController;

@end
