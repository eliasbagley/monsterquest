//
//  TitleScreenController.h
//  LazyQuest
//
//  Created by u0565496 on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TitleScreenController.h"
#import "SaveGame.h"
#import "Player.h"
#import "World.h"
#import "WorldController.h"


@interface SaveGameController : UIViewController <SaveGameDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    Player* _player;
    int _slot;
    
}

-(id) initWithPlayer:(Player*)player;

@end
