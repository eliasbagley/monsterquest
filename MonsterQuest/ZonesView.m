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
    
    _zoneView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    
    _nZoneView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, -ImageHeight, ImageWidth, ImageHeight)];
    _sZoneView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, ImageHeight, ImageWidth, ImageHeight)];
    _wZoneView  = [[UIImageView alloc] initWithFrame:CGRectMake(-ImageWidth, 0, ImageWidth, ImageHeight)];
    _eZoneView  = [[UIImageView alloc] initWithFrame:CGRectMake(ImageWidth, 0, ImageWidth, ImageHeight)];
    
    _nwZoneView  = [[UIImageView alloc] initWithFrame:CGRectMake(-ImageWidth, -ImageHeight,
                                                              ImageWidth, ImageHeight)];
    _swZoneView  = [[UIImageView alloc] initWithFrame:CGRectMake(-ImageWidth, ImageHeight,
                                                              ImageWidth, ImageHeight)];
    _neZoneView  = [[UIImageView alloc] initWithFrame:CGRectMake(ImageWidth, -ImageHeight,
                                                              ImageWidth, ImageHeight)];
    _seZoneView  = [[UIImageView alloc] initWithFrame:CGRectMake(ImageWidth, ImageHeight,
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

@synthesize xDrawPos = _xDrawPos;
@synthesize yDrawPos = _yDrawPos;
@synthesize drawBaseLayer = _drawBaseLayer;
@synthesize drawOverlayLayer = _drawOverlayLayer;

-(void) loadZones:(Zone*)zone NorthZone:(Zone*)nZone SouthZone:(Zone*)sZone WestZone:(Zone*)wZone EastZone:(Zone*)eZone NorthWestZone:(Zone*)nwZone SouthWestZone:(Zone*)swZone NorthEastZone:(Zone*)neZone SouthEastZone:(Zone*)seZone
{
    
    //Set Zones
    if (_drawBaseLayer) 
    {
        if (zone)
            [_zoneView setImage:[zone baseLayerImage]];
        
        if (nZone)
            [_nZoneView setImage:[nZone baseLayerImage]];
        if (sZone)
            [_sZoneView setImage:[sZone baseLayerImage]];
        if (wZone)
            [_wZoneView setImage:[wZone baseLayerImage]];
        if (eZone)
            [_eZoneView setImage:[eZone baseLayerImage]];
        
        if (nwZone)
            [_nwZoneView setImage:[nwZone baseLayerImage]];
        if (swZone)
            [_swZoneView setImage:[swZone baseLayerImage]];
        if (neZone)
            [_neZoneView setImage:[neZone baseLayerImage]];
        if (seZone)
            [_seZoneView setImage:[seZone baseLayerImage]];        
    }
    
    else if (_drawOverlayLayer)
    {
        if (zone)
            [_zoneView setImage:[zone overlayLayerImage]];
        
        if (nZone)
            [_nZoneView setImage:[nZone overlayLayerImage]];
        if (sZone)
            [_sZoneView setImage:[sZone overlayLayerImage]];
        if (wZone)
            [_wZoneView setImage:[wZone overlayLayerImage]];
        if (eZone)
            [_eZoneView setImage:[eZone overlayLayerImage]];
        
        if (nwZone)
            [_nwZoneView setImage:[nwZone overlayLayerImage]];
        if (swZone)
            [_swZoneView setImage:[swZone overlayLayerImage]];
        if (neZone)
            [_neZoneView setImage:[neZone overlayLayerImage]];
        if (seZone)
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
    

}
@end
