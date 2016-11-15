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
    [super dealloc];
}

    
-(id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self == nil)
            return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    
    //Create sublayers
    _zonesBaseView = [[[ZonesView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
    _zonesOverlayView = [[[ZonesView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
    
    _zonesBaseView.drawBaseLayer = 1;
    _zonesOverlayView.drawOverlayLayer = 1;
    
    _NPCsView = [[[NPCsView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
    _playerView = [[[PlayerView alloc] initWithFrame:CGRectMake(160 - (ppb/2), 245 - (30*ppb/32), ppb, (ppb*50/32))] autorelease];
    
    _menuView = [[[MenuView alloc] initWithFrame:CGRectMake(160, 0, 160, 200)] autorelease];
    _chatView = [[[ChatView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)] autorelease];
    
    //Combine layers
    [self addSubview:_zonesBaseView];
    [self addSubview:_NPCsView];
    [self addSubview:_playerView];
    [self addSubview:_zonesOverlayView];
    [self addSubview:_menuView];
    [self addSubview:_chatView];
    
    _menuView.hidden=1;

    
    //Add swipe
    /*
    UISwipeGestureRecognizer *swipeUp =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    UISwipeGestureRecognizer *swipeDown =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    UISwipeGestureRecognizer *swipeLeft =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    UISwipeGestureRecognizer *swipeRight =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeUp];
    [self addGestureRecognizer:swipeDown];
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeRight];
     */
    
    return self;
}

/*
-(void)swipeUp
{
    [_delegate setPlayerMoveDirection:NORTH];
}
-(void)swipeDown
{
    [_delegate setPlayerMoveDirection:SOUTH];}
-(void)swipeLeft
{
    [_delegate setPlayerMoveDirection:WEST];
}
-(void)swipeRight
{
    [_delegate setPlayerMoveDirection:EAST];
}
*/

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
    int newXDrawPos = 0+160 - (ppb/2) - (ppb * _playerView.player.xPos) - (ppb * _playerView.player.xSubPos);
    int newYDrawPos = 0+240 - (ppb * _playerView.player.yPos) - (ppb * _playerView.player.ySubPos);
    
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
        //[_delegate setPlayerMoveDirection:-1];
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
        [_menuView setHidden:0];
    else
        [_menuView setHidden:1];
}

@synthesize delegate = _delegate;
@synthesize zonesBaseView = _zonesBaseView;
@synthesize playerView = _playerView;
@synthesize NPCsView = _NPCsView;
@synthesize menuView = _menuView;
@synthesize chatView = _chatView;

@end