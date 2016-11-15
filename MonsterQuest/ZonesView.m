//
//  MyClass.m
//  MonsterQuest
//
//  Created by u0605593 on 2/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ZonesView.h"

@interface ZonesView()
@end

@implementation ZonesView

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    _drawBaseLayer = 0;
    _drawOverlayLayer = 0;

    [self setBackgroundColor:[UIColor clearColor]]; 
    
    _zoneView  = [[ZoneView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    
    _nZoneView  = [[ZoneView alloc] initWithFrame:CGRectMake(0, -ImageHeight, ImageWidth, ImageHeight)];
    _sZoneView  = [[ZoneView alloc] initWithFrame:CGRectMake(0, ImageHeight, ImageWidth, ImageHeight)];
    _wZoneView  = [[ZoneView alloc] initWithFrame:CGRectMake(-ImageWidth, 0, ImageWidth, ImageHeight)];
    _eZoneView  = [[ZoneView alloc] initWithFrame:CGRectMake(ImageWidth, 0, ImageWidth, ImageHeight)];
    
    _nwZoneView  = [[ZoneView alloc] initWithFrame:CGRectMake(-ImageWidth, -ImageHeight,
                                                              ImageWidth, ImageHeight)];
    _swZoneView  = [[ZoneView alloc] initWithFrame:CGRectMake(-ImageWidth, ImageHeight,
                                                              ImageWidth, ImageHeight)];
    _neZoneView  = [[ZoneView alloc] initWithFrame:CGRectMake(ImageWidth, -ImageHeight,
                                                              ImageWidth, ImageHeight)];
    _seZoneView  = [[ZoneView alloc] initWithFrame:CGRectMake(ImageWidth, ImageHeight,
                                                              ImageWidth, ImageHeight)];
    
    [self addSubview:_zoneView];
    
    [self addSubview:_nZoneView];
    [self addSubview:_sZoneView];
    [self addSubview:_wZoneView];
    [self addSubview:_eZoneView];
    
    [self addSubview:_nwZoneView];
    [self addSubview:_swZoneView];
    [self addSubview:_neZoneView];
    [self addSubview:_seZoneView];
    
    self.contentSize = CGSizeMake(ImageWidth*3, ImageHeight*3);
    self.scrollEnabled = false;
    
    return self;
}


-(void) dealloc
{
	[super dealloc];
}

/*
-(void) drawRect:(CGRect)rect
{    
    NSLog(@"DONT DRAW THIS");
    return;        
}
*/
@synthesize xDrawPos = _xDrawPos;
@synthesize yDrawPos = _yDrawPos;
@synthesize drawBaseLayer = _drawBaseLayer;
@synthesize drawOverlayLayer = _drawOverlayLayer;

-(void) loadZones:(Zone*)zone NorthZone:(Zone*)nZone SouthZone:(Zone*)sZone WestZone:(Zone*)wZone EastZone:(Zone*)eZone NorthWestZone:(Zone*)nwZone SouthWestZone:(Zone*)swZone NorthEastZone:(Zone*)neZone SouthEastZone:(Zone*)seZone
{
    
    //Set Zones
    if (_drawBaseLayer) 
    {
        [_zoneView setImage:[zone baseLayerImage]];
        
        [_nZoneView setImage:[nZone baseLayerImage]];
        [_sZoneView setImage:[sZone baseLayerImage]];
        [_wZoneView setImage:[wZone baseLayerImage]];
        [_eZoneView setImage:[eZone baseLayerImage]];
        
        [_nwZoneView setImage:[nwZone baseLayerImage]];
        [_swZoneView setImage:[swZone baseLayerImage]];
        [_neZoneView setImage:[neZone baseLayerImage]];
        [_seZoneView setImage:[seZone baseLayerImage]];        
    }
    
    else if (_drawOverlayLayer)
    {
        [_zoneView setImage:[zone overlayLayerImage]];
        
        [_nZoneView setImage:[nZone overlayLayerImage]];
        [_sZoneView setImage:[sZone overlayLayerImage]];
        [_wZoneView setImage:[wZone overlayLayerImage]];
        [_eZoneView setImage:[eZone overlayLayerImage]];
        
        [_nwZoneView setImage:[nwZone overlayLayerImage]];
        [_swZoneView setImage:[swZone overlayLayerImage]];
        [_neZoneView setImage:[neZone overlayLayerImage]];
        [_seZoneView setImage:[seZone overlayLayerImage]];  
    }
    
}


-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event
{    
    return false;
    //return (point.x>LeftRightButtonWidth && point.x<(360-LeftRightButtonWidth) && point.y>UpDownButtonWidth && point.y<(480-UpDownButtonWidth));
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    NSLog(@"zone touched is the zone that draws NPCS:%i", _drawNPCs);

}
@end
