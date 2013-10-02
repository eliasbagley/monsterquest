//
//  TitleScreenController.m
//  LazyQuest
//
//  Created by u0565496 on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaveGameController.h"



@implementation SaveGameController

-(id) initWithPlayer:(Player*)player;
{
	
	self = [super init];
	if (self == nil)
		return nil;
	
    _player = [player retain];
	
	
	return self;
	
}


-(void) dealloc
{
    [_player release];
	[super dealloc];
}
-(SaveGame*) contentView
{
	return (SaveGame*)[self view];
}
-(void) loadView
{
	SaveGame* saveGameScreen = [[SaveGame alloc] initWithFrame:CGRectMake(10, 30, 300, 430)];
	[self setView:saveGameScreen];
	[self.navigationController setNavigationBarHidden:TRUE animated:NO];
    [saveGameScreen release];
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
            // leave it alone if there's nothing saved there
        }
        else
        {
            Player* player = [NSKeyedUnarchiver unarchiveObjectWithData:playerData];

            [[[[self contentView] saveSlotButtons] objectAtIndex:i] setTitle:[player name] forState:UIControlStateNormal];
        }
        
        
    }
    

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        
        NSString* slotString = [NSString stringWithFormat:@"%i", _slot];
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        NSData* playerData = [NSKeyedArchiver archivedDataWithRootObject:_player];
        [def setObject:playerData forKey:slotString];
        [def synchronize];
        
        // saved, now pop
        [self.navigationController popViewControllerAnimated:TRUE];
        
    }
}

-(void) slotUsed:(int)slot
{
    _slot = slot;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirm Save" message:@"Are you sure you want to save in this slot?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
    [alert release];

}
-(void) backButtonPressed
{
	[self.navigationController popViewControllerAnimated:TRUE];
}

@end
