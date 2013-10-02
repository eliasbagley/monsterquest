//
//  SaveGame.h
//  LazyQuest
//
//  Created by u0565496 on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SaveGame;

@protocol SaveGameDelegate
-(void) slotUsed:(int)slot;
-(void) backButtonPressed;
@end

@interface SaveGame : UIView 
{
	NSObject<SaveGameDelegate>* _delegate;
    NSMutableArray* _saveSlotButtons;
	UIButton* _backButton;
	
}

@property(nonatomic, assign) NSObject<SaveGameDelegate>* delegate;
@property(nonatomic, retain) NSMutableArray* saveSlotButtons;
@property(nonatomic, retain) UIButton* backButton;

-(void) slotPressed:(id)sender;

@end
