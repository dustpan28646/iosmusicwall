//
//  ScoreObject.h
//  UDPMatlab
//
//  Created by Matthew Rice on 11/6/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstrumentViewsManager.h"

@interface ScoreObject : NSObject
{
    NetworkHelper *networkHelper;
}

@property (strong, nonatomic) InstrumentViewsManager *instViewsManager;
@property (strong, nonatomic) NSMutableDictionary *subscoreDictionary;
@property (nonatomic) int numberOfTimeInstances;
@property (strong, nonatomic) NSMutableArray *instantaneousScoreArray;

- (id) initWithInstrumentManager:(InstrumentViewsManager *)instrumentManager withSubscoreDictionary:(NSMutableDictionary *)subscoreDict withTimeIndices:(int)numberOfTimes withNetworkHelper:(NetworkHelper *)helper;

- (void) addSubscoreWithName:(NSString *)subscoreName withTimeIndex:(int)timeIndex;

- (void) removeSubscoreWithName:(NSString *)subscoreName withTimeIndex:(int)timeIndex;

- (bool) addOrRemoveSubscoreWithName:(NSString *)subscoreName withTimeIndex:(int)timeIndex;

- (void) changeTimeIndexTo:(int)index;

- (void) changeGridView:(GridView *)view toInstrumentType:(InstrumentType *)instrumentType withTimeIndex:(int)time;

- (void) changeDrumView:(CymbalView *)view toInstrumentType:(InstrumentType *)instrumentType withTimeIndex:(int)time;

- (bool) isSubscoreName:(NSString *)subscoreName includedInScoreAtTime:(int)time;

- (bool) isCurrentScoreFeasible:(NSArray *)numAvailableRobots withOptimalDistribution:(NSMutableArray *)optimalDistribution withFeasibilityArray:(NSMutableArray *)feasArray;

- (void) startPlayingWithMessage:(NSString *)message;

- (void) sendRemoveSubscoreMessage:(NSString *)subscoreName withStartTimeIndex:(int)timeIndex;

- (void) sendAddSubscoreMessage:(NSString *)subscoreName withStartTimeIndex:(int)timeIndex;

@end
