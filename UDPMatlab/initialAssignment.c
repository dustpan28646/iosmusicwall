//
//  initialAssignment.c
//  HungarianMethodInC
//
//  Created by Matthew Rice on 3/28/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "initialAssignment.h"
#include "hungarian.h"

int minInt(int a, int b)
{
    return (a<b)?a:b;
}

int maxInt(int a, int b)
{
    return (a<b)?b:a;
}

int initAssignment(int numberOfRobotTypes, enum CombinationalType *positions, enum CombinationalType rGroup[numberOfRobotTypes], int numRobotsForType[numberOfRobotTypes], int numberOfPositions, int numRobotsUsedForType[numberOfRobotTypes])
{
    if (numberOfPositions == 0)
    {
        for (int r = 0; r < numberOfRobotTypes; r++)
        {
            numRobotsUsedForType[r] = 0;
        }
        return 1;
    }
    
    int maxUsedRobotsForType[numberOfRobotTypes];
    int totalMatrixRows = 0;
    for (int i = 0; i<numberOfRobotTypes; i++)
    {
        int minimum = minInt(numRobotsForType[i],numberOfPositions);
        maxUsedRobotsForType[i] = minimum;
        totalMatrixRows += minimum;
    }
    
    if (totalMatrixRows < numberOfPositions)
    {
        return 0;
    }
    
    int feasibilityMatrix[totalMatrixRows][numberOfPositions];
    int currentRobotTypeIndex = 0;
    
    for (int i = 0; i < totalMatrixRows; currentRobotTypeIndex++)
    {
        for (int j = 0; j < numberOfPositions; j++)
        {
            feasibilityMatrix[i][j] = 1000 * (!doShareInstrument(rGroup[currentRobotTypeIndex],positions[j]));
        }
        
        for (int j = 1; j < maxUsedRobotsForType[currentRobotTypeIndex]; j++)
        {
            memcpy(feasibilityMatrix[i+j],feasibilityMatrix[i], sizeof(feasibilityMatrix[i]));
            
        }
        i += maxUsedRobotsForType[currentRobotTypeIndex];
    }
    int cost = 1;
    int indicesVector[totalMatrixRows];
    callHungarian(&cost, totalMatrixRows, numberOfPositions, feasibilityMatrix, indicesVector);
    
    if (cost > 0)
    {
        return 0;
    }
    
    //now we know we have a feasible assignment
    //assigning the two "output" inputs
    int robotTypeIndex = 0;
    for (int i = 0; i < totalMatrixRows; robotTypeIndex++)
    {
        numRobotsUsedForType[robotTypeIndex] = 0;
        for (int j = 0; j < maxUsedRobotsForType[robotTypeIndex]; j++)
        {
            if(indicesVector[i+j] < numberOfPositions)
            {
                numRobotsUsedForType[robotTypeIndex]++;
            }
        }
        i += maxUsedRobotsForType[robotTypeIndex];
    }
    return 1;
}

int isFeasibleAssignment(int numTimeInstances, int numberOfRobotTypes, int numberOfPositionsForTime[numTimeInstances], enum CombinationalType *positionMatrix[numTimeInstances], enum CombinationalType rGroup[numberOfRobotTypes], int maxRobotsForType[numberOfRobotTypes], int assignmentMatrix[numTimeInstances][numberOfRobotTypes], int jMaxArray[numberOfRobotTypes], int *jMaxIndices[numberOfRobotTypes], int numberOfJMaxIndicesForRobotType[numberOfRobotTypes], int *totalRobotsUsed, int *isTimeFeasible)
{
    //Input/Output explanation
    //Output - 1 for fesible and 0 for unfeasible
    //
    //Two types of inputs: Used and Assigned
    //
    //Used:
    //
    //numTimeInstances = number of times over which feasibility is checked.  Used for array size parameters.
    //numberOfPositionsForTime = gives the number of positions at each time.  Mainly used for the size of the second dimension of the positionMatrix parameter (unspecified)
    //positionMatrix = first dimension are times.  Second dimension are all of the positions (enums) at that time (variable length dimension).
    //rGroup = enum'd robot types at each type index (used for knowing what robot type each number in other vectors with the same length apply to)
    //maxRobotsForType = how many robots do we have access to for each type?
    //
    //Assigned Outputs:
    //
    //assignmentMatrix = two dimensions: time and robot type.  For each time and type, the integer represents how many of those robots are assigned.
    //jMaxArray = (provided for convenience/speed) maximum over the time dimension of the assignment matrix.  (provided to use in later "optimization" calls.
    //jmaxIndices = two dimensions (number of robot types and indices).  the second dim is variable.  It represents the indices at which the jmax over time is acheived.
    //numberOfJMaxIndicesForRobotType = specifies the length of the index dimension in jMaxIndices
    int overallFeasibility = 1;
    for (int i = 0; i<numberOfRobotTypes; i++)
    {
        jMaxArray[i] = 0;
        jMaxIndices[i] = (int *)calloc(sizeof(int),numTimeInstances);
        numberOfJMaxIndicesForRobotType[i] = 0;
    }
    
    for (int i = 0; i < numTimeInstances; i++)
    {
        for (int j = 0; j < numberOfRobotTypes; j++)
        {
            assignmentMatrix[i][j] = 0;
        }
    }
    
    for (int i = 0; i<numTimeInstances; i++)
    {
        if(!(isTimeFeasible[i] = initAssignment(numberOfRobotTypes, positionMatrix[i], rGroup, maxRobotsForType, numberOfPositionsForTime[i], assignmentMatrix[i])))
        {
            if (i == 12)
            {
                printf("12 not feasible\n");
            }
            overallFeasibility = 0;
        }
        
        for (int j = 0; j < numberOfRobotTypes; j++)
        {
            if (assignmentMatrix[i][j] == jMaxArray[j])
            {
                jMaxIndices[j][numberOfJMaxIndicesForRobotType[j]] = i;
                numberOfJMaxIndicesForRobotType[j]++;
            }
            else if (assignmentMatrix[i][j] > jMaxArray[j])
            {
                numberOfJMaxIndicesForRobotType[j] = 1;
                jMaxIndices[j][0] = i;
                jMaxArray[j] = assignmentMatrix[i][j];
            }
            //printf("JMAX %i: %i\n",j, jMaxArray[j]);
        }
    }
    
    *totalRobotsUsed = 0;
    //can comment out the for loop below for speed.... it just saves memory and gives us a nonzero "total number of robots used"
    for (int i = 0; i <numberOfRobotTypes; i++)
    {
        //jMaxIndices[i] = (int *)realloc(jMaxIndices[i], numberOfJMaxIndicesForRobotType[i] * sizeof(int));
        *totalRobotsUsed += jMaxArray[i];
    }
    return overallFeasibility;
}