//
//  ScoreObject.m
//  UDPMatlab
//
//  Created by Matthew Rice on 11/6/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import "ScoreObject.h"

@implementation ScoreObject

@synthesize instViewsManager;
@synthesize subscoreDictionary;
@synthesize numberOfTimeInstances;
@synthesize instantaneousScoreArray;

- (id) initWithInstrumentManager:(InstrumentViewsManager *)instrumentManager withSubscoreDictionary:(NSMutableDictionary *)subscoreDict withTimeIndices:(int)numberOfTimes
{
    self = [super init];
    if (self)
    {
        self.instViewsManager = instrumentManager;
        self.subscoreDictionary = subscoreDict;
        self.numberOfTimeInstances = numberOfTimes;
        self.instantaneousScoreArray = [[NSMutableArray alloc] initWithCapacity:numberOfTimes];
        for (int i = 0; i < numberOfTimes; i++)
        {
            [self.instantaneousScoreArray addObject:[[InstantaneousScoreObject alloc] initInstantaneousScoreObject]];
        }
        for (Subscore *mySubscore in [self.subscoreDictionary allValues])
        {
            if (mySubscore.isDefault)
            {
                [self addSubscoreWithName:mySubscore.name withTimeIndex:0];
            }
        }
    }
    return self;
}

- (void) addSubscoreWithName:(NSString *)subscoreName withTimeIndex:(int)timeIndex
{
    Subscore *subscore = [subscoreDictionary objectForKey:subscoreName];
    
    if (subscore.type == SUBSCORE_PIANO)
    {
        for (NSMutableArray *noteLine in subscore.noteLines)
        {
            for (int i = timeIndex; i < numberOfTimeInstances; i++)
            {
                InstantaneousScoreObject *instantaneousScore = [instantaneousScoreArray objectAtIndex:i];
                SubscoreNote *note = [noteLine objectAtIndex:i];
                int integerIndex = [note getIntegerIndexForNote];
                if (integerIndex < 42)
                {
                    BooleanObject *scoreNote = [instantaneousScore.pianoScoreArray objectAtIndex:integerIndex];
                    scoreNote.doesNoteExist = YES;
                    scoreNote.noteSubscore = subscore;
                }
                else if(integerIndex != 220)
                {
                    NSLog(@"Warning! Invalid Index Attempted to add to Score: %i",integerIndex);
                }
                [instantaneousScore.subscores setObject:subscore forKey:subscoreName];
            }
        }
    }
    else if (subscore.type == SUBSCORE_GUITAR)
    {
        for (NSMutableArray *noteLine in subscore.noteLines)
        {
            for (int i = timeIndex; i < numberOfTimeInstances; i++)
            {
                InstantaneousScoreObject *instantaneousScore = [instantaneousScoreArray objectAtIndex:i];
                SubscoreNote *note = [noteLine objectAtIndex:i];
                int integerIndex = [note getIntegerIndexForNote];
                if (integerIndex < 42)
                {
                    BooleanObject *scoreNote = [instantaneousScore.guitarScoreArray objectAtIndex:integerIndex];
                    scoreNote.doesNoteExist = YES;
                    scoreNote.noteSubscore = subscore;
                }
                else if (integerIndex != 220)
                {
                    NSLog(@"Warning! Invalid Index Attempted to add to Score: %i",integerIndex);
                }
                [instantaneousScore.subscores setObject:subscore forKey:subscoreName];
            }
        }
    }
    else if (subscore.type == SUBSCORE_DRUM)
    {
        for (NSMutableArray *noteLine in subscore.noteLines)
        {
            for (int i = timeIndex; i < numberOfTimeInstances; i++)
            {
                InstantaneousScoreObject *instantaneousScore = [instantaneousScoreArray objectAtIndex:i];
                SubscoreNote *note = [noteLine objectAtIndex:i];
                int integerIndex = [note getIntegerIndexForNote];
                if (integerIndex < 5)
                {
                    BooleanObject *scoreNote = [instantaneousScore.drumScoreArray objectAtIndex:integerIndex];
                    scoreNote.doesNoteExist = YES;
                    scoreNote.noteSubscore = subscore;
                }
                else  if (integerIndex != 220)
                {
                    NSLog(@"Warning! Invalid Index Attempted to add to Score: %i",integerIndex);
                }
                [instantaneousScore.subscores setObject:subscore forKey:subscoreName];
            }
        }
    }
    else
    {
        NSLog(@"Warning! Invalid Score Instrument Found!");
    }
}

- (void) removeSubscoreWithName:(NSString *)subscoreName withTimeIndex:(int)timeIndex
{
    Subscore *subscore = [subscoreDictionary objectForKey:subscoreName];
    
    if (subscore.type == SUBSCORE_PIANO)
    {
        for (NSMutableArray *noteLine in subscore.noteLines)
        {
            for (int i = timeIndex; i < numberOfTimeInstances; i++)
            {
                InstantaneousScoreObject *instantaneousScore = [instantaneousScoreArray objectAtIndex:i];
                SubscoreNote *note = [noteLine objectAtIndex:i];
                int integerIndex = [note getIntegerIndexForNote];
                if (integerIndex < 42)
                {
                    BooleanObject *scoreNote = [instantaneousScore.pianoScoreArray objectAtIndex:integerIndex];
                    scoreNote.doesNoteExist = NO;
                    scoreNote.noteSubscore = nil;
                }
                else if(integerIndex != 220)
                {
                    NSLog(@"Warning! Invalid Index Attempted to remove from Score");
                }
                [instantaneousScore.subscores removeObjectForKey:subscoreName];
            }
        }
    }
    else if (subscore.type == SUBSCORE_GUITAR)
    {
        for (NSMutableArray *noteLine in subscore.noteLines)
        {
            for (int i = timeIndex; i < numberOfTimeInstances; i++)
            {
                InstantaneousScoreObject *instantaneousScore = [instantaneousScoreArray objectAtIndex:i];
                SubscoreNote *note = [noteLine objectAtIndex:i];
                int integerIndex = [note getIntegerIndexForNote];
                if (integerIndex < 42)
                {
                    BooleanObject *scoreNote = [instantaneousScore.guitarScoreArray objectAtIndex:integerIndex];
                    scoreNote.doesNoteExist = NO;
                    scoreNote.noteSubscore = nil;
                }
                else if (integerIndex != 220)
                {
                    NSLog(@"Warning! Invalid Index Attempted to remove from Score");
                }
                [instantaneousScore.subscores removeObjectForKey:subscoreName];
            }
        }
    }
    else if (subscore.type == SUBSCORE_DRUM)
    {
        for (NSMutableArray *noteLine in subscore.noteLines)
        {
            for (int i = timeIndex; i < numberOfTimeInstances; i++)
            {
                InstantaneousScoreObject *instantaneousScore = [instantaneousScoreArray objectAtIndex:i];
                SubscoreNote *note = [noteLine objectAtIndex:i];
                int integerIndex = [note getIntegerIndexForNote];
                if (integerIndex < 5)
                {
                    BooleanObject *scoreNote = [instantaneousScore.drumScoreArray objectAtIndex:integerIndex];
                    scoreNote.doesNoteExist = NO;
                    scoreNote.noteSubscore = nil;
                }
                else  if (integerIndex != 220)
                {
                    NSLog(@"Warning! Invalid Index Attempted to remove from Score");
                }
                [instantaneousScore.subscores removeObjectForKey:subscoreName];
            }
        }
    }
    else
    {
        NSLog(@"Warning! Invalid Score Instrument Found!");
    }
    
}

- (void) changeTimeIndexTo:(int)index
{
    [instViewsManager newInstantaneousScore:[instantaneousScoreArray objectAtIndex:index]];
}

- (void) addOrRemoveSubscoreWithName:(NSString *)subscoreName withTimeIndex:(int)timeIndex
{
    if ([self isSubscoreName:subscoreName includedInScoreAtTime:timeIndex])
    {
        [self removeSubscoreWithName:subscoreName withTimeIndex:timeIndex];
    }
    else
    {
        [self addSubscoreWithName:subscoreName withTimeIndex:timeIndex];
    }
}

- (bool) isSubscoreName:(NSString *)subscoreName includedInScoreAtTime:(int)time
{
    InstantaneousScoreObject *instScore = [instantaneousScoreArray objectAtIndex:time];
    return ([instScore.subscores objectForKey:subscoreName] != nil);
}

- (void) changeDrumView:(CymbalView *)view toInstrumentType:(InstrumentType *)instrumentType withTimeIndex:(int)time
{
    NSUInteger index = [instViewsManager.drumViews indexOfObject:view];
    if (index != NSNotFound)
    {
        for (int i = time; i < numberOfTimeInstances; i++)
        {
            InstantaneousScoreObject *instScore = [instantaneousScoreArray objectAtIndex:i];
            InstrumentType *myInstType = [instScore.drumHasInstrumentType objectAtIndex:index];
            myInstType.type = instrumentType.type;
        }
    }
}

- (void) changeGridView:(GridView *)view toInstrumentType:(InstrumentType *)instrumentType withTimeIndex:(int)time
{
    NSUInteger index = [instViewsManager.guitarViews indexOfObject:view];
    if (index != NSNotFound)
    {
        for (int i = time; i < numberOfTimeInstances; i++)
        {
            InstantaneousScoreObject *instScore = [instantaneousScoreArray objectAtIndex:i];
            InstrumentType *myInstType = [instScore.guitarHasInstrumentType objectAtIndex:index];
            myInstType.type = instrumentType.type;
        }
        return;
    }
    
    index = [instViewsManager.pianoViews indexOfObject:view];
    
    if (index != NSNotFound)
    {
        for (int i = time; i < numberOfTimeInstances; i++)
        {
            InstantaneousScoreObject *instScore = [instantaneousScoreArray objectAtIndex:i];
            InstrumentType *myInstType = [instScore.pianoHasInstrumentType objectAtIndex:index];
            myInstType.type = instrumentType.type;
        }
    }
    
}

@end
