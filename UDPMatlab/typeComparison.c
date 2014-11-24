//
//  typeComparison.c
//  HungarianMethodInC
//
//  Created by Matthew Rice on 3/28/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#include <stdio.h>
#include "typeComparison.h"


static const int shareMatrix[7][7] = {
    [0][0] = 1,
    [1][1] = 1,
    [2][2] = 1,
    [3][3] = 1,
    [4][4] = 1,
    [5][5] = 1,
    [6][6] = 1,
    [0][3] = 1, [3][0] = 1,
    [0][4] = 1, [4][0] = 1,
    [0][6] = 1, [6][0] = 1,
    [1][3] = 1, [3][1] = 1,
    [1][5] = 1, [5][1] = 1,
    [1][6] = 1, [6][1] = 1,
    [2][4] = 1, [4][2] = 1,
    [2][5] = 1, [5][2] = 1,
    [2][6] = 1, [6][2] = 1,
    [3][4] = 1, [4][3] = 1,
    [3][5] = 1, [5][3] = 1,
    [3][6] = 1, [6][3] = 1,
    [4][5] = 1, [5][4] = 1,
    [4][6] = 1, [6][4] = 1,
    [5][6] = 1, [6][5] = 1,};

int doShareInstrument(enum CombinationalType a, enum CombinationalType b)
{
    return shareMatrix[a][b];
}