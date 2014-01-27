//
//  ScoreObject.h
//  UDPMatlab
//
//  Created by Matthew Rice on 11/6/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstrumentViewsManager.h"
#import "InstantaneousScoreObject.h"
#import "Subscore.h"

@interface ScoreObject : NSObject

@property (strong, nonatomic) InstrumentViewsManager *instViewsManager;
@property (strong, nonatomic) NSMutableDictionary *subscoreDictionary;
@property (nonatomic) int numberOfTimeInstances;
@property (strong, nonatomic) NSMutableArray *instantaneousScoreArray;

- (id) initWithInstrumentManager:(InstrumentViewsManager *)instrumentManager WithSubscoreDictionary:(NSMutableDictionary *)subscoreDict WithTimeIndices:(int)numberOfTimes;

- (bool) addSubscoreWithName:(NSString *)subscoreName WithTimeIndex:(int)timeIndex;

- (bool) removeSubscoreWithName:(NSString *)subscoreName WithTimeIndex:(int)timeIndex;

@end
