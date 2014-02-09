//
//  BooleanObject.h
//  UDPMatlab
//
//  Created by Matthew Rice on 1/27/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subscore.h"

@interface BooleanObject : NSObject

@property (nonatomic) bool doesNoteExist;
@property (nonatomic, weak) Subscore *noteSubscore;


+ (UIColor *)colorForSubscore:(Subscore *)subscore;

- (id) initWithBool:(bool)noteExist withSubscore:(Subscore *)initSubscore;

@end
