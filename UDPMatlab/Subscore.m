//
//  Subscore.m
//  UDPMatlab
//
//  Created by Matthew Rice on 1/21/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import "Subscore.h"

@implementation Subscore

@synthesize type;
@synthesize noteLines;
@synthesize positionLines;

- (id)initWithInstrumentType:(enum SUBSCORE_INSTRUMENT)instrumentType
{
    self = [super init];
    if (self)
    {
        self.noteLines = [[NSMutableArray alloc] init];
        self.positionLines = [[NSMutableArray alloc] init];
        self.type = instrumentType;
    }
    return self;
}

@end