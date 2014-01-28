//
//  ScoreObject.h
//  UDPMatlab
//
//  Created by Matthew Rice on 11/6/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstrumentViewsManager.h"
#import "Subscore.h"

@interface ScoreObject : NSObject

@property (strong, nonatomic) InstrumentViewsManager *instViewsManager;
@property (strong, nonatomic) NSMutableDictionary *subscoreDictionary;
@property (nonatomic) int numberOfTimeInstances;
@property (strong, nonatomic) NSMutableArray *instantaneousScoreArray;

- (id) initWithInstrumentManager:(InstrumentViewsManager *)instrumentManager withSubscoreDictionary:(NSMutableDictionary *)subscoreDict withTimeIndices:(int)numberOfTimes;

- (void) addSubscoreWithName:(NSString *)subscoreName withTimeIndex:(int)timeIndex;

- (void) removeSubscoreWithName:(NSString *)subscoreName withTimeIndex:(int)timeIndex;

- (void) addOrRemoveSubscoreWithName:(NSString *)subscoreName withTimeIndex:(int)timeIndex;

- (void) changeTimeIndexTo:(int)index;

- (void) changeGridView:(GridView *)view toInstrumentType:(InstrumentType *)instrumentType withTimeIndex:(int)time;

- (void) changeDrumView:(CymbalView *)view toInstrumentType:(InstrumentType *)instrumentType withTimeIndex:(int)time;

- (bool) isSubscoreName:(NSString *)subscoreName includedInScoreAtTime:(int)time;

@end
