//
//  InstrumentType.m
//  UDPMatlab
//
//  Created by Matthew Rice on 1/27/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import "InstrumentType.h"

@implementation InstrumentType

@synthesize type;

- (id) initWithType:(enum INSTRUMENT_TYPE)instrumentType
{
    self = [super init];
    if (self)
    {
        type = instrumentType;
    }
    return self;
}

@end
