//
//  GridView.m
//  UDPMatlab
//
//  Created by Matthew Rice on 10/24/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import "GridView.h"

@implementation GridView
@synthesize delegate;

static float const unselectedRadius = 3.0;
static float const selectedRadius = 6.0;
static float const buttonRadius = 15.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initCustomView:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initCustomView:self.frame];
    }
    return self;
}

-(void)initCustomView:(CGRect)frame
{
    NSLog(@"Frame Height = %f, Frame Width = %f", frame.size.height, frame.size.width);
    type = [[InstrumentType alloc] initWithType:TYPE_PIANO];
    NSMutableArray *myArray = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i = 0; i < 6; i++)
    {
        [myArray addObject:[[BooleanObject alloc] initWithBool:NO withSubscore:nil]];
    }
    score = myArray;
    // Initialization code
    jumpSize = frame.size.width/7.0;
    for (int i = 0; i < 6; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        switch (i)
        {
            case 0:
                [button addTarget:self
                           action:@selector(touchedNoteOne:)
                 forControlEvents:UIControlEventTouchDown];
                break;
            case 1:
                [button addTarget:self
                           action:@selector(touchedNoteTwo:)
                 forControlEvents:UIControlEventTouchDown];
                break;
            case 2:
                [button addTarget:self
                           action:@selector(touchedNoteThree:)
                 forControlEvents:UIControlEventTouchDown];
                break;
            case 3:
                [button addTarget:self
                           action:@selector(touchedNoteFour:)
                 forControlEvents:UIControlEventTouchDown];
                break;
            case 4:
                [button addTarget:self
                           action:@selector(touchedNoteFive:)
                 forControlEvents:UIControlEventTouchDown];
                break;
            case 5:
                [button addTarget:self
                           action:@selector(touchedNoteSix:)
                 forControlEvents:UIControlEventTouchDown];
                break;
            default:
                break;
        }
        [button setTitle:@"" forState:UIControlStateNormal];
        button.frame = CGRectMake(round(0.0 + (((double)(i + 1)) * jumpSize) - buttonRadius) , round(0.0 + (frame.size.height * 0.5) - buttonRadius), round(2 * buttonRadius), round(2 * buttonRadius));
        [button setBackgroundColor:[UIColor clearColor]];
        [self addSubview:button];
        NSLog(@"button %d center (X,Y) = (%0.2f, %0.2f)", i, round(button.frame.origin.x + (button.frame.size.width/2.0)), round(button.frame.origin.y + (button.frame.size.height/2.0)));
    }
    
    UIButton *instrumentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [instrumentButton addTarget:self action:@selector(touchedChangeInstrument:) forControlEvents:UIControlEventTouchDown];
    [instrumentButton setFrame:CGRectMake(round(0.0 /*- frame.size.height/4.0*/), round(0.0 /*+ (3.0 * frame.size.height/4.0)*/), round(frame.size.height/3.5), round(frame.size.height/3.5))];
    //[instrumentButton setBackgroundImage:[UIImage imageNamed:@"imageedit_2_3232341617.png"] forState:UIControlStateNormal];
    [instrumentButton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:instrumentButton];
}

- (void)touchedChangeInstrument:(id)sender
{
    InstrumentType *newType;
    if (type.type == TYPE_GUITAR)
    {
        //type.type = TYPE_PIANO;
        newType = [[InstrumentType alloc] initWithType:TYPE_PIANO];
        [networkHelper sendString:[NSString stringWithFormat:@"<cp:%i:%i>",time,gridIndex]];
    }
    else if (type.type == TYPE_PIANO)
    {
        //type.type = TYPE_GUITAR;
        newType = [[InstrumentType alloc] initWithType:TYPE_GUITAR];
        [networkHelper sendString:[NSString stringWithFormat:@"<cg:%i:%i>",time,gridIndex]];
    }
    else
    {
        newType = [[InstrumentType alloc] initWithType:TYPE_PIANO];
        [networkHelper sendString:[NSString stringWithFormat:@"<cp:%i:%i>",time,gridIndex]];
        NSLog(@"Invalid Type in grid view");
    }
    [delegate didTapChangeGridInView:self withInstrumentType:newType];
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect
{
    UIImage *instrumentImage = nil;
    UIColor *blackColor = [UIColor blackColor];
    if (type.type == TYPE_GUITAR)
    {
        instrumentImage = [UIImage imageNamed:@"acoustic6string.jpg"];
    }
    else
    {
        instrumentImage = [UIImage imageNamed:@"Piano_Keyboard.jpg"];
    }
    
    [instrumentImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:0.4];
    
    int i = 0;
    UIColor *myColor = [UIColor blackColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGContextMoveToPoint(context, round(rect.origin.x), round(rect.origin.y + (rect.size.height/2.0)));
    CGContextAddLineToPoint(context, round(0.0 + rect.size.width), round(0.0 + (rect.size.height / 2.0)));
    CGContextStrokePath(context);
    CGContextFillPath(context);
    
    
    float circleRadius = unselectedRadius;
    while (i < 6)
    {
        BooleanObject *boolObj = [score objectAtIndex:i];
        if (boolObj.value)
        {
            circleRadius = selectedRadius;
            myColor = [BooleanObject colorForSubscore:boolObj.noteSubscore];
        }
        else
        {
            circleRadius = unselectedRadius;
            myColor = blackColor;
        }
        CGContextSetFillColorWithColor(context, myColor.CGColor);
        CGContextMoveToPoint(context, round(0.0 + (((double)(i + 1)) * jumpSize)), round(0.0 + (rect.size.height * 0.25)));
        CGContextAddLineToPoint(context, round(0.0 + (((double)(i + 1)) * jumpSize)), round(0.0 + (rect.size.height * 0.75)));
        CGContextStrokePath(context);
        CGContextFillEllipseInRect(context, CGRectMake(round(0.0 + (((double)(i + 1)) * jumpSize) - circleRadius) , round(0.0 + (rect.size.height * 0.5) - circleRadius), round(2 * circleRadius), round(2 * circleRadius)));
        CGContextFillPath(context);
        i++;
    }
}

- (void)setNoteArray:(NSArray *)notes withInstrumentType:(InstrumentType *)instType withNetworkHelper:(NetworkHelper *)helper withInstrumentIndex:(int)index withTimeIndex:(int)timeIndex
{
    type = instType;
    score = notes;
    networkHelper = helper;
    gridIndex = index;
    time = timeIndex;
    [self setNeedsDisplay];
}

-(void)touchedNoteSix:(id)sender
{
    [self touchedNoteWithIndex:5];
}
-(void)touchedNoteOne:(id)sender
{
    [self touchedNoteWithIndex:0];
}
-(void)touchedNoteTwo:(id)sender
{
    [self touchedNoteWithIndex:1];
}
-(void)touchedNoteThree:(id)sender
{
    [self touchedNoteWithIndex:2];
}
-(void)touchedNoteFour:(id)sender
{
    [self touchedNoteWithIndex:3];
}
-(void)touchedNoteFive:(id)sender
{
    [self touchedNoteWithIndex:4];
}

-(void)touchedNoteWithIndex:(int)index
{
    BooleanObject *boolObj = [score objectAtIndex:index];
    Subscore *temp = boolObj.noteSubscore;  //once again, not sure if we need to actually nil this out, but just in case
    boolObj.value = !boolObj.value;
    boolObj.noteSubscore = nil;
    if (![delegate isValidNoteChangeForCurrentTime])
    {
        boolObj.value = !boolObj.value;
        boolObj.noteSubscore = temp;
        if (![delegate isValidNoteChangeForCurrentTime])
        {
            NSLog(@"Problem: reversing note change didn't fix feasibility.");
        }
    }
    else
    {
        [self sendAddOrRemoveNoteMessageWithNoteIndex:index withAddOrRemoveBool:boolObj.value];
        [self setNeedsDisplay];
    }
}

-(void) printButtonPositions
{
    CGRect bigFrame = self.frame;
    jumpSize = bigFrame.size.width/7.0;
    for (int i = 0; i<6; i++)
    {
        CGRect frame = CGRectMake(round(0.0 + (((double)(i + 1)) * jumpSize) - buttonRadius) , round(0.0 + (bigFrame.size.height * 0.5) - buttonRadius), round(2 * buttonRadius), round(2 * buttonRadius));
        printf("%0.2f, %0.2f;...\n", round(bigFrame.origin.x + frame.origin.x + (frame.size.width/2.0)), round(bigFrame.origin.y + frame.origin.y + (frame.size.height/2.0)));
    }
}

- (void) sendAddOrRemoveNoteMessageWithNoteIndex:(int)index withAddOrRemoveBool:(bool)doesNoteExist
{
    int fullNoteIndex = index + gridIndex*6;
    if (doesNoteExist)
    {//add note
        if (type.type == TYPE_PIANO)
        {
            [networkHelper sendString:[NSString stringWithFormat:@"<ap:%i:%i>",time,fullNoteIndex]];
        }
        else if (type.type == TYPE_GUITAR)
        {
            [networkHelper sendString:[NSString stringWithFormat:@"<ag:%i:%i>",time,fullNoteIndex]];
        }
    }
    else
    {//remove note
        if (type.type == TYPE_PIANO)
        {
            [networkHelper sendString:[NSString stringWithFormat:@"<rp:%i:%i>",time,fullNoteIndex]];
        }
        else if (type.type == TYPE_GUITAR)
        {
            [networkHelper sendString:[NSString stringWithFormat:@"<rg:%i:%i>",time,fullNoteIndex]];
        }
    }
}

@end
