//
//  WorldView.m
//  MonsterQuest
//
//  Created by u0605593 on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WorldView.h"

@implementation WorldView

- (void)dealloc
{
    [_zonesBaseView release];
    [_NPCsView release];
    [_playerView release];
    [_zonesOverlayView release];
    [_menuView release];
    [_chatView release];
    [_menuButton release];
    _delegate = nil;
    [super dealloc];
}

    
-(id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self == nil)
            return nil;
    
    [self setBackgroundColor:[UIColor blackColor]];
    
    
    //Create sublayers
    _zonesBaseView = [[ZonesView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    _zonesOverlayView = [[ZonesView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    _zonesBaseView.drawBaseLayer = 1;
    _zonesOverlayView.drawOverlayLayer = 1;
    
    _NPCsView = [[NPCsView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    _playerView = [[PlayerView alloc] initWithFrame:CGRectMake( (int)(160 - (2*playerPixelWidth/4)), 
                                                                (int)(235 - (50/2)), 
                                                                (int)(playerPixelWidth*worldScale), 
                                                                (int)(worldScale*(playerPixelWidth*50/32)))];
    
    _menuView = [[MenuView alloc] initWithFrame:CGRectMake(160, 0, 160, 300)];
    _chatView = [[ChatView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    //Combine layers
    [self addSubview:_zonesBaseView];
    [self addSubview:_NPCsView];
    [self addSubview:_playerView];
    [self addSubview:_zonesOverlayView];
    [self addSubview:_menuView];
    [self addSubview:_chatView];
    
    _menuView.hidden=1;

    _menuButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[_menuButton setFrame:CGRectMake(220, 0, 100, 25)];
	[_menuButton setTitle:@"Menu" forState:UIControlStateNormal];
	[_menuButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_menuButton];

    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)drawRect:(CGRect)rect
{
    //menus and chat view cant depend on delegates
    [_menuView setNeedsDisplay];
    [_chatView setNeedsDisplay];

}

//Player moved, so update all the views.
-(void) setPlayer:(Player*)player
{    
    [_playerView setPlayer:player];
    //half screen + half block -Pos -subPos
    int newXDrawPos = 0+160 - (worldScale*realPPB/2) - (worldScale*realPPB * _playerView.player.xPos) - (worldScale*realPPB * _playerView.player.xSubPos);
    int newYDrawPos = 0+240 - (worldScale*realPPB * _playerView.player.yPos) - (worldScale*realPPB * _playerView.player.ySubPos);
    
    _zonesBaseView.xDrawPos = newXDrawPos;
    _zonesBaseView.yDrawPos = newYDrawPos;
        
    _zonesBaseView.contentOffset = CGPointMake(-newXDrawPos, -newYDrawPos);
    _zonesOverlayView.contentOffset = CGPointMake(-newXDrawPos, -newYDrawPos);
     
    _NPCsView.xDrawPos = newXDrawPos;
    _NPCsView.yDrawPos = newYDrawPos;
        
    [_NPCsView setNeedsDisplay];
    [_playerView animateStep];
    
}

-(void) loadZones:(Zone*)zone NorthZone:(Zone*)nZone SouthZone:(Zone*)sZone WestZone:(Zone*)wZone EastZone:(Zone*)eZone NorthWestZone:(Zone*)nwZone SouthWestZone:(Zone*)swZone NorthEastZone:(Zone*)neZone SouthEastZone:(Zone*)seZone
{
    [_zonesBaseView loadZones:zone NorthZone:nZone SouthZone:sZone WestZone:wZone EastZone:eZone NorthWestZone:nwZone SouthWestZone:swZone NorthEastZone:neZone SouthEastZone:seZone];
    
    [_NPCsView loadNPCs:zone NorthZone:nZone SouthZone:sZone WestZone:wZone EastZone:eZone NorthWestZone:nwZone SouthWestZone:swZone NorthEastZone:neZone SouthEastZone:seZone];
    
    [_zonesOverlayView loadZones:zone NorthZone:nZone SouthZone:sZone WestZone:wZone EastZone:eZone NorthWestZone:nwZone SouthWestZone:swZone NorthEastZone:neZone SouthEastZone:seZone];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchpoint = [touch locationInView:self];
    
    //Pass on touch to views that should be touched
    //like player, chat, etc
    CGPoint playerViewTouchPoint = [_playerView convertPoint:touchpoint fromView:self];
    if([_playerView pointInside:playerViewTouchPoint withEvent:event])
        [_playerView touchesBegan:touches withEvent:event]; 
    
    [self touchesMoved:touches withEvent:event];    
}



-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchpoint = [touch locationInView:self];
    
    int xDir = 0; // These behave like an axis. down and left = negative, top and right = positive
    int yDir = 0;
    
    if(touchpoint.x<LeftRightButtonWidth)
        xDir = -1;
    else if(touchpoint.x>(360-LeftRightButtonWidth))
        xDir = 1;
    if(touchpoint.y<UpDownButtonWidth) 
        yDir = 1;
    else if (touchpoint.y>(480-UpDownButtonWidth))
        yDir = -1;
    
    if (xDir == 0 && yDir == 0)
        return;
    
    else if (yDir == 1 && xDir == 0)
        [_delegate setPlayerMoveDirection:NORTH];
    else if (yDir == -1 && xDir == 0)
        [_delegate setPlayerMoveDirection:SOUTH];
    else if (xDir == -1 && yDir == 0)
        [_delegate setPlayerMoveDirection:WEST];
    else if (xDir == 1 && yDir == 0)
        [_delegate setPlayerMoveDirection:EAST];
    
    else if (xDir == -1 && yDir == -1)
        [_delegate setPlayerMoveDirection:SOUTHWEST];
    else if (xDir == -1 && yDir == 1)
        [_delegate setPlayerMoveDirection:NORTHWEST];
    else if (xDir == 1 && yDir == -1)
        [_delegate setPlayerMoveDirection:SOUTHEAST];
    else if (xDir == 1 && yDir == 1)
        [_delegate setPlayerMoveDirection:NORTHEAST];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_delegate setPlayerMoveDirection:-1];
}

-(void) toggleMenu
{
    if (_menuView.isHidden)
    {
        [_menuView setHidden:0];
        [_menuButton setHidden:1];
    }
    else
    {
        [_menuView setHidden:1];
        [_menuButton setHidden:0];
    }
}

@synthesize delegate = _delegate;
@synthesize zonesBaseView = _zonesBaseView;
@synthesize playerView = _playerView;
@synthesize NPCsView = _NPCsView;
@synthesize menuView = _menuView;
@synthesize chatView = _chatView;

@end