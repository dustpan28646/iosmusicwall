//
//  BooleanObject.m
//  UDPMatlab
//
//  Created by Matthew Rice on 1/27/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import "BooleanObject.h"

@implementation BooleanObject

-(id) initWithBool:(bool)noteExist
{
    self = [super init];
    if (self)
    {
        self.doesNoteExist = noteExist;
    }
    return self;
}

@end
