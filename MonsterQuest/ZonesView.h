//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 2/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Zone.h"
#import "ZoneView.h"
#import "NPCView.h"

#define LeftRightButtonWidth 100
#define UpDownButtonWidth 120


@interface ZonesView : UIScrollView 
{
    BOOL _drawNPCs;
      
    ZoneView* _zoneView;
    
    ZoneView* _nZoneView;
    ZoneView* _sZoneView;
    ZoneView* _wZoneView;
    ZoneView* _eZoneView;
    
    ZoneView* _nwZoneView;
    ZoneView* _swZoneView;
    ZoneView* _neZoneView;
    ZoneView* _seZoneView;
    
    BOOL _drawBaseLayer;
    BOOL _drawOverlayLayer;
    
}

-(id)initWithFrame:(CGRect)frame;

-(void) loadZones:(Zone*)zone NorthZone:(Zone*)nZone SouthZone:(Zone*)sZone WestZone:(Zone*)wZone EastZone:(Zone*)eZone NorthWestZone:(Zone*)nwZone SouthWestZone:(Zone*)swZone NorthEastZone:(Zone*)neZone SouthEastZone:(Zone*)seZone;

//private method

@property (nonatomic, assign) int xDrawPos;
@property (nonatomic, assign) int yDrawPos;
@property (nonatomic, assign) BOOL drawBaseLayer;
@property (nonatomic, assign) BOOL drawOverlayLayer;



@end
