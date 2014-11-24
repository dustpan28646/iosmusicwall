//
//  initialAssignment.h
//  HungarianMethodInC
//
//  Created by Matthew Rice on 3/28/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#ifndef HungarianMethodInC_initialAssignment_h
#define HungarianMethodInC_initialAssignment_h

#include "typeComparison.h"

int isFeasibleAssignment(int numTimeInstances, int numberOfRobotTypes, int numberOfPositionsForTime[numTimeInstances], enum CombinationalType *positionMatrix[numTimeInstances], enum CombinationalType rGroup[numberOfRobotTypes], int maxRobotsForType[numberOfRobotTypes], int assignmentMatrix[numTimeInstances][numberOfRobotTypes], int jMaxArray[numberOfRobotTypes], int *jMaxIndices[numberOfRobotTypes], int numberOfJMaxIndicesForRobotType[numberOfRobotTypes], int *totalRobotsUsed, int isTimeFeasible[numTimeInstances]);

#endif
