//
//  Subscore.h
//  UDPMatlab
//
//  Created by Matthew Rice on 1/21/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubscoreNote.h"

enum SUBSCORE_INSTRUMENT
{
    SUBSCORE_DRUM,
    SUBSCORE_PIANO,
    SUBSCORE_GUITAR,
    SUBSCORE_NO_INSTRUMENT
};

@interface Subscore : NSObject

@property (nonatomic) enum SUBSCORE_INSTRUMENT type;
@property (strong, nonatomic) NSMutableArray *noteLines;
@property (nonatomic) bool isDefault;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic)  UIColor *color;

- (id)initWithInstrumentType:(enum SUBSCORE_INSTRUMENT)instrumentType withIsDefault:(bool)isSubscoreDefault wthName:(NSString *)subscoreName withColor:(UIColor *)subscoreColor;

@end
