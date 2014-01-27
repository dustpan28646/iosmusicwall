//
//  InstantaneousScoreObject.m
//  UDPMatlab
//
//  Created by H. William Rice on 1/25/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import "InstantaneousScoreObject.h"

@implementation InstantaneousScoreObject

@synthesize guitarScoreArray;
@synthesize pianoScoreArray;
@synthesize drumScoreArray;
@synthesize subscores;
@synthesize guitarHasInstrumentType;
@synthesize pianoHasInstrumentType;
@synthesize drumHasInstrumentType;

- (id) initInstantaneousScoreObject
{
    self = [super init];
    if (self)
    {
        NSMutableArray *guitarArray = [[NSMutableArray alloc] initWithCapacity:42];
        for (int i = 0; i < 42; i++)
        {
            [guitarArray addObject:[[BooleanObject alloc] initWithBool:NO]];
        }
        
        NSMutableArray *pianoArray = [[NSMutableArray alloc] initWithCapacity:42];
        for (int i = 0; i < 42; i++)
        {
            [pianoArray addObject:[[BooleanObject alloc] initWithBool:NO]];
        }
        
        NSMutableArray *drumArray = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < 5; i++)
        {
            [drumArray addObject:[[BooleanObject alloc] initWithBool:NO]];
        }
        
        self.guitarScoreArray = [NSArray arrayWithArray:guitarArray];
        self.pianoScoreArray = [NSArray arrayWithArray:pianoArray];
        self.drumScoreArray = [NSArray arrayWithArray:drumArray];
        self.subscores = [[NSMutableDictionary alloc] init];
        
        guitarHasInstrumentType = [[NSArray alloc] initWithObjects:[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR], nil];
        pianoHasInstrumentType = [[NSArray alloc] initWithObjects:[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO], nil];
        drumHasInstrumentType = [[NSArray alloc] initWithObjects:[[InstrumentType alloc] initWithType:TYPE_CYMBAL],[[InstrumentType alloc] initWithType:TYPE_SNARE],[[InstrumentType alloc] initWithType:TYPE_SNARE],[[InstrumentType alloc] initWithType:TYPE_SNARE],[[InstrumentType alloc] initWithType:TYPE_BASS_DRUM], nil];
    }
    return self;
}

@end
