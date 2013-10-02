//
//  NPCsView.h
//  MonsterQuest
//
//  Created by u0605593 on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPCView.h"

@interface NPCsView : UIView 
{
    NSObject<WorldDelegate>* _delegate; //delegate to be set to subviews
    
    CGPoint centerCoordinates;
    
    int _xDrawPos;
    int _yDrawPos;
}

-(void) loadNPCs:(Zone*)zone NorthZone:(Zone*)nZone SouthZone:(Zone*)sZone WestZone:(Zone*)wZone EastZone:(Zone*)eZone NorthWestZone:(Zone*)nwZone SouthWestZone:(Zone*)swZone NorthEastZone:(Zone*)neZone SouthEastZone:(Zone*)seZone;
-(void) populateNPCsInZone:(Zone*)zone withOffsetX:(int)x andY:(int)y;


@property (nonatomic, assign) int xDrawPos;
@property (nonatomic, assign) int yDrawPos;
@property (nonatomic, assign) NSObject<WorldDelegate>* delegate;

@end
