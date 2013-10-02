//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"
#import "PlayerView.h"

@interface NPCView : UIScrollView 
{
	NSObject<WorldDelegate>* _myDelegate;
    NPC* _NPC;
    UIImageView* _NPCDrawView;
    
    //used to keep track of how many zones away from the player this NPC is
    int _zoneXPosOffset;          
    int _zoneYPosOffset;
    
    //sprite information and shit
    int _stepindex;
    float _animationProgress;
    int _drawdirection;
    UIImage* _spritesheet;
    int _xSpriteSheetPixelOffset;
    int _ySpriteSheetPixelOffset;
    
}

-(id) initWithNPC:(NPC*)npc;
-(void) animateStep;
-(void) setUpNPCView;

@property(nonatomic, retain) NPC* NPC;
@property(readonly) int _stepframe;
@property(nonatomic, assign) NSObject<WorldDelegate>* myDelegate;
@property(nonatomic, retain) Player* player;
@property(nonatomic, assign) int drawdirection;
@property(nonatomic, assign) int zoneXPosOffset;
@property(nonatomic, assign) int zoneYPosOffset;

@end
