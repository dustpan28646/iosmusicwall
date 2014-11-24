//
//  ScoreObject.m
//  UDPMatlab
//
//  Created by Matthew Rice on 11/6/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import "ScoreObject.h"
#include "initialAssignment.h"
#include "minRobots.h"

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
        Subscore *placeholderUserSubscore = [[Subscore alloc] initWithInstrumentType:SUBSCORE_NO_INSTRUMENT withIsDefault:NO wthName:@"User Subscore" withColor:[UIColor yellowColor]];
        for (int i = 0; i < numberOfTimes; i++)
        {
            [self.instantaneousScoreArray addObject:[[InstantaneousScoreObject alloc] initInstantaneousScoreObjectWithUserSubscore:placeholderUserSubscore]];
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

- (bool) isCurrentScoreFeasible:(NSArray *)numAvailableRobots withOptimalDistribution:(NSMutableArray *)optimalDistribution withFeasibilityArray:(NSMutableArray *)feasibilityArray
{
    int i = 0;
    
    int numberOfPositionsEachTime[self.numberOfTimeInstances];
    enum CombinationalType *positionMatrix[self.numberOfTimeInstances];
    
    for (InstantaneousScoreObject *instScore in instantaneousScoreArray)
    {
        positionMatrix[i] = malloc(89 * sizeof(int));
        int positionArrayIndex = 0;
        for (int j = 0; j < 42; j++)
        {
            BooleanObject *booleanObj = [instScore.guitarScoreArray objectAtIndex:j];
            if(booleanObj.doesNoteExist)
            {
                positionMatrix[i][positionArrayIndex] = [self convertInstrumentTypeToCombinationalType:[instScore.guitarHasInstrumentType objectAtIndex:floor(j/7)]];
                positionArrayIndex++;
            }
            
            booleanObj = [instScore.pianoScoreArray objectAtIndex:j];
            if(booleanObj.doesNoteExist)
            {
                positionMatrix[i][positionArrayIndex] = [self convertInstrumentTypeToCombinationalType:[instScore.pianoHasInstrumentType objectAtIndex:floor(j/7)]];
                positionArrayIndex++;
            }
        }
        
        for (int j = 0; j<5; j++)
        {
            BooleanObject *booleanObj = [instScore.drumScoreArray objectAtIndex:j];
            if(booleanObj.doesNoteExist)
            {
                positionMatrix[i][positionArrayIndex] = [self convertInstrumentTypeToCombinationalType:[instScore.drumHasInstrumentType objectAtIndex:j]];
                positionArrayIndex++;
            }
        }
        positionMatrix[i] = realloc(positionMatrix[i], positionArrayIndex * sizeof(int));
        numberOfPositionsEachTime[i] = positionArrayIndex;
        
        i++;
    }
    
    int availableRobots[numAvailableRobots.count];
    for (int i = 0; i < numAvailableRobots.count; i++)
    {
        NSNumber *num = [numAvailableRobots objectAtIndex:i];
        availableRobots[i] = num.intValue;
    }
    
    enum CombinationalType rGroup[7] = {TYPE_P, TYPE_G, TYPE_D, TYPE_PG, TYPE_GD, TYPE_PD, TYPE_PGD};
    
    int assignmentMatrix[self.numberOfTimeInstances][7];
    int jMaxArray[7];
    int *jMaxIndices[7];
    int numberOfJMaxIndicesForRobotType[7];
    int totalRobotsUsed;
    int feasArray[self.numberOfTimeInstances];
    
    bool isAssignmentFeasible = isFeasibleAssignment(self.numberOfTimeInstances, 7, numberOfPositionsEachTime, positionMatrix, rGroup, availableRobots, assignmentMatrix, jMaxArray, jMaxIndices, numberOfJMaxIndicesForRobotType, &totalRobotsUsed, feasArray);
    
    bool successfulMinRobots = findMinRobotDistrib(self.numberOfTimeInstances, 7, numberOfPositionsEachTime, positionMatrix, rGroup, availableRobots, assignmentMatrix, jMaxArray, jMaxIndices, numberOfJMaxIndicesForRobotType, &totalRobotsUsed);
    //call min robots here
    //notes: remember to check for zero positions
    //things to do: finish min robots function, add in call here, add in "library," check speed, transfer optimal distribution into array to return
    
    for (int i = 0; i<7; i++)
    {
        printf("%i",jMaxArray[i]);
        [optimalDistribution addObject:[[NSNumber alloc] initWithInt:jMaxArray[i]]];
    }
    
    for (int i=0; i <7; i++)
    {
        if (numberOfJMaxIndicesForRobotType[i] > 0)
        {
            free(jMaxIndices[i]);
        }
    }
    
    for (int i = 0; i < self.numberOfTimeInstances; i++)
    {
        [feasibilityArray replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:feasArray[i]]];
        free(positionMatrix[i]);
    }
    
    return (isAssignmentFeasible && successfulMinRobots);
}

- (enum CombinationalType) convertInstrumentTypeToCombinationalType:(InstrumentType *)instrumentTypeObject
{
    enum INSTRUMENT_TYPE myType = instrumentTypeObject.type;
    switch (myType)
    {
        case TYPE_PIANO:
            return TYPE_P;
            break;
        case TYPE_GUITAR:
            return TYPE_G;
            break;
        default:
            return TYPE_D;
            break;
    }
}

@end
