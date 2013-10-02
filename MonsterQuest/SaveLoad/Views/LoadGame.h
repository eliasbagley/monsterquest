//
//  LoadGame.h
//  LazyQuest
//
//  Created by u0565496 on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TitleScreenController.h"

@class LoadGame;

@protocol LoadGameDelegate
-(void) slotUsed:(int)slot;
-(void) backButtonPressed;
@end

@interface LoadGame : UIView 
{
	NSObject<LoadGameDelegate>* _delegate;
    NSMutableArray* _saveSlotButtons;

	UIButton* _backButton;
	
}

@property(nonatomic, assign) NSObject<LoadGameDelegate>* delegate;
@property(nonatomic, retain) NSMutableArray* saveSlotButtons;
@property(nonatomic, retain) UIButton* backButton;

-(void) slotPressed:(id)sender;

@end
