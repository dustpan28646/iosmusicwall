//
//  SubscoreLinked.m
//  UDPMatlab
//
//  Created by Matthew Rice on 4/7/15.
//  Copyright (c) 2015 Matthew Rice. All rights reserved.
//

#import "SubscoreLinked.h"

@implementation SubscoreLinked

- (id)initWithInstrumentType:(enum SUBSCORE_INSTRUMENT)instrumentType withIsDefault:(bool)isSubscoreDefault wthName:(NSString *)subscoreName withColor:(UIColor *)subscoreColor withUpLinkedSubscore:(SubscoreSuper *)linkedSubscore
{
    self = [super initWithInstrumentType:instrumentType withIsDefault:isSubscoreDefault wthName:subscoreName withColor:subscoreColor];
    if (self)
    {
        self.upLinkedSubscore = linkedSubscore;
    }
    
    return self;
}

@end
