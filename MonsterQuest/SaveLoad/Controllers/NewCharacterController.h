//
//  MainMenuController.h
//  LazyQuest
//
//  Created by u0565496 on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewCharacter.h"
#import "Player.h"
#import "World.h"
#import "WorldController.h"

@interface NewCharacterController : UIViewController <UINavigationControllerDelegate, NewCharacterScreenDelegate>
{
}

-(void) startGameButtonPressedWithName:(NSString *)name;
-(void) backButtonPressed;

@end
