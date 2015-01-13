//
//  InstrumentViewsManager.m
//  UDPMatlab
//
//  Created by H. William Rice on 1/25/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import "InstrumentViewsManager.h"

@implementation InstrumentViewsManager

@synthesize guitarViews;
@synthesize pianoViews;
@synthesize drumViews;

- (id) initWithGuitars:(NSArray *)guitars andPianos:(NSArray *)pianos andDrums:(NSArray *)drums andNetworkHelper:(NetworkHelper *)helper
{
    self = [super init];
    if (self)
    {
        self.guitarViews = guitars;
        self.pianoViews = pianos;
        self.drumViews = drums;
        networkHelper = helper;
        //comment this when not wanting to print all this crap
        //this is just a convenient place to force all the positions to print to console
        
//        printf("guitarArray = [...\n");
//        for (GridView *guitarView in self.guitarViews)
//        {
//            [guitarView printButtonPositions];
//        }
//        
//        printf("];\npianoArray = [...\n");
//        
//        for (GridView *pianoView in self.pianoViews)
//        {
//            [pianoView printButtonPositions];
//        }
//        
//        printf("];\ndrumArray = [...\n");
//        
//        for (CymbalView *cymbalView in self.drumViews)
//        {
//            [cymbalView printPosition];
//        }
//        
//        printf("];\n");
        
        
//        printf("guitarXYWH = [...\n");
//        for (GridView *guitarView in self.guitarViews)
//        {
//            printf("%0.2f,%0.2f,%0.2f,%0.2f;...\n", guitarView.frame.origin.x, guitarView.frame.origin.y, guitarView.frame.size.width, guitarView.frame.size.height);
//        }
//        
//        printf("];\npianoXYWH = [...\n");
//        
//        for (GridView *pianoView in self.pianoViews)
//        {
//            printf("%0.2f,%0.2f,%0.2f,%0.2f;...\n", pianoView.frame.origin.x, pianoView.frame.origin.y, pianoView.frame.size.width, pianoView.frame.size.height);
//        }
//        
//        printf("];\ndrumXYWH = [...\n");
//        
//        for (CymbalView *cymbalView in self.drumViews)
//        {
//            printf("%0.2f,%0.2f,%0.2f,%0.2f;...\n", cymbalView.frame.origin.x, cymbalView.frame.origin.y, cymbalView.frame.size.width, cymbalView.frame.size.height);
//        }
//        
//        printf("];\n");
        
    }
    return self;
}

- (void) newInstantaneousScore:(InstantaneousScoreObject *)instantScore withTime:(int)timeIndex
{
    for (int i = 0; i < [guitarViews count]; i++)
    {
        GridView *view = [guitarViews objectAtIndex:i];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:6];
        for (int j = 0; j < 6; j++)
        {
            [array addObject:[instantScore.guitarScoreArray objectAtIndex:(i*6 + j)]];
        }
        [view setNoteArray:array withInstrumentType:[instantScore.guitarHasInstrumentType objectAtIndex:i] withNetworkHelper:networkHelper withInstrumentIndex:(i + 7) withTimeIndex:timeIndex];
    }
    
    for (int i = 0; i < [pianoViews count]; i++)
    {
        GridView *view = [pianoViews objectAtIndex:i];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:6];
        for (int j = 0; j < 6; j++)
        {
            [array addObject:[instantScore.pianoScoreArray objectAtIndex:(i*6 + j)]];
        }
        [view setNoteArray:array withInstrumentType:[instantScore.pianoHasInstrumentType objectAtIndex:i] withNetworkHelper:networkHelper withInstrumentIndex:i withTimeIndex:timeIndex];
    }
    
    for (int i = 0; i < [drumViews count]; i++)
    {
        CymbalView *view = [drumViews objectAtIndex:i];
        [view setNote:[instantScore.drumScoreArray objectAtIndex:i] withInstrumentType:[instantScore.drumHasInstrumentType objectAtIndex:i] withNetworkHelper:networkHelper withInstrumentIndex:i withTimeIndex:timeIndex];
    }
}

@end
