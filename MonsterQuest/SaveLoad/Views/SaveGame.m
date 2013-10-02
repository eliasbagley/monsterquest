//
//  SaveGame.m
//  LazyQuest
//
//  Created by u0565496 on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaveGame.h"


@implementation SaveGame

-(id) initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self == nil)
		return nil;
	
    
    _saveSlotButtons = [[NSMutableArray alloc] init];
	
	_backButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[_backButton setFrame:CGRectMake(30, 413, 130, 35)];
	[_backButton setTitle:@"Back" forState:UIControlStateNormal];
	[_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage* backgroundImage = [UIImage imageNamed:@"title_screen_background"];
    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    [self addSubview:backgroundView];
	[self addSubview:_backButton];
    
    [backgroundView release];	
    
    for (int i = 0; i < 3; i++)
    {
        UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setFrame:CGRectMake(45, 220+i*60, 230, 55)];
        [b setTitle:@"empty" forState:UIControlStateNormal];
        [b addTarget:self action:@selector(slotPressed:) forControlEvents:UIControlEventTouchUpInside];
        [b setTag:i];
        b.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        b.titleLabel.textAlignment = UITextAlignmentCenter;
        
        [_saveSlotButtons addObject:b];
        [self addSubview:[_saveSlotButtons objectAtIndex:i]];
    }
	
	
    
	return self;
	
}

@synthesize delegate = _delegate;
@synthesize saveSlotButtons = _saveSlotButtons;
@synthesize backButton = _backButton;

-(void) dealloc
{
	[_backButton release];
    [_saveSlotButtons release];
    _delegate = nil;
	[super dealloc];
}


-(void) slotPressed:(id)sender
{
	[_delegate slotUsed:[sender tag]];
}

-(void) backButtonPressed
{
	[_delegate backButtonPressed];
}

@end
