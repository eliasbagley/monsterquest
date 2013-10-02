//
//  Controller.m
//  LazyQuest
//
//  Created by u0565496 on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorldController.h"


@interface WorldController() 
@end

@implementation WorldController

-(id) initWithWorld:(World*)world
{
	
	self = [super init];
	if (self == nil)
		return nil;
    
    _world = [world retain];
    [_world setDelegate:self];
    [_world.delegate playerChanged:_world.player];   
    _willInitiateSpecialNPC = 0;
    
    _picker = nil;
    _peerID = @"derpus";
    
    
    NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/explore1.mp3", [[NSBundle mainBundle] resourcePath]]];
    _bgmPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _sfxPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _bgmPlayer.numberOfLoops = -1;
    
	return self;
}

-(void) dealloc
{
    [_world release];
    [_NPCToFight release];
    [_peerID release];
    [_bgmPlayer release];
    [_sfxPlayer release];
	[super dealloc];
}


-(WorldView*) contentView
{
	return (WorldView*)[self view];
}


-(void) loadView
{    
	WorldView* worldView = [[[WorldView alloc] initWithFrame:CGRectMake(0, 20, 320, 480)] autorelease];
    
    //set delegates
    [worldView setDelegate:self];
    [worldView.playerView setMyDelegate:self];
    [worldView.NPCsView setDelegate:self];
    [worldView.menuView setDelegate:self];
	[self setView:worldView];
}

-(void) viewDidLoad
{
    _frameLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop)] retain];
    _frameLink.frameInterval = 1;
    [_frameLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_world loadZones];
}

-(void) viewWillAppear:(BOOL)animated
{
    if (_frameLink)
        [_frameLink setPaused:0];
    [[self.navigationController.viewControllers objectAtIndex:0] stopMusic];
    _world.player.moving = 0;
    
    [_bgmPlayer play];
    [_world updatePlayer];
    
}
-(void) viewWillDisappear:(BOOL)animated
{
    if (_frameLink)
        [_frameLink setPaused:1];
}

-(void) gameLoop
{        
    //animate za warudo
    [_world stepWorldOnce];
    
    //u gro older
    _world.player.secondsPlayed += (1/FPS);
    
    //draw chat if its up
    if ([self.contentView.chatView stepChatOnce])
        [self.contentView.chatView setNeedsDisplay];
    
    //draw menu if its up
    if (!self.contentView.menuView.isHidden) 
        [self.contentView.menuView setNeedsDisplay];
    
    //Everything below this line must wait on chat
    if ([self.contentView.chatView isInUse])
        return;
    
    //guy challenged him
    if (_NPCToFight != nil) 
    {
        [self initiateCombatWithEnemy:_NPCToFight];
        _NPCToFight = nil;
    }
    
    //consumables vendor
    if (_willInitiateSpecialNPC==1)
    {
        NSMutableArray* consumables = [[Consumable generateAllConsumables] retain];
        
        SwapTableViewController* stvc = [[SwapTableViewController alloc] 
                                         initWithLeftSide:_world.player.consumables andRightSide:consumables];
        [stvc setWorldDelegate:self];
        [stvc setCategory:@"Consumables"];
        [self.navigationController pushViewController:stvc animated:YES];
        [consumables release];
        [stvc release];
        _willInitiateSpecialNPC=0;
    }
    //equipment vendor
    if (_willInitiateSpecialNPC==2)
    {
        NSMutableArray* equipment = [[Equipment generateAllEquipment] retain];
        
        SwapTableViewController* stvc = [[SwapTableViewController alloc] 
                                         initWithLeftSide:_world.player.equipment andRightSide:equipment];
        [stvc setWorldDelegate:self];
        [stvc setCategory:@"Equipment"];
        [self.navigationController pushViewController:stvc animated:YES];
        [equipment release];
        [stvc release];
        _willInitiateSpecialNPC=0;
    }
    //nurse
    if (_willInitiateSpecialNPC==3)
    {
        [self healMonsters];
        _willInitiateSpecialNPC=0;
    }
    //monster stash
    if (_willInitiateSpecialNPC==4)
    {        
        SwapTableViewController* stvc = [[SwapTableViewController alloc] 
                                         initWithLeftSide:_world.player.monsters andRightSide:_world.player.storedMonsters];
        [stvc setWorldDelegate:self];
        [stvc setToMonsterTradingMode];
        [self.navigationController pushViewController:stvc animated:YES];
        [stvc release];
        _willInitiateSpecialNPC=0;
    }
}


//
//DELEGATE METHODS
-(void) playerChanged:(Player*)player
{    
    [[self contentView] setPlayer:player]; //calls WorldView.setPlayer
}


-(void) loadZones:(Zone *)zone NorthZone:(Zone *)nZone SouthZone:(Zone *)sZone WestZone:(Zone *)wZone EastZone:(Zone *)eZone NorthWestZone:(Zone *)nwZone SouthWestZone:(Zone *)swZone NorthEastZone:(Zone *)neZone SouthEastZone:(Zone *)seZone
{
    [[self contentView] loadZones:zone NorthZone:nZone SouthZone:sZone WestZone:wZone EastZone:eZone NorthWestZone:nwZone SouthWestZone:swZone NorthEastZone:neZone SouthEastZone:seZone]; //calls WorldView.loadZones
    
}

-(void) movePlayerOneStep
{
    [_world movePlayerOneStep];
}
-(void) setPlayerMoveDirection:(int)direction;
{
    if(direction == -1)
    {
        _world.player.moving = 0;
        [_world updatePlayer];
        return;
    }
    
    if (_world.player.isFrozen)
        return;
    
    _world.player.direction = direction;
    _world.player.moving = 1;
}
//NPC interacted with
-(void) interactWithNPC:(NPC *)npc
{
    if (npc.npcType > 0 && npc.npcType < 10)
    {
        [self.contentView.chatView setChatDialog:npc.chatText];
        _willInitiateSpecialNPC = npc.npcType;
    }
    else if ([[npc monsters]count] == 0) 
        [self.contentView.chatView setChatDialog:npc.chatText];
    
    else if ([[npc monsters]count] > 0)
    {
        _world.player.isFrozen = 1;
        [self.contentView.chatView setChatDialog:npc.challengeText];
        _NPCToFight = npc;
    }
}

-(void) seenByHostileNPC:(NPC *)npc
{
    [_bgmPlayer stop];
    NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/seen by enemy.mp3", [[NSBundle mainBundle] resourcePath]]];
    [_bgmPlayer initWithContentsOfURL:url error:nil];
    [_bgmPlayer play];
    
    _world.player.isFrozen = 1;
    [self setPlayerMoveDirection:-1];
    
    [self.contentView.chatView setChatDialog:npc.challengeText];
    _NPCToFight = npc; 
}

-(void) initiateCombatWithEnemy:(NPC*)NPC
{    
    [_bgmPlayer stop];
    BattleController* battleController = [[BattleController alloc] 
                                          initWithPlayer:[_world player] 
                                          andEnemy:NPC 
                                          andSession:_gameSession
                                          andPeerID:_peerID];
    [self.navigationController pushViewController:battleController animated:YES];
    _gameSession = nil;
    [battleController release];
    
    NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/explore1.mp3", [[NSBundle mainBundle] resourcePath]]];
    [_bgmPlayer initWithContentsOfURL:url error:nil]; 

}

//menu delegate methods
-(void) openMonsterdex
{
    //make a fat list of all the monsters
    NSMutableArray* monsterList = [[NSMutableArray alloc] init];
    for (int i = 1; i <= maxMonsterCount; i++)
    {
        Monster* thisMonster = [[Monster alloc] initMonsterByNumber:i andLevel:5];
        [monsterList addObject:thisMonster];
        [thisMonster release];
    }
    
    //make a monster table view controller
    MonsterTableViewController* mtvc = [[MonsterTableViewController alloc] initWithMonsters:monsterList];
    [monsterList release];
    [mtvc setWorldDelegate:self];
    
    //make bool array of monsters hes seen
    bool seenList[maxMonsterCount] ;
    for (int i = 0 ; i < maxMonsterCount; i++) 
        seenList[i] = [_world.player hasSeenMonster:(i+1)];
    
    [mtvc setToMonsterdexMode:seenList];
    [self.navigationController pushViewController:mtvc animated:YES];
    [mtvc release];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
        
        [_bgmPlayer stop];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void) backToTitleScreen
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirm" 
                                                    message:@"Are you sure you want to go back to the main menu? Any unsaved progress will be lost." 
                                                   delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
    [alert release];
}

-(void) openMonsters
{
    //Player* player = _world.player;
    MonsterTableViewController* mtvc = [[MonsterTableViewController alloc] initWithMonsters:_world.player.monsters];
    [mtvc setWorldDelegate:self];
    [self.navigationController pushViewController:mtvc animated:YES];
    [mtvc release];
    //[player release];
}
-(void) openInventory
{
    InventoryTableViewController* itvc = [[InventoryTableViewController alloc] 
                                          initWithPlayer:_world.player];
    [itvc setWorldDelegate:self];
    [self.navigationController pushViewController:itvc animated:YES];
    [itvc release];
}

-(void) openStats
{
    PlayerStatsViewController* psvc = [[PlayerStatsViewController alloc] 
                                       initWithPlayer:_world.player];
    [self.navigationController pushViewController:psvc animated:YES];
    [psvc release];
}

-(void) saveGame
{
    SaveGameController* saveGameController = [[SaveGameController alloc] initWithPlayer:_world.player];
    [self.navigationController pushViewController:saveGameController animated:YES];
    [saveGameController release];
    
}

-(void) healMonsters
{
    for (Monster* monster in _world.player.monsters)
    {
        int health = [monster getStat:MAXHP];
        [monster setStat:CURHP withValue:health];
    }
}

-(void) useConsumable:(Consumable *)consumable onMonster:(Monster *)monster
{
    NSString* chatText = [NSString stringWithFormat:@"You use %@ on %@.", consumable.name, monster.name];
    [monster useConsumable:consumable];    
    [_world.player removeConsumableFromInventory:consumable];
    [[[self contentView] chatView] setChatDialog:chatText];
}

-(Player*) getPlayer
{
    return _world.player;
}

+(NSMutableArray*) generateVendorEquipment
{
    
    //Note: This can never be empty or shit will break.
    NSMutableArray* equipment = [[[NSMutableArray alloc] initWithObjects:nil] autorelease];
    [equipment addObject:[[[Equipment alloc] initEquipmentByName:@"Light Magic Wand"] autorelease]];
    [equipment addObject:[[[Equipment alloc] initEquipmentByName:@"Weak Claws of Attack"] autorelease]];
    [equipment addObject:[[[Equipment alloc] initEquipmentByName:@"Lesser Power Wrist"]autorelease]];
    [equipment addObject:[[[Equipment alloc] initEquipmentByName:@"Grand Plate Mail"]autorelease]];
    [equipment addObject:[[[Equipment alloc] initEquipmentByName:@"Cape of Defense"]autorelease]];
    [equipment addObject:[[[Equipment alloc] initEquipmentByName:@"Merlin's Ring"]autorelease]];
    [equipment addObject:[[[Equipment alloc] initEquipmentByName:@"Merlin's Cap"]autorelease]];
    
    
    
    return  equipment;
}

-(bool) chargePlayerGold:(int)amount
{
    //not enough funds
    if (amount>_world.player.gold) 
        return false;
    
    _world.player.gold -= amount;
    return true;
}
-(void) toggleMenu
{
    [[self contentView] toggleMenu];
}
-(void) startMultiplayer
{
    
    _picker = [[GKPeerPickerController alloc] init];
    [_picker setDelegate:self];
    _picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [_picker show];
}

//multiplayer delegates
- (void)peerPickerController:(GKPeerPickerController *)picker 
              didConnectPeer:(NSString *)peerID 
                   toSession: (GKSession *) session 
{
    // Use a retaining property to take ownership of the session.
    _peerID = [peerID retain];
    self.gameSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    
    // Remove the picker.
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
    
    
    NSData* myPlayerData = [NSKeyedArchiver archivedDataWithRootObject:_world.player];
    [_gameSession sendDataToAllPeers:myPlayerData withDataMode:GKSendDataReliable error:nil];
    
}
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    NSLog(@"peerPicker ControllerDidCancel");
    picker.delegate = nil;
    [picker autorelease];
}


-(void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    Player* theirPlayer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"connected with player %@", [theirPlayer name]);
    _NPCToFight = [[NPC alloc] initFromPlayer:theirPlayer];
    
    //[self initiateCombatWithEnemy:NPCToFight];
}

-(void) disconnect:(id)sender
{
    [_gameSession disconnectFromAllPeers];
    [_gameSession setDataReceiveHandler:nil withContext:nil];
    [_gameSession setAvailable:NO];
    [_gameSession setDelegate:nil];
    [_gameSession release];
    _gameSession = nil;
}

-(void) session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    if (state == GKPeerStateDisconnected)
    {
        NSLog(@"peer has left");
        [_gameSession disconnectFromAllPeers];
        [_gameSession setDataReceiveHandler:nil withContext:nil];
        [_gameSession setAvailable:NO];
        [_gameSession setDelegate:nil];    
        [_gameSession release];
        _gameSession = nil;  
    }
    else if (state == GKPeerStateConnected)
    {
        NSLog(@"peer connected!");
    }
}

@synthesize gameSession = _gameSession;
@synthesize picker = _picker;


@end
