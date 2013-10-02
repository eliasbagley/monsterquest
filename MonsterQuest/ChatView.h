//
//  ChatView.h
//  MonsterQuest
//
//  Created by u0605593 on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"

#define lettersPerSecond 20.0
#define rows 4
#define pixelHeight 130

@interface ChatView : UIView 
{
    UIColor* _backgroundColor;
    float _upToMarker;
    
    NSMutableArray* _chatDialog;
    NSString* _chatDialogCurrentParagraph;    
    UIFont* _font;
}

-(bool) stepChatOnce;
-(void) stepChatCompletelyOrAdvance;
-(void) setChatDialog:(NSString*)newDialog;
-(void) setNextParagraphofChatDialog;
-(bool) isInUse;

@end
