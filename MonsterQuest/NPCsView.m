//
//  NPCsView.m
//  MonsterQuest
//
//  Created by u0605593 on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NPCsView.h"


@implementation NPCsView

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    _xDrawPos = 0;
    _yDrawPos = 0;
    
    [self setBackgroundColor:[UIColor clearColor]]; 
    
    return self;
}


-(void) drawRect:(CGRect)rect
{
    for (NPCView *view in [self subviews]) 
    {
        
        view.frame = CGRectMake(
                                _xDrawPos + (view.NPC.xPos*ppb) - (view.zoneXPosOffset*(MAX_COLS*ppb)),
                                _yDrawPos + (view.NPC.yPos *ppb) - (view.zoneYPosOffset*(MAX_ROWS*ppb)),
                                ppb, 50*(ppb/32.0));
        
        [view animateStep];
    }
}


-(void) loadNPCs:(Zone*)zone NorthZone:(Zone*)nZone SouthZone:(Zone*)sZone WestZone:(Zone*)wZone EastZone:(Zone*)eZone NorthWestZone:(Zone*)nwZone SouthWestZone:(Zone*)swZone NorthEastZone:(Zone*)neZone SouthEastZone:(Zone*)seZone
{
    //Set NPCs
    //NSLog(@"NPC count = %i", [[zone NPCs] count]);
    
    //clear NPC subviews
    for(NPCView *view in [self subviews])
    {
        [view removeFromSuperview];
        //NSLog(@"removed");
    }
    
    [self populateNPCsInZone:zone withOffsetX:0 andY:0];
    
    [self populateNPCsInZone:nZone withOffsetX:0 andY:1];
    [self populateNPCsInZone:sZone withOffsetX:0 andY:-1];
    [self populateNPCsInZone:wZone withOffsetX:1 andY:0];
    [self populateNPCsInZone:eZone withOffsetX:-1 andY:0];
    
    [self populateNPCsInZone:nwZone withOffsetX:1 andY:1];
    [self populateNPCsInZone:swZone withOffsetX:1 andY:-1];
    [self populateNPCsInZone:neZone withOffsetX:-1 andY:1];
    [self populateNPCsInZone:seZone withOffsetX:-1 andY:-1];
    
}


//helper method used to save time in loading NPCs in zones
-(void) populateNPCsInZone:(Zone*)zone withOffsetX:(int)x andY:(int)y;
{
    for(int i=0; i<[[zone NPCs] count]; i++)
    {
        NPCView* thisNPCView = [[NPCView alloc] initWithNPC:[[zone NPCs] objectAtIndex:i]];
        [thisNPCView setMyDelegate:_delegate];
        thisNPCView.zoneXPosOffset = x;
        thisNPCView.zoneYPosOffset = y;
        [self addSubview:thisNPCView];
    }
}


@synthesize xDrawPos = _xDrawPos;
@synthesize yDrawPos = _yDrawPos;
@synthesize delegate = _delegate;
@end
