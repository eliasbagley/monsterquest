//
//  PlayerStatsViewController.m
//  MonsterQuest
//
//  Created by Alexander W Doub on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerStatsViewController.h"

@implementation PlayerStatsViewController

-(void) dealloc
{
    [_player release];
    [super dealloc];
}

-(id) initWithPlayer:(Player*) player
{    
    self = [super init];
	if (self == nil)
		return nil;
    
    _player = [player retain];
    return self;
}

-(void) viewDidLoad
{
    //background Image
    UIImage* backgroundImage = [UIImage imageNamed:@"gradientBackground"];
    UIImageView* backgroundImageView = [[UIImageView alloc] 
                                        initWithFrame:CGRectMake(0, 0, 320, 460)];
    [backgroundImageView setImage:backgroundImage];
    [[self view] addSubview:backgroundImageView];
    [backgroundImageView release];
    
    
    //title label
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    [titleLabel setText:_player.name];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setShadowColor:[UIColor blackColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    UIFont* font1 = [UIFont boldSystemFontOfSize:32];
    [titleLabel setFont:font1];
    [titleLabel setShadowOffset:CGSizeMake(2, 2)];
    [[self view] addSubview:titleLabel];
    [titleLabel release];
    
    //badge label
    UILabel* badgeLabelHeader = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 60)];
    [badgeLabelHeader setText:@"Badges"];
    [badgeLabelHeader setBackgroundColor:[UIColor clearColor]];
    [badgeLabelHeader setTextAlignment:UITextAlignmentCenter];
    [badgeLabelHeader setShadowColor:[UIColor blackColor]];
    [badgeLabelHeader setTextColor:[UIColor whiteColor]];
    UIFont* font2 = [UIFont systemFontOfSize:24];
    [badgeLabelHeader setFont:font2];
    [badgeLabelHeader setShadowOffset:CGSizeMake(2, 2)];
    [[self view] addSubview:badgeLabelHeader];
    [badgeLabelHeader release];
    
    //actual badges
    for (int i = 0; i < 8; i++)
    {    
        UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ItemBackdrop4"]];
        UIImageView* badgeView;
        [backgroundView setFrame:CGRectMake(33 + (66 * (i%4)), 100 + (60 * ((i/4)%2)), 48, 48)];
        
        if ([_player hasBadge:i]) 
        {
            badgeView = [[UIImageView alloc] initWithImage:
                                  [UIImage imageNamed:[NSString stringWithFormat:@"badge%i", i]]]; 
        }
        else
        {
            badgeView = [[UIImageView alloc] initWithImage:
                                      [UIImage imageNamed:@"badge_none"]]; 
            
        }
        [badgeView setFrame:CGRectMake(11, 11, 24, 24)];
        [backgroundView addSubview:badgeView];
        [[self view] addSubview:backgroundView];
        
    }
    
    //detail label
    UILabel* detailLabelHeader = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 60)];
    [detailLabelHeader setText:@"Badges"];
    [detailLabelHeader setBackgroundColor:[UIColor clearColor]];
    [detailLabelHeader setTextAlignment:UITextAlignmentCenter];
    [detailLabelHeader setShadowColor:[UIColor blackColor]];
    [detailLabelHeader setTextColor:[UIColor whiteColor]];
    [detailLabelHeader setFont:font2];
    [detailLabelHeader setShadowOffset:CGSizeMake(2, 2)];
    [[self view] addSubview:detailLabelHeader];
    [detailLabelHeader release];
    
    //player details
    UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 200, 200, 200)];
    [detailLabel setText:[NSString stringWithFormat:@"Gold: %i\nMonsters: %i\nEquipment: %i\nTime Played: %@\nMeters Walked: %i", _player.gold, _player.monsters.count + _player.storedMonsters.count, _player.equipment.count, [_player getTimePlayed], (int)_player.metersWalked]];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [detailLabel setTextAlignment:UITextAlignmentLeft];
    [detailLabel setShadowColor:[UIColor blackColor]];
    [detailLabel setTextColor:[UIColor whiteColor]];
    UIFont* font3 = [UIFont systemFontOfSize:17];
    [detailLabel setFont:font3];
    [detailLabel setShadowOffset:CGSizeMake(2, 2)];
    detailLabel.numberOfLines = 8;
    [[self view] addSubview:detailLabel];
    
    
    //buttons
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setFrame:CGRectMake(10, 3, 70, 30)];
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:backButton];
}

-(void) backButtonPressed
{
    [self.navigationController popViewControllerAnimated:TRUE];
}



@end
