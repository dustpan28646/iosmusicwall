//
//  ScoreObject.m
//  UDPMatlab
//
//  Created by Matthew Rice on 11/6/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import "ScoreObject.h"

@implementation ScoreObject

- (id) initWithInstrumentManager:(InstrumentViewsManager *)instrumentManager WithSubscoreDictionary:(NSMutableDictionary *)subscoreDict WithTimeIndices:(int)numberOfTimes
{
    self = [super init];
    if (self)
    {
        self.instViewsManager = instrumentManager;
        self.subscoreDictionary = subscoreDict;
        self.numberOfTimeInstances = numberOfTimes;
        self.instantaneousScoreArray = [[NSMutableArray alloc] initWithCapacity:numberOfTimes];
    }
    return self;
}

- (bool) addSubscoreWithName:(NSString *)subscoreName WithTimeIndex:(int)timeIndex
{
    Subscore *subscoreToAdd = [self.subscoreDictionary objectForKey:subscoreName];
    return YES;
}

- (bool) removeSubscoreWithName:(NSString *)subscoreName WithTimeIndex:(int)timeIndex
{
    return YES;
}

@end
