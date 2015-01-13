//
//  CymbalView.m
//  UDPMatlab
//
//  Created by Matthew Rice on 10/24/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import "CymbalView.h"

@implementation CymbalView
@synthesize delegate;

static float const buttonRadius = 6.0;
static float const unselectedRadius = 3.0;
static float const selectedRadius = 6.0;
static float const inset = 3.0;



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

- (void)initCustomView:(CGRect)frame
{
    type = [[InstrumentType alloc] initWithType:TYPE_SNARE];
    note = [[BooleanObject alloc] initWithBool:NO withSubscore:nil];
    CGRect myRect = CGRectMake(round(frame.origin.x + inset), round(frame.origin.y + inset) , round(frame.size.width - 2.0 * inset), round(frame.size.height - 2.0 * inset));
    center = CGPointMake(round(0.0 + (myRect.size.width/2.0)), round(0.0 + (myRect.size.height / 2.0)));
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(touchedNote:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.frame = CGRectMake(round(center.x - buttonRadius) , round(center.y - buttonRadius), round(2.0 * buttonRadius), round(2 * buttonRadius));
    [button setBackgroundColor:[UIColor clearColor]];
    [self addSubview:button];
    
    UIButton *instrumentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [instrumentButton addTarget:self action:@selector(touchedChangeInstrument:) forControlEvents:UIControlEventTouchDown];
    [instrumentButton setFrame:CGRectMake(round(0.0/*frame.origin.x - frame.size.height/4.0*/), round(0.0/*frame.origin.y + (3.0 * frame.size.height/4.0)*/), round(frame.size.height/4.0), round(frame.size.height/4.0))];
    [instrumentButton setBackgroundImage:[UIImage imageNamed:@"imageedit_2_3232341617.png"] forState:UIControlStateNormal];
    [instrumentButton setBackgroundColor:[UIColor clearColor]];
    [self addSubview:instrumentButton];
}

- (void) touchedChangeInstrument:(id)sender
{
    InstrumentType *newType;
    switch (type.type)
    {
        case TYPE_CYMBAL:
            //type.type = TYPE_SNARE;
            newType = [[InstrumentType alloc] initWithType:TYPE_SNARE];
            break;
        case TYPE_SNARE:
            //type.type = TYPE_BASS_DRUM;
            newType = [[InstrumentType alloc] initWithType:TYPE_BASS_DRUM];
            break;
        case TYPE_BASS_DRUM:
            //type.type = TYPE_CYMBAL;
            newType = [[InstrumentType alloc] initWithType:TYPE_CYMBAL];
            break;
        default:
            newType = [[InstrumentType alloc] initWithType:TYPE_SNARE];
            NSLog(@"Invalid Type in cymbal view");
            break;
    }
    [networkHelper sendString:[NSString stringWithFormat:@"<cd%i:%i:%i>",newType.type - 2,time,drumIndex]];
    [delegate didTapChangeDrumInView:self withInstrumentType:newType];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIImage *piano;
    
    switch (type.type)
    {
        case TYPE_SNARE:
            piano = [UIImage imageNamed:@"mpml3600cnlfr-d53b5582572e373a15dde974b3e6a0eb.jpg"];
            break;
        case TYPE_CYMBAL:
            piano = [UIImage imageNamed:@"cymbal.jpg"];
            break;
        case TYPE_BASS_DRUM:
            piano = [UIImage imageNamed:@"DV016_Jpg_Large_H71031.001.003_walnut_burst_24x18.jpg"];
            break;
        default:
            break;
    }
    
    [piano drawInRect:rect blendMode:kCGBlendModeNormal alpha:0.5];
    
    UIColor *blackColor = [UIColor blackColor];
    float crossLegLength = 10.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, blackColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, blackColor.CGColor);
    
    //CGContextFillEllipseInRect(context, myRect);
    //CGContextStrokeEllipseInRect(context, myRect);
    //CGContextFillPath(context);
    
    CGContextMoveToPoint(context, round(center.x), round(center.y));
    CGContextAddLineToPoint(context, round(center.x + crossLegLength), round(center.y));
    
    CGContextMoveToPoint(context, round(center.x), round(center.y));
    CGContextAddLineToPoint(context, round(center.x - crossLegLength), round(center.y));
    
    CGContextMoveToPoint(context, round(center.x), round(center.y));
    CGContextAddLineToPoint(context, round(center.x), round(center.y + crossLegLength));
    
    CGContextMoveToPoint(context, round(center.x), round(center.y));
    CGContextAddLineToPoint(context, round(center.x), round(center.y - crossLegLength));
    
    CGContextStrokePath(context);
    UIColor *circleColor = blackColor;
    float drawRadius = 0.0;
    if (note.doesNoteExist)
    {
        drawRadius = selectedRadius;
        circleColor = [BooleanObject colorForSubscore:note.noteSubscore];
    }
    else
    {
        drawRadius = unselectedRadius;
    }
    CGContextSetFillColorWithColor(context, circleColor.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(round(center.x - drawRadius) , round(center.y - drawRadius), round(2.0 * drawRadius), round(2.0 * drawRadius)));
    CGContextFillPath(context);
}

- (void)setNote:(BooleanObject *)booleanNoteObject withInstrumentType:(InstrumentType *)instType withNetworkHelper:(NetworkHelper *)helper withInstrumentIndex:(int)index withTimeIndex:(int)timeIndex
{
    type = instType;
    note = booleanNoteObject;
    networkHelper = helper;
    drumIndex = index;
    time = timeIndex;
    [self setNeedsDisplay];
}

- (void) touchedNote:(id)sender
{
    note.doesNoteExist = !note.doesNoteExist;
    note.noteSubscore = nil;
    if (note.doesNoteExist)
    {
        [networkHelper sendString:[NSString stringWithFormat:@"<ad%i:%i:%i>",type.type - 2,time,drumIndex]];
    }
    else
    {
        [networkHelper sendString:[NSString stringWithFormat:@"<rd%i:%i:%i>",type.type - 2,time,drumIndex]];
    }
    [self setNeedsDisplay];
    [delegate didChangeNoteForCurrentTime];
}


- (void) printPosition
{
    printf("%0.2f, %0.2f;...\n",round(center.x + self.frame.origin.x),round(center.y + self.frame.origin.y));
}

- (enum INSTRUMENT_TYPE) getInstrumentType
{
    return type.type;
}



@end
