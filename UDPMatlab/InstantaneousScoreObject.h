//
//  InstantaneousScoreObject.h
//  UDPMatlab
//
//  Created by H. William Rice on 1/25/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BooleanObject.h"
#import "InstrumentType.h"

@interface InstantaneousScoreObject : NSObject
{
    Subscore *userSubscore;
}

@property (strong, nonatomic) NSArray *guitarScoreArray;
@property (strong, nonatomic) NSArray *pianoScoreArray;
@property (strong, nonatomic) NSArray *drumScoreArray;
@property (strong, nonatomic) NSMutableDictionary *subscores;
@property (strong, nonatomic) NSArray *guitarHasInstrumentType;
@property (strong, nonatomic) NSArray *pianoHasInstrumentType;
@property (strong, nonatomic) NSArray *drumHasInstrumentType;

- (id) initInstantaneousScoreObjectWithUserSubscore:(Subscore *)userSub;
- (bool)doesHaveUserNotes;
- (NSDictionary *)subscoresWithNotes;

@end
