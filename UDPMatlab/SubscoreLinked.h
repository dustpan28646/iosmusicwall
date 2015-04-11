//
//  SubscoreLinked.h
//  UDPMatlab
//
//  Created by Matthew Rice on 4/7/15.
//  Copyright (c) 2015 Matthew Rice. All rights reserved.
//

#import "Subscore.h"
#import "SubscoreSuper.h"

@interface SubscoreLinked : Subscore

- (id)initWithInstrumentType:(enum SUBSCORE_INSTRUMENT)instrumentType withIsDefault:(bool)isSubscoreDefault wthName:(NSString *)subscoreName withColor:(UIColor *)subscoreColor withUpLinkedSubscore:(SubscoreSuper *)linkedSubscore;

@property (weak, nonatomic) SubscoreSuper *upLinkedSubscore;

@end
