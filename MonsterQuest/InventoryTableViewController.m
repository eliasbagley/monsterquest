//
//  MonsterTableViewController.m
//  MonsterQuest
//
//  Created by u0605593 on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InventoryTableViewController.h"

@implementation InventoryTableViewController

-(id) initWithPlayer:(Player *)player
{
    self = [super init];
	if (self == nil)
		return nil;
    
    _player = [player retain];
    _selectedRow = nil;
    _tab = 0;
    
    return self;
}


- (void)viewDidLoad
{
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.rowHeight = 50;
	self.tableView.backgroundColor = [UIColor clearColor];
    
	UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 70)] autorelease];
	UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 40)] autorelease];
	headerLabel.text = NSLocalizedString(@"Inventory", @"");
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont boldSystemFontOfSize:26];
	headerLabel.backgroundColor = [UIColor clearColor];
    [headerLabel setTextAlignment:UITextAlignmentCenter];
	[containerView addSubview:headerLabel];
	self.tableView.tableHeaderView = containerView;
    
    
    UIButton* _backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[_backButton setFrame:CGRectMake(10, 3, 70, 30)];
	[_backButton setTitle:@"Back" forState:UIControlStateNormal];
	[_backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:_backButton];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_equipmentDelegate && _tab==2) //equipment + "none"
        return 2;
    if (_tab==0)    //consumables + equipment
        return 2;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    //this is the "none" category that appears if you are swapping gear.
    if (_equipmentDelegate && _tab==2 && section==1) 
    {
        return 1;
    }
    
    
    if(_tab==0)
    {
        if (section == 0)
            return [_player.consumables count];
        if (section == 1)
            return [_player.equipment count];
    }
    else if (_tab==1)
        return [_player.consumables count];
    
    else if (_tab==2)
        return [_player.equipment count];
    
    return -1;
    
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *quantityLabel;
	UILabel *nameLabel;
	UILabel *infoLabel;
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
        
        //
        //Default cell setup
        //
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
                
        //name label set up
		nameLabel =[[[UILabel alloc]initWithFrame:
                     CGRectMake(consumableNameLabelXOffset,consumableNameLabelYOffset,infoLabelWidth,20)]autorelease];
        [nameLabel  setContentMode:UIViewContentModeTop];
        [nameLabel setTextAlignment:UITextAlignmentCenter];
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		nameLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		nameLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:nameLabel];
        
		//info label set up
		infoLabel =[[[UILabel alloc]initWithFrame:
                     CGRectMake(consumableInfoLabelXOffset,consumableInfoLabelYOffset,infoLabelWidth,30)]autorelease];
        infoLabel.contentMode = UIViewContentModeTop;
        
        infoLabel.textAlignment = UITextAlignmentCenter;
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		infoLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.numberOfLines = 8;
        infoLabel.lineBreakMode = UILineBreakModeWordWrap;
        [cell.contentView addSubview:infoLabel];
        
		//picture        
		cell.backgroundView = [[[UIImageView alloc] init] autorelease];
		cell.selectedBackgroundView = [[[UIImageView alloc] init] autorelease];
        
        
        //
        // Personalize it
        //
        
        // If its a consumable
        if ((_tab==0 && section==0) || _tab==1) 
        {
            Consumable* consumable = [[_player.consumables objectAtIndex:row] retain];
        
            quantityLabel =[[[UILabel alloc]initWithFrame:
                         CGRectMake(40,0,50,50)]autorelease];
            [quantityLabel setTextAlignment:UITextAlignmentLeft];
            quantityLabel.backgroundColor = [UIColor clearColor];
            quantityLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
            quantityLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
            quantityLabel.font = [UIFont boldSystemFontOfSize:16];
            quantityLabel.text = [NSString stringWithFormat:@"x%i",consumable.quantity];
            [cell.contentView addSubview:quantityLabel];
        
            nameLabel.text = consumable.name;
            infoLabel.text = [consumable getDescription];
            cell.imageView.image = [consumable getImage];
            [consumable release];
        }
        
        // If it is equipment
        if ((_tab==0 && section==1) || (_tab==2 && section==0))
        {        
            Equipment* equipment = [[_player.equipment objectAtIndex:row] retain];
            nameLabel.text = equipment.name;
            infoLabel.text = [Equipment getStringForSlot:equipment.slot];
            cell.imageView.image = [equipment getImage];
            
            //If its selected, show more details
            int selectedRow=-1;
            if (_selectedRow!=nil)
                selectedRow=_selectedRow.row;
            
            if (selectedRow==row || _tab==2) 
            {
                infoLabel.text = [equipment getDescription];                   
            }
            [equipment release];
            
            //CGSize stringSize = [infoLabel.text sizeWithFont:[UIFont systemFontOfSize:12] 
            
        }
        
        //if its "none" option
        else if (_tab==2 && section==1)
        {
            nameLabel.text = @"None";
        }
        
        
        //resize all infolabels for consumables      
        CGSize stringSize = [infoLabel.text sizeWithFont:[UIFont systemFontOfSize:12] 
                                       constrainedToSize:CGSizeMake(infoLabelWidth, 9999) 
                                           lineBreakMode:infoLabel.lineBreakMode];
        
        infoLabel.frame = CGRectMake(consumableInfoLabelXOffset,consumableInfoLabelYOffset,
                                     infoLabelWidth,stringSize.height+5);
        
        if ((_tab==0 && section==0) || _tab==1) 
            quantityLabel.frame = CGRectMake(40, 0, 50,stringSize.height+5+cellBufferRoom);
        
	}
    
    
    
    //background picture
	((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"middleRow.png"];
	((UIImageView *)cell.selectedBackgroundView).image = [UIImage imageNamed:@"middleRowSelected.png"];
	
    
	return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    //if sent here from the equipment delegate,     
    if (_equipmentDelegate) 
    {
        Equipment* equipment;
        
        //none was selected
        if (indexPath.section==1 && indexPath.row==0) 
            equipment = Nil;
        else
         equipment = [_player.equipment objectAtIndex:indexPath.row];
        
        if (_equipmentDelegateSlot == 1) 
        {
            [_equipmentDelegate equipEquipmentAtSlot1:equipment];
            if (indexPath.section==0)
                [_player.equipment removeObjectAtIndex:indexPath.row];
        }
        else if (_equipmentDelegateSlot == 2) 
        {
            [_equipmentDelegate equipEquipmentAtSlot2:equipment];
            if (indexPath.section==0)
                [_player.equipment removeObjectAtIndex:indexPath.row];
        }
        if (_equipmentDelegateSlot == 3) 
        {
            [_equipmentDelegate equipEquipmentAtSlot3:equipment];
            if (indexPath.section==0)
                [_player.equipment removeObjectAtIndex:indexPath.row];
        }
            
        [self.navigationController popViewControllerAnimated:TRUE];
        return;
    }
    
    
    //make sure only equipment can be "selected" and only in tab 0
    if (_tab==0 && indexPath.section==1) 
    {
        _selectedRow = [indexPath retain];
        [self.tableView reloadData];      
    }
    
    //if selected a consumable
    if ((_tab==0 && indexPath.section==0) || _tab==1)
    {
        Consumable* consumable = [_player.consumables objectAtIndex:indexPath.row];
        
        if (consumable.consumableType==PERMCHANGE) 
        {
            MonsterTableViewController* mtvc = [[MonsterTableViewController alloc] initWithMonsters:_player.monsters];
            [mtvc setConsumableToUse:consumable];
            [mtvc setMainText:@"Use on which monster?"];
        
            //set proper delegate
            if (_worldDelegate) 
                [mtvc setWorldDelegate:_worldDelegate];
        
            if (_battleDelegate)
                [mtvc setBattleDelegate:_battleDelegate];
        
            [self.navigationController pushViewController:mtvc animated:YES];
            [mtvc release];
        }
        
        else if (consumable.consumableType==MONSTERBALL && _battleDelegate) 
        {
            [_battleDelegate useMonsterball:consumable];
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        else
            [self.tableView reloadData];
        
    }
}

-(void) backButtonPressed
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_tab==0 && indexPath.section == 1 && _selectedRow == nil)
        return 50;
    
    else if ((_tab==0 && indexPath.row == _selectedRow.row && indexPath.section == 1) || (_tab==2 && indexPath.section == 0))
    {
        Equipment* thatEquipment = [_player.equipment objectAtIndex:indexPath.row];        
        CGSize stringSize = [[thatEquipment getDescription] sizeWithFont:[UIFont systemFontOfSize:12] 
                                 constrainedToSize:CGSizeMake(infoLabelWidth, 9999)];
        return stringSize.height + cellBufferRoom;
    }
    else if ((_tab==0 && indexPath.section == 0) || _tab==1)
    {
        Consumable* consumable = [_player.consumables objectAtIndex:indexPath.row];        
        CGSize stringSize = [[consumable getDescription] sizeWithFont:[UIFont systemFontOfSize:12] 
                                 constrainedToSize:CGSizeMake(infoLabelWidth, 9999)];
        return stringSize.height + cellBufferRoom;
    }
    else
        return 50;
    
}

@synthesize battleDelegate = _battleDelegate;
@synthesize worldDelegate = _worldDelegate;
@synthesize equipmentDelegate = _equipmentDelegate;
@synthesize equipmentDelegateSlot = _equipmentDelegateSlot;
@synthesize tab = _tab;

-(void) dealloc
{
    [_player release];
    _worldDelegate = nil;
    _battleDelegate = nil;
    _equipmentDelegate = nil;
    [_selectedRow release];
    [super dealloc];
    
}

@end
