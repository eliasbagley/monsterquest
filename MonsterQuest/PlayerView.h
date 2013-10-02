//
//
//  Created by u0565496 on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"

#define AnimationsPerSecond 10.0
#define SpriteSheetHeight (384*worldScale)
#define SpriteSheetWidth (384*worldScale)

@interface PlayerView : UIScrollView 
{
    
	NSObject<WorldDelegate>* _myDelegate;
    Player* _player;
    
    UIImageView* _playerDrawView;
    
    int _stepindex;
    int _drawdirection;
    float _animationProgress;
    
    UIImage* _spritesheet;
    int _xOffset;
    int _yOffset;
   
}
-(void) animateStep;

@property(readonly) int *_stepframe;
@property(nonatomic, assign) NSObject<WorldDelegate>* myDelegate;
@property(nonatomic, retain) Player* player;
@property(nonatomic, assign) int drawdirection;


@end
