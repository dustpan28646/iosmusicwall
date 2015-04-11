//
//  SubscoreSuper.h
//  UDPMatlab
//
//  Created by Matthew Rice on 4/7/15.
//  Copyright (c) 2015 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subscore.h"
#import "SubscoreLinked.h"

@interface SubscoreSuper : Subscore

@property (strong, nonatomic) SubscoreLinked *downLinkedSubscore;

@end
