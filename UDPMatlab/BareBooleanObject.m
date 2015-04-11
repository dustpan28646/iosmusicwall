//
//  BareBooleanObject.m
//  UDPMatlab
//
//  Created by Matthew Rice on 4/6/15.
//  Copyright (c) 2015 Matthew Rice. All rights reserved.
//

#import "BareBooleanObject.h"

@implementation BareBooleanObject

-(id) initWithBool:(bool)booleanValue
{
    self = [super init];
    if (self)
    {
        self.value = booleanValue;
    }
    return self;
}

@end
