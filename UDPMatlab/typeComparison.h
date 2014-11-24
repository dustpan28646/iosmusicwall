//
//  typeComparison.h
//  HungarianMethodInC
//
//  Created by Matthew Rice on 3/28/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#ifndef HungarianMethodInC_typeComparison_h
#define HungarianMethodInC_typeComparison_h


enum CombinationalType {TYPE_P = 0, TYPE_G = 1, TYPE_D = 2, TYPE_PG = 3, TYPE_PD = 4, TYPE_GD = 5, TYPE_PGD = 6};

enum ComparisonResult {A_LARGER, EQUIV, B_LARGER};

int doShareInstrument(enum CombinationalType a, enum CombinationalType b);


#endif
