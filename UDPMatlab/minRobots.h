//
//  minRobots.h
//  HungarianMethodInC
//
//  Created by Matthew Rice on 3/29/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#ifndef HungarianMethodInC_minRobots_h
#define HungarianMethodInC_minRobots_h

#include "typeComparison.h"

int findMinRobotDistrib(int numTimeInstances, int numberOfRobotTypes, int numberOfPositionsForTime[numTimeInstances], enum CombinationalType *positionMatrix[numTimeInstances], enum CombinationalType rGroup[numberOfRobotTypes], int maxRobotsForType[numberOfRobotTypes], int assignmentMatrix[numTimeInstances][numberOfRobotTypes], int jMaxArray[numberOfRobotTypes], int *jMaxIndices[numberOfRobotTypes], int numberOfJMaxIndicesForRobotType[numberOfRobotTypes], int *totalRobotsUsed);

#endif
