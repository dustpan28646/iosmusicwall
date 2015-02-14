//
//  BooleanObject.m
//  UDPMatlab
//
//  Created by Matthew Rice on 1/27/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import "BooleanObject.h"

@implementation BooleanObject

-(id) initWithBool:(bool)noteExist withSubscore:(Subscore *)initSubscore
{
    self = [super init];
    if (self)
    {
        self.doesNoteExist = noteExist;
        self.noteSubscore = initSubscore;
    }
    return self;
}

+ (UIColor *)colorForSubscore:(Subscore *)subscore
{
    if (subscore != nil)
    {
        return subscore.color;
    }
    return [UIColor magentaColor];
}

@end
