//
//  InstrumentType.h
//  UDPMatlab
//
//  Created by Matthew Rice on 1/27/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

enum INSTRUMENT_TYPE
{
    TYPE_GUITAR,
    TYPE_PIANO,
    TYPE_CYMBAL,
    TYPE_SNARE,
    TYPE_BASS_DRUM
};

@interface InstrumentType : NSObject

@property (nonatomic) enum INSTRUMENT_TYPE type;

- (id) initWithType:(enum INSTRUMENT_TYPE)instrumentType;

@end
