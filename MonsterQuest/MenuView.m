//
//  MenuView.m
//  MonsterQuest
//
//  Created by u0605593 on 2/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuView.h"


@implementation MenuView



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    _monsterdexButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _monstersButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _inventoryButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _playerStatsButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _multiplayerButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _saveGameButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _titleScreenButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    _closeMenuButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    
	
	[_monsterdexButton setFrame:CGRectMake(xOrigin, yOrigin, buttonWidth, buttonHeight)];
	[_monstersButton setFrame:CGRectMake(xOrigin, yOrigin+(1*buttonHeight)+(1*buttonSpacing), buttonWidth, buttonHeight)];
    [_inventoryButton setFrame:CGRectMake(xOrigin, yOrigin+(2*buttonHeight)+(2*buttonSpacing), buttonWidth, buttonHeight)];
    [_playerStatsButton setFrame:CGRectMake(xOrigin, yOrigin+(3*buttonHeight)+(3*buttonSpacing), buttonWidth, buttonHeight)];
    [_multiplayerButton setFrame:CGRectMake(xOrigin, yOrigin+(4*buttonHeight)+(4*buttonSpacing), buttonWidth, buttonHeight)];
    [_titleScreenButton setFrame:CGRectMake(xOrigin, yOrigin+(5*buttonHeight)+(5*buttonSpacing), buttonWidth, buttonHeight)];
    [_saveGameButton setFrame:CGRectMake(xOrigin, yOrigin+(6*buttonHeight)+(6*buttonSpacing), buttonWidth, buttonHeight)];
    [_closeMenuButton setFrame:CGRectMake(xOrigin, yOrigin+(7*buttonHeight)+(7*buttonSpacing), buttonWidth, buttonHeight)];
    
	
	[_monsterdexButton setTitle:@"Monsterdex" forState:UIControlStateNormal];
    [_monstersButton setTitle:@"Monsters" forState:UIControlStateNormal];
    [_inventoryButton setTitle:@"Inventory" forState:UIControlStateNormal];
    [_playerStatsButton setTitle:@"Player Stats" forState:UIControlStateNormal];
    [_multiplayerButton setTitle:@"Multiplayer" forState:UIControlStateNormal];
    [_saveGameButton setTitle:@"Save Game" forState:UIControlStateNormal];
    [_closeMenuButton setTitle:@"Close Menu" forState:UIControlStateNormal];
    [_titleScreenButton setTitle:@"Main Menu" forState:UIControlStateNormal];
    
	
	[_monsterdexButton addTarget:self action:@selector(monsterdexPressed) forControlEvents:UIControlEventTouchUpInside];
    [_monstersButton addTarget:self action:@selector(monstersPressed) forControlEvents:UIControlEventTouchUpInside];
    [_inventoryButton addTarget:self action:@selector(inventoryPressed) forControlEvents:UIControlEventTouchUpInside];
    [_playerStatsButton addTarget:self action:@selector(playerStatsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_multiplayerButton addTarget:self action:@selector(multiplayerPressed) forControlEvents:UIControlEventTouchUpInside];
    [_closeMenuButton addTarget:self action:@selector(closeMenuPressed) forControlEvents:UIControlEventTouchUpInside];
    [_saveGameButton addTarget:self action:@selector(saveGameButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_titleScreenButton addTarget:self action:@selector(titleScreenButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
	
	[self addSubview:_monsterdexButton];
	[self addSubview:_monstersButton];
    [self addSubview:_inventoryButton];
    [self addSubview:_playerStatsButton];
    [self addSubview:_multiplayerButton];
    [self addSubview:_saveGameButton];
    [self addSubview:_closeMenuButton];
    [self addSubview:_titleScreenButton];
    
    
    _backgroundColor = [[UIColor alloc] initWithRed:.2 green:.2 blue:.8 alpha:0.85];
    
    return self;
}

- (void)dealloc
{
    
    [_backgroundColor release];
    [_monsterdexButton release];
    [_inventoryButton release];
    [_saveGameButton release];
    [_multiplayerButton release];
    [_closeMenuButton release];
    [_titleScreenButton release];
    _delegate = nil;
    
    [super dealloc];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)drawRect:(CGRect)rect 
{
	if([self isHidden])
        return;
    
    [self setOpaque:FALSE];
	
	CGContextRef context = UIGraphicsGetCurrentContext();  
	CGContextClearRect(context, [self bounds]);
	
    int a = 4; //inset in pixels
	
	CGContextSetLineWidth(context, 4.0);
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextSetFillColorWithColor(context, [_backgroundColor CGColor]);
	
    CGContextMoveToPoint(context, 0+a, 0+a);
	CGContextAddLineToPoint(context, 0+a, rect.size.height-a);
    CGContextAddLineToPoint(context, rect.size.width-a, rect.size.height-a);
    CGContextAddLineToPoint(context, rect.size.width-a, 0+a);
    
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{

}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

}

//Button Handlers

-(void) titleScreenButtonPressed
{
    [_delegate backToTitleScreen];
}

-(void) saveGameButtonPressed
{
    [_delegate saveGame];
}

-(void) monsterdexPressed
{
    [_delegate openMonsterdex];
}
-(void) monstersPressed
{
    [_delegate openMonsters];
}
-(void) inventoryPressed
{
    [_delegate openInventory];
}
-(void) multiplayerPressed
{
    [_delegate startMultiplayer];
}
-(void) closeMenuPressed
{
    [_delegate toggleMenu];
}
-(void)playerStatsButtonPressed
{
    [_delegate openStats];
}

@synthesize delegate = _delegate;
@end