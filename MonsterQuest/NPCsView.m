//
//  NPCsView.m
//  MonsterQuest
//
//  Created by u0605593 on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NPCsView.h"


@implementation NPCsView

-(void) dealloc
{
    _delegate = nil;
    [super dealloc];
    
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    _xDrawPos = 0;
    _yDrawPos = 0;
    centerCoordinates = CGPointMake(-2002, 129312);
    
    [self setBackgroundColor:[UIColor clearColor]]; 
    
    return self;
}


-(void) drawRect:(CGRect)rect
{
    for (NPCView *view in [self subviews]) 
    {
        int x = (_xDrawPos +  (view.NPC.xSubPos*realPPB*worldScale) + (view.NPC.xPos*realPPB*worldScale) 
                 + (view.zoneXPosOffset*(ZONE_WIDTH*realPPB*worldScale))) - 10;
        int y = (_yDrawPos + (view.NPC.ySubPos*realPPB*worldScale) + (view.NPC.yPos*realPPB*worldScale)
                 - (view.zoneYPosOffset*(ZONE_HEIGHT*realPPB*worldScale))) - 30;
        
        
        if (x > -32 && x < 340 && y < 480 && y > -30) 
        {
            view.hidden = 0;
            
            if (view.frame.origin.x != x || view.frame.origin.y != y)
                view.frame = CGRectMake(x,y, worldScale*32, 48*worldScale);
            
            [view animateStep];
        }
        else
        {
            view.hidden = 1;
        }
    }
}


-(void) loadNPCs:(Zone*)zone NorthZone:(Zone*)nZone SouthZone:(Zone*)sZone WestZone:(Zone*)wZone EastZone:(Zone*)eZone NorthWestZone:(Zone*)nwZone SouthWestZone:(Zone*)swZone NorthEastZone:(Zone*)neZone SouthEastZone:(Zone*)seZone
{
    CGPoint loadedPoint = CGPointMake(zone.zoneXpos, zone.zoneYpos);
    
    if (zone)
        NSLog(@"Loaded %i,%i", (int)loadedPoint.x, (int)loadedPoint.y);
    if (!zone)
    {
        NSLog(@"touchup zone");
        
        if (nZone)
            [self populateNPCsInZone:nZone withOffsetX:0 andY:1];
        if (sZone)
            [self populateNPCsInZone:sZone withOffsetX:0 andY:-1];
        if (wZone)
            [self populateNPCsInZone:wZone withOffsetX:-1 andY:0];
        if (eZone)
            [self populateNPCsInZone:eZone withOffsetX:1 andY:0];
        
        if (nwZone)
            [self populateNPCsInZone:nwZone withOffsetX:-1 andY:1];
        if (swZone)
            [self populateNPCsInZone:swZone withOffsetX:-1 andY:-1];
        if (neZone)
            [self populateNPCsInZone:neZone withOffsetX:1 andY:1];
        if (seZone)
            [self populateNPCsInZone:seZone withOffsetX:1 andY:-1];
        
        return;
    }
    //go east
    else if (centerCoordinates.x == loadedPoint.x-1 && centerCoordinates.y == loadedPoint.y) 
    {
        for(NPCView *view in [self subviews])
        {
            view.zoneXPosOffset -= 1;
            if (view.zoneXPosOffset < -1)
                [view removeFromSuperview];
        }
    }
    //go west
    else if (centerCoordinates.x == loadedPoint.x+1 && centerCoordinates.y == loadedPoint.y) 
    {
        for(NPCView *view in [self subviews])
        {            view.zoneXPosOffset += 1;
            if (view.zoneXPosOffset > 1)
                [view removeFromSuperview];
        }
    }
    //go north
    else if (centerCoordinates.x == loadedPoint.x && centerCoordinates.y == loadedPoint.y-1) 
    {
        for(NPCView *view in [self subviews])
        {
            view.zoneYPosOffset -= 1;
            if (view.zoneYPosOffset < -1)
                [view removeFromSuperview];
        }
    }
    //go south
    else if (centerCoordinates.x == loadedPoint.x && centerCoordinates.y == loadedPoint.y+1) 
    {
        for(NPCView *view in [self subviews])
        {
            view.zoneYPosOffset += 1;
            if (view.zoneYPosOffset > 1)
                [view removeFromSuperview];
        }
    }    
    
    else
    {
        NSLog(@"slow refresh. %f,%f.  %f,%f", centerCoordinates.x, centerCoordinates.y, loadedPoint.x, loadedPoint.y);
        for(NPCView *view in [self subviews])
        {
            [view removeFromSuperview];
        }
    
        [self populateNPCsInZone:zone withOffsetX:0 andY:0];
    
        if (nZone)
            [self populateNPCsInZone:nZone withOffsetX:0 andY:1];
        if (sZone)
            [self populateNPCsInZone:sZone withOffsetX:0 andY:-1];
        if (wZone)
            [self populateNPCsInZone:wZone withOffsetX:-1 andY:0];
        if (eZone)
            [self populateNPCsInZone:eZone withOffsetX:1 andY:0];
        
        if (nwZone)
            [self populateNPCsInZone:nwZone withOffsetX:-1 andY:1];
        if (swZone)
            [self populateNPCsInZone:swZone withOffsetX:-1 andY:-1];
        if (neZone)
            [self populateNPCsInZone:neZone withOffsetX:1 andY:1];
        if (seZone)
            [self populateNPCsInZone:seZone withOffsetX:1 andY:-1];
    }
    
    centerCoordinates = loadedPoint;
}


//helper method used to save time in loading NPCs in zones
-(void) populateNPCsInZone:(Zone*)zone withOffsetX:(int)x andY:(int)y;
{
    for(int i=0; i<[[zone NPCs] count]; i++)
    {
        NPCView* thisNPCView = [[NPCView alloc] initWithNPC:[[zone NPCs] objectAtIndex:i]];
        [thisNPCView setFrame:CGRectMake(-500, -500, 0, 0)];
        [thisNPCView setMyDelegate:_delegate];
        thisNPCView.zoneXPosOffset = x;
        thisNPCView.zoneYPosOffset = y;
        thisNPCView.hidden = 1;
        [self addSubview:thisNPCView];
    }
}


@synthesize xDrawPos = _xDrawPos;
@synthesize yDrawPos = _yDrawPos;
@synthesize delegate = _delegate;
@end
