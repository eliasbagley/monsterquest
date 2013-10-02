//
//  MyClass.h
//  MonsterQuest
//
//  Created by u0605593 on 2/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Zone.h"
#import "NPCView.h"


#define ImageWidth (512 * worldScale)
#define ImageHeight (512 * worldScale)

@interface ZonesView : UIScrollView 
{
    BOOL _drawNPCs;
      
    UIImageView* _zoneView;
    
    UIImageView* _nZoneView;
    UIImageView* _sZoneView;
    UIImageView* _wZoneView;
    UIImageView* _eZoneView;
    
    UIImageView* _nwZoneView;
    UIImageView* _swZoneView;
    UIImageView* _neZoneView;
    UIImageView* _seZoneView;
    
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
