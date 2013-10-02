//
//  ChatView.m
//  MonsterQuest
//
//  Created by u0605593 on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ChatView.h"


@implementation ChatView

- (void)dealloc
{
    [_backgroundColor release];
    [_chatDialog release];
    [_chatDialogCurrentParagraph release];
    [_font release];
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    

    _font = [[UIFont fontWithName:@"CourierNewPS-BoldMT" size:22.0f] retain];
    _backgroundColor = [[UIColor alloc] initWithRed:.2 green:.2 blue:.8 alpha:0.93];
    _upToMarker = 1.0;
    _chatDialogCurrentParagraph = @"";
    [self setChatDialog:@""];
    [self setNextParagraphofChatDialog];
    self.hidden=1;
    [self setBackgroundColor:[UIColor clearColor]];
    
    return self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)drawRect:(CGRect)rect 
{   
    //Move rectangle to bottom part of screen.
    rect = CGRectMake(0, 460-pixelHeight, 320, pixelHeight);
    
	CGContextRef context = UIGraphicsGetCurrentContext();  
	CGContextClearRect(context, [self bounds]);
	
    int a = 4; //inset in pixels
	
	CGContextSetLineWidth(context, 4.0);
	CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
	CGContextSetFillColorWithColor(context, [_backgroundColor CGColor]);
	
    CGContextMoveToPoint(context, rect.origin.x+a, rect.origin.y+a);
	CGContextAddLineToPoint(context, rect.origin.x+a, rect.origin.y+rect.size.height-a);
    CGContextAddLineToPoint(context, rect.origin.x+rect.size.width-a, rect.origin.y+rect.size.height-a);
    CGContextAddLineToPoint(context, rect.origin.x+rect.size.width-a, rect.origin.y+a);
    

    
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
    
    
    //Even if chat is empty it is clickable so we can't hide it.
    //Prevent the text shit from fucking up by doing this return.
    if(_chatDialogCurrentParagraph.length == 0)
        return;
    
    
    ///Draw Text
    NSString* _drawDialog = [_chatDialogCurrentParagraph substringToIndex:_upToMarker];
    
    rect = CGRectInset(rect, 10, 10);
    CGRect rect2 = CGRectMake(rect.origin.x+2, rect.origin.y+1, rect.size.width, rect.size.height);
    
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    [_drawDialog drawInRect:rect2 withFont:_font];
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    [_drawDialog drawInRect:rect withFont:_font];
    
    self.hidden = 0;    //Note: unhide AFTER drawing or else you get garbage for 1 frame.
}

//Steps chat one frame.
//returns SHOULD BE REDRAWN? true = yes, false = no.
-(bool) stepChatOnce
{        
    int temp = (int)_upToMarker;
    
    if (_upToMarker < _chatDialogCurrentParagraph.length) 
        _upToMarker= _upToMarker + (lettersPerSecond/FPS);
    
    //If something changed, draw it.
    if (temp!=(int)_upToMarker)
    {
        return 1;
    }
    return 0;
}

-(void) stepChatCompletelyOrAdvance
{
    
    //Not done filling out chat box, STEP IT UP
    if (_upToMarker < _chatDialogCurrentParagraph.length) 
        _upToMarker = _chatDialogCurrentParagraph.length-0.01;
    
    //Done filling out chat box, advance to next paragraph
    else if(_upToMarker >= _chatDialogCurrentParagraph.length) 
    {
        _upToMarker = 1;
        [self setNextParagraphofChatDialog];
        
        //No more chat so hide the entire chatbox.
        if(![self isInUse])
        {
            self.hidden = 1;
        }
    }
    
}
//mainly used for battle view
-(bool) isInUse
{
    return _chatDialogCurrentParagraph.length > 1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self stepChatCompletelyOrAdvance];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void) setChatDialog:(NSString*)newDialog
{
    NSArray* dialogWordsArray = [newDialog componentsSeparatedByString:@" "];
    _chatDialog  = [[NSMutableArray alloc] initWithArray:dialogWordsArray];
    [self setNextParagraphofChatDialog];
}


//This method converts _chatDialog (array of entire conversation) into a string that can be used to draw 1 screen full of text. Sets up _chatDialogCurrentParagraph so it can be automatically drawn in draw()
-(void) setNextParagraphofChatDialog
{
    NSString* temp = @"";
    
    int linesLeft = rows;
    int count = [_chatDialog count];
    int currentLineChars = 0;
    
    if (count == 0)
    {
        _chatDialogCurrentParagraph = [temp retain];    //keep it empty
        return;
    }
    
    for(int i = 0; i < count; i++) 
    {
        int currentWordLength = [[_chatDialog objectAtIndex:0] length];
        int nextWordLength = 0;
        
        if(i!=(count-1))    //Prevents out of bounds on the last iteration
            nextWordLength = [[_chatDialog objectAtIndex:1] length];

        temp = [temp stringByAppendingString:[_chatDialog objectAtIndex:0]];
        temp = [temp stringByAppendingString:@" "];
        [_chatDialog removeObjectAtIndex:0];
        
        currentLineChars += currentWordLength+1;
            
        if((currentLineChars + nextWordLength) > 22)
        {
            temp = [temp stringByAppendingString:@"\n"];
            currentLineChars = 0;
            linesLeft--;
        }
        
        if (linesLeft==0)
            break;            
    }
    
    _chatDialogCurrentParagraph = [temp retain];  
}



@end