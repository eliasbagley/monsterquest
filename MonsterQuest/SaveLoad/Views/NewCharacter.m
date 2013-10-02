//
//  MainMenu.m
//  LazyQuest
//
//  Created by u0565496 on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewCharacter.h"
@interface NewCharacter()
@end

@implementation NewCharacter


-(id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
	
	_backButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[_backButton setFrame:CGRectMake(30, 413, 130, 35)];
	[_backButton setTitle:@"Back" forState:UIControlStateNormal];
	[_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	_startButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[_startButton setFrame:CGRectMake(160, 413, 130, 35)];
	[_startButton setTitle:@"Start Game" forState:UIControlStateNormal];
	[_startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	_nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(95, 205, 130, 30)];	
	_nameTextField.borderStyle = UITextBorderStyleRoundedRect;
	_nameTextField.textColor = [UIColor blackColor];
	_nameTextField.font = [UIFont systemFontOfSize:17.0];
	_nameTextField.placeholder = @"Name";
	_nameTextField.text = @"Johnson";
	_nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	
	_nameTextField.keyboardType = UIKeyboardTypeDefault;
	_nameTextField.returnKeyType = UIReturnKeyDone;
	
	_nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	_nameTextField.delegate = self;
	
	
	UIImage* backgroundImage = [UIImage imageNamed:@"title_screen_background"];
    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    
	[self addSubview:backgroundView];
	[self addSubview:_startButton];
	[self addSubview:_backButton];	
	[self addSubview:_nameTextField];
    
    [backgroundView release];
    
	return self;
	
}

@synthesize backButton = _backButton;
@synthesize delegate = _delegate;
@synthesize startButton = _startButton;
@synthesize name = _nameTextField;



-(void) dealloc
{
	[_startButton release];
	[_backButton release];
	[_nameTextField release];
    _delegate = nil;
	[super dealloc];
}


-(void) startButtonPressed
{
	[_delegate startGameButtonPressedWithName:_nameTextField.text];
}
-(void) backButtonPressed
{
	[_delegate backButtonPressed];
}


-(BOOL) textFieldShouldReturn:(UITextField*)textField
{
	[textField resignFirstResponder];
	return YES;
	
}

@end
