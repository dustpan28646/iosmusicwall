//
//  BooleanObject.h
//  UDPMatlab
//
//  Created by Matthew Rice on 1/27/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subscore.h"
#import "SubscoreSuper.h"
#import "SubscoreLinked.h"
#import "BareBooleanObject.h"


@interface BooleanObject : BareBooleanObject

@property (nonatomic, weak) Subscore *noteSubscore;

+ (UIColor *)colorForSubscore:(Subscore *)subscore;

- (id) initWithBool:(bool)noteExist withSubscore:(Subscore *)initSubscore;

@end
