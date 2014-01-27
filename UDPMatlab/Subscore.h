//
//  Subscore.h
//  UDPMatlab
//
//  Created by Matthew Rice on 1/21/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

enum SUBSCORE_INSTRUMENT
{
    SUBSCORE_CYMBAL,
    SUBSCORE_BASS_DRUM,
    SUBSCORE_SNARE,
    SUBSCORE_PIANO,
    SUBSCORE_GUITAR,
    SUBSCORE_NO_INSTRUMENT
};

@interface Subscore : NSObject

@property (nonatomic) enum SUBSCORE_INSTRUMENT type;
@property (strong, nonatomic) NSMutableArray *noteLines;
@property (strong, nonatomic) NSMutableArray *positionLines;

- (id)initWithInstrumentType:(enum SUBSCORE_INSTRUMENT)instrumentType;

@end
