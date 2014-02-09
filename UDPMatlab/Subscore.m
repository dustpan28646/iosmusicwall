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
@synthesize isDefault;
@synthesize name;

- (id)initWithInstrumentType:(enum SUBSCORE_INSTRUMENT)instrumentType withIsDefault:(bool)isSubscoreDefault wthName:(NSString *)subscoreName withColor:(UIColor *)subscoreColor
{
    self = [super init];
    if (self)
    {
        self.noteLines = [[NSMutableArray alloc] init];
        self.type = instrumentType;
        self.isDefault = isSubscoreDefault;
        self.name = subscoreName;
        self.color = subscoreColor;
    }
    return self;
}

@end