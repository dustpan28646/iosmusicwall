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

- (id) initWithGuitars:(NSArray *)guitars andPianos:(NSArray *)pianos andDrums:(NSArray *)drums
{
    self = [super init];
    if (self)
    {
        self.guitarViews = guitars;
        self.pianoViews = pianos;
        self.drumViews = drums;
    }
    return self;
}

- (void) newInstantaneousScore:(InstantaneousScoreObject *)instantScore
{
    for (int i = 0; i < [guitarViews count]; i++)
    {
        GridView *view = [guitarViews objectAtIndex:i];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:6];
        for (int j = 0; j < 6; j++)
        {
            [array addObject:[instantScore.guitarScoreArray objectAtIndex:(i*6 + j)]];
        }
        [view setNoteArray:array withInstrumentType:[instantScore.guitarHasInstrumentType objectAtIndex:i]];
    }
    
    for (int i = 0; i < [pianoViews count]; i++)
    {
        GridView *view = [pianoViews objectAtIndex:i];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:6];
        for (int j = 0; j < 6; j++)
        {
            [array addObject:[instantScore.pianoScoreArray objectAtIndex:(i*6 + j)]];
        }
        [view setNoteArray:array withInstrumentType:[instantScore.pianoHasInstrumentType objectAtIndex:i]];
    }
    
    for (int i = 0; i < [drumViews count]; i++)
    {
        CymbalView *view = [drumViews objectAtIndex:i];
        [view setNote:[instantScore.drumScoreArray objectAtIndex:i] withInstrumentType:[instantScore.drumHasInstrumentType objectAtIndex:i]];
    }
}

@end
