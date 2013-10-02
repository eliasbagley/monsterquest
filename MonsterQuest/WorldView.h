//
//  WorldView.h
//  MonsterQuest
//
//  Created by u0605593 on 1/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerView.h"
#import "WorldController.h"
#import "ZonesView.h"
#import "MenuView.h"
#import "ChatView.h"
#import "NPCsView.h"
#import <UIKit/UISwipeGestureRecognizer.h>


#define LeftRightButtonWidth 140
#define UpDownButtonWidth 190

#define playerPixelWidth 32


@interface WorldView : UIView
{ 
    ZonesView* _zonesBaseView;
    NPCsView* _NPCsView;
    PlayerView* _playerView;
    ZonesView* _zonesOverlayView;
    MenuView* _menuView;
    ChatView* _chatView;
    
    UIButton* _menuButton;
    
	NSObject<WorldDelegate>* _delegate;

}


-(void) setPlayer:(Player*)player;
-(void) loadZones:(Zone*)zone NorthZone:(Zone*)nZone SouthZone:(Zone*)sZone WestZone:(Zone*)wZone EastZone:(Zone*)eZone NorthWestZone:(Zone*)nwZone SouthWestZone:(Zone*)swZone NorthEastZone:(Zone*)neZone SouthEastZone:(Zone*)seZone;
-(void) toggleMenu;
  
@property(nonatomic, assign) NSObject<WorldDelegate>* delegate;
@property(nonatomic, retain) PlayerView* playerView;
@property(nonatomic, retain) ZonesView* zonesBaseView;
@property(nonatomic, retain) NPCsView* NPCsView;
@property(nonatomic, retain) MenuView* menuView;
@property(nonatomic, retain) ChatView* chatView;


@end
