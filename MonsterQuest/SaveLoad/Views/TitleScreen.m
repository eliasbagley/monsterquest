//
//  Menu.m
//  LazyQuest
//
//  Created by u0565496 on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TitleScreen.h"



@implementation TitleScreen

-(id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
	
	_newCharacter = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	_loadCharacter = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	
	[_newCharacter setFrame:CGRectMake(45, 280, 230, 55)];
	[_loadCharacter setFrame:CGRectMake(45, 340, 230, 55)];
	
	[_newCharacter setTitle:@"New Game" forState:UIControlStateNormal];
	[_loadCharacter setTitle:@"Load Game" forState:UIControlStateNormal];
	
	[_newCharacter addTarget:self action:@selector(newCharacterPressed) forControlEvents:UIControlEventTouchUpInside];
	[_loadCharacter addTarget:self action:@selector(loadCharacterPressed) forControlEvents:UIControlEventTouchUpInside];
	
    
	UIImage* backgroundImage = [UIImage imageNamed:@"title_screen_background"];
    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self addSubview:backgroundView];
	[self addSubview:_newCharacter];
	[self addSubview:_loadCharacter];
	
	return self;
	
}

@synthesize delegate = _delegate;
@synthesize loadCharacter = _loadCharacter;

-(void) dealloc
{
	[_newCharacter release];
	[_loadCharacter release];
    _delegate = nil;
	[super dealloc];
	
}

// called when the "new character" button is pressed
-(void) newCharacterPressed
{
	[_delegate newCharacterButtonPressed];
}

// called when the "load character" button is pressed
-(void) loadCharacterPressed
{
	[_delegate loadCharacterButtonPressed];
}

@end
