//
//  SkillDetailViewController.m
//  MonsterQuest
//
//  Created by u0605593 on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SkillDetailViewController.h"

@implementation SkillDetailViewController

-(id) initWithSkill:(Skill *)skill
{
    self = [super init];
	if (self == nil)
		return nil;
    
    _skill = skill;
    return self;
}

-(void)viewDidLoad
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
    [titleLabel setText:_skill.name];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setShadowColor:[UIColor blackColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    UIFont* font1 = [UIFont boldSystemFontOfSize:32];
    [titleLabel setFont:font1];
    [titleLabel setShadowOffset:CGSizeMake(2, 2)];
    [[self view] addSubview:titleLabel];
    [titleLabel release];
    
    //detail labels
    UILabel* detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 300, 200)];
    [detailLabel setText:[NSString stringWithFormat:@"Power: %i\nType: %@\nCooldown: %i turns.", _skill.attackPower, [Skill getStringForType:_skill.type], _skill.maxPP]];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [detailLabel setTextAlignment:UITextAlignmentCenter];
    [detailLabel setShadowColor:[UIColor blackColor]];
    [detailLabel setTextColor:[UIColor whiteColor]];
    UIFont* font2 = [UIFont systemFontOfSize:20];
    [detailLabel setFont:font2];
    [detailLabel setShadowOffset:CGSizeMake(2, 2)];
    detailLabel.numberOfLines = 5;
    [[self view] addSubview:detailLabel];
    [detailLabel release];
    
    UILabel* descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 300, 100)];
    [descLabel setText:_skill.description];
    [descLabel setBackgroundColor:[UIColor clearColor]];
    [descLabel setTextAlignment:UITextAlignmentCenter];
    [descLabel setShadowColor:[UIColor blackColor]];
    [descLabel setTextColor:[UIColor whiteColor]];
    UIFont* font3 = [UIFont systemFontOfSize:24];
    [descLabel setFont:font3];
    [descLabel setShadowOffset:CGSizeMake(2, 2)];
    descLabel.numberOfLines = 5;
    [[self view] addSubview:descLabel];
    [descLabel release];

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
