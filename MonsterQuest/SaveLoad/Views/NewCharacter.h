//
//  MainMenu.h
//  LazyQuest
//
//  Created by u0565496 on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewCharacterScreenDelegate
-(void) startGameButtonPressedWithName:(NSString*)name;
-(void) backButtonPressed;
@end

@interface NewCharacter : UIView <UITextFieldDelegate>
{	
	UIButton* _startButton;
	UIButton* _backButton;

	UITextField* _nameTextField;
	NSObject<NewCharacterScreenDelegate>* _delegate;
}

@property(nonatomic, assign) NSObject<NewCharacterScreenDelegate>* delegate;
@property(nonatomic, retain) UITextField* name;
@property(nonatomic, retain) UIButton* startButton;
@property(nonatomic, retain) UIButton* backButton;

-(void) startButtonPressed;
-(void) backButtonPressed;

@end
