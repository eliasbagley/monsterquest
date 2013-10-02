//
//  MonsterTableViewController.m
//  MonsterQuest
//
//  Created by u0605593 on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MonsterTableViewController.h"

@implementation MonsterTableViewController


-(void) dealloc
{
    [containerView release];
    [headerLabel release];
    [_backButton release];
    [_arrangementButton release];
    [_monsters release];
    [_consumableToUse release];
    _worldDelegate = nil;
    _battleDelegate = nil;
    [super dealloc];
}


-(id) initWithMonsters:(NSMutableArray*)monsters
{
    self = [super init];
	if (self == nil)
		return nil;
    
    _monsters = [monsters retain];
    _consumableToUse = nil;
    _monsterdexMode = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = 100;
	self.tableView.backgroundColor = [UIColor clearColor];
    
	containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 70)];
	headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 40)];
    headerLabel.text = NSLocalizedString(@"Monsters", @"");
    headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:26];
	headerLabel.backgroundColor = [UIColor clearColor];
    [headerLabel setTextAlignment:UITextAlignmentCenter];
	[containerView addSubview:headerLabel];
	self.tableView.tableHeaderView = containerView;
        
    _backButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[_backButton setFrame:CGRectMake(10, 3, 70, 30)];
	[_backButton setTitle:@"Back" forState:UIControlStateNormal];
	[_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:_backButton];
    
    _arrangementButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[_arrangementButton setFrame:CGRectMake(220, 3, 100, 30)];
	[_arrangementButton setTitle:@"Arrangement" forState:UIControlStateNormal];
	[_arrangementButton addTarget:self action:@selector(arrangementButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:_arrangementButton];
    
    

    
    return self;
}


- (void)viewDidLoad
{
    
}

-(void) viewDidAppear:(BOOL)animated
{
    if (_battleDelegate)
        [_arrangementButton setHidden:1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_monsters count];
}
-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [_monsters exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    Monster* monster = [_monsters objectAtIndex:row];
    int extraRoom = 0;
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        
        //Picture
		cell.backgroundView = [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];       
        
        //Name
        UILabel *nameLabel =[[[UILabel alloc]initWithFrame:
                     CGRectMake(monsterNameLabelXOffset,monsterNameLabelYOffset,200,50)]autorelease];
		[cell.contentView addSubview:nameLabel];
        
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		nameLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		nameLabel.font = [UIFont systemFontOfSize:24];
        if (!_monsterdexMode || _seenMonsters[indexPath.row]) 
        {
            nameLabel.text = monster.name;
            cell.imageView.image = [monster getImage]; 
        }
        else
        {
            nameLabel.text = @"??????";
        }
        

        //Info
        UILabel *infoLabel =[[[UILabel alloc]initWithFrame:
                     CGRectMake(monsterInfoLabelXOffset,monsterInfoLabelYOffset,100,50)]autorelease];
        [cell.contentView addSubview:infoLabel];
    
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
        infoLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
        infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.numberOfLines=3;
        infoLabel.lineBreakMode = UILineBreakModeWordWrap;
        if (!_monsterdexMode) 
        {
            infoLabel.text = [NSString stringWithFormat:@"Type: %@\nLevel: %i\nHP: %i/%i", [Skill getStringForType:[monster getStat:TYPE]], [monster getStat:LEVEL],[monster getStat:CURHP], [monster getStat:MAXHP]];
            
            UIImage *indicatorImage = [UIImage imageNamed:@"indicator.png"];
            cell.accessoryView =[[[UIImageView alloc]initWithImage:indicatorImage]autorelease];
        }       
        else if (_monsterdexMode && _seenMonsters[indexPath.row])
        {            
            infoLabel.text = [NSString stringWithFormat:@"Type: %@", 
                              [Skill getStringForType:[monster getStat:TYPE]]];
            
            UILabel* numberLabel =[[[UILabel alloc]initWithFrame:
                                    CGRectMake(monsterNameLabelXOffset,monsterNameLabelYOffset,200,50)]autorelease];
            [numberLabel setTextAlignment:UITextAlignmentLeft];
            numberLabel.backgroundColor = [UIColor clearColor];
            numberLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
            numberLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
            numberLabel.font = [UIFont systemFontOfSize:24];
            numberLabel.text = [NSString stringWithFormat:@"#%i",monster.number];
            [cell.contentView addSubview:numberLabel];
            
            if (monster.number < 10)
                extraRoom = 30;

            else
                extraRoom = 45;
            
            [nameLabel setFrame:CGRectMake(monsterNameLabelXOffset + extraRoom ,monsterNameLabelYOffset,200,50)];
            
        }
        
        //resize label
        CGSize stringSize = [infoLabel.text sizeWithFont:[UIFont systemFontOfSize:12] 
                                       constrainedToSize:CGSizeMake(300, 9999) 
                                           lineBreakMode:infoLabel.lineBreakMode];
        
        infoLabel.frame = CGRectMake(monsterInfoLabelXOffset + extraRoom,monsterInfoLabelYOffset,
                                     infoLabelWidth,stringSize.height+5);
 
        
        
        //maybe later -- line up the picture
        //UIImageView *pictureView;
        //pictureView = [[[UIImageView alloc] initWithImage:[monster getImage]] autorelease];
        //[pictureView setFrame:CGRectMake(0, 0, 100, 100)];
        //[pictureView setContentMode:UIViewContentModeScaleAspectFit];
        //[cell.contentView addSubview:pictureView];
        //[cell.imageView setFrame:CGRectMake(100, 100, 5, 5)];
	}
    

    //Chooses picture of row based on its position/if its selected
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [aTableView numberOfRowsInSection:[indexPath section]];
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"topRow.png"];
		selectionBackground = [UIImage imageNamed:@"topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"middleRowSelected.png"];
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	
    	
	return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Monster* monster = [_monsters objectAtIndex:indexPath.row];
    
    //Consumable selected. use it on this monster
    if (_consumableToUse != nil)
    {
        int depth = [self.navigationController.viewControllers count];

        if(_battleDelegate)
        {
            [_battleDelegate useConsumable:_consumableToUse onMonster:monster];
            [self.navigationController popToViewController:
             [self.navigationController.viewControllers objectAtIndex:depth-3] animated:TRUE];
        }
        else if(_worldDelegate)
        {
            [_worldDelegate useConsumable:_consumableToUse onMonster:monster];
            [self.navigationController popToViewController:
             [self.navigationController.viewControllers objectAtIndex:depth-3] animated:TRUE];
        }
        else
            NSAssert(FALSE, @"neither delegate is set");
        
    }
    
    
    //No item to use, player is here normally
    else
    {
        MonsterDetailViewController* mdvc = [[MonsterDetailViewController alloc] initWithMonster:monster];
        if (_battleDelegate)
            [mdvc setBattleDelegate:_battleDelegate];
        else if (_worldDelegate)
            [mdvc setWorldDelegate:_worldDelegate];
        else
            NSAssert(FALSE, @"neither delegate is set");
        
        [self.navigationController pushViewController:mdvc animated:YES];
        [mdvc release];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (!_monsterdexMode)
        return path;
    return nil;
}


-(void) backButtonPressed
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void) setMainText:(NSString*)string
{
    headerLabel.text = string;
}
-(void) hideBackButton:(bool)isHidden
{
    [_backButton setHidden:isHidden];
}
-(void) setToMonsterdexMode:(bool[])seenList
{
    _arrangementButton.hidden = 1;
    headerLabel.text = @"Monsterdex";
    _monsterdexMode = 1;
    for (int i = 0; i < maxMonsterCount; i++)
        _seenMonsters[i] = seenList[i];
}

-(void) arrangementButtonPressed
{
    if (!self.tableView.editing)
    {
        [_arrangementButton setTitle:@"Cancel" forState:UIControlStateNormal];
        self.tableView.editing = 1;
    }
    else
    {
        [_arrangementButton setTitle:@"Arrangement" forState:UIControlStateNormal];
        self.tableView.editing = 0;
    }
    
}
@synthesize battleDelegate = _battleDelegate;
@synthesize worldDelegate = _worldDelegate;
@synthesize consumableToUse = _consumableToUse;

@end
