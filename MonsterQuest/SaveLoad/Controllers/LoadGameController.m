//
//  TitleScreenController.m
//  LazyQuest
//
//  Created by u0565496 on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadGameController.h"


@implementation LoadGameController


-(void) dealloc
{
	[super dealloc];
}
-(LoadGame*) contentView
{
	return (LoadGame*)[self view];
}
-(void) loadView
{
	LoadGame* loadgameScreen = [[LoadGame alloc] initWithFrame:CGRectMake(10, 30, 300, 430)];
	[self setView:loadgameScreen];
    [loadgameScreen release];
	[self.navigationController setNavigationBarHidden:TRUE animated:NO];
}

-(void) viewDidLoad
{
	[[self contentView] setDelegate:self];
    
    
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < maxSaveSlots; i++)
    {
        NSString* slotString = [NSString stringWithFormat:@"%i", i];
        NSData* playerData = [prefs dataForKey:slotString];
        if (playerData == nil)
        {
            // hide it if there's no data there
            [[[[self contentView] saveSlotButtons] objectAtIndex:i] setHidden:TRUE];            
        }
        else
        {
            Player* player = [NSKeyedUnarchiver unarchiveObjectWithData:playerData];
            [[[[self contentView] saveSlotButtons] objectAtIndex:i] setTitle:[player name] forState:UIControlStateNormal];
        }
            
        
    }
     
    
    
    // show all the different slots that are taken
}



-(void) slotUsed:(int)slot
{
	NSString* slotString = [NSString stringWithFormat:@"%i", slot];
	
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];

    NSData* playerData = [prefs dataForKey:slotString];
    Player* player = [NSKeyedUnarchiver unarchiveObjectWithData:playerData];
    World* world = [[World alloc] initWithPlayer:player];
    WorldController* worldController = [[WorldController alloc] initWithWorld:world];
	[self.navigationController pushViewController:worldController animated:YES];
	[worldController release];
    [world release];
}
-(void) backButtonPressed
{
	[self.navigationController popViewControllerAnimated:TRUE];
}


@end
