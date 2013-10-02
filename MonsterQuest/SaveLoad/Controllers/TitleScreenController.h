//
//  TitleScreenController.h
//  LazyQuest
//
//  Created by u0565496 on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "TitleScreen.h"
#import "World.h"
#import "NewCharacterController.h"

#define maxSaveSlots 3 //PS:Change it in SaveGame.m

@interface TitleScreenController : UIViewController <TitleScreenDelegate, UINavigationControllerDelegate>
{
    AVAudioPlayer* _audioPlayer;
}

- (void) stopMusic;

@end
