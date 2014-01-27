//
//  BooleanObject.h
//  UDPMatlab
//
//  Created by Matthew Rice on 1/27/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BooleanObject : NSObject

@property (nonatomic) bool doesNoteExist;

- (id) initWithBool:(bool)noteExist;

@end
