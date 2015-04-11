//
//  BareBooleanObject.h
//  UDPMatlab
//
//  Created by Matthew Rice on 4/6/15.
//  Copyright (c) 2015 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BareBooleanObject : NSObject

@property (nonatomic) bool value;

-(id) initWithBool:(bool)booleanValue;

@end
