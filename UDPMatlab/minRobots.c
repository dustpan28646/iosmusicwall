//
//  minRobots.c
//  HungarianMethodInC
//
//  Created by Matthew Rice on 3/29/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "minRobots.h"
#include "hungarian.h"

int minInt2(int a, int b)
{
    return (a<b)?a:b;
}

int minRobotsAssignment(int numberOfRobotTypes, enum CombinationalType *positions, enum CombinationalType rGroup[numberOfRobotTypes], int numRobotsForType[numberOfRobotTypes], int numberOfPositions, int jStarRGroupIndex, int numRobotsUsedForType[numberOfRobotTypes])
{
    if (numberOfPositions == 0)
    {
        for (int r = 0; r < numberOfRobotTypes; r++)
        {
            numRobotsUsedForType[r] = 0;
        }
    }
    //int initAssignment(int numberOfRobotTypes, enum CombinationalType *positions, enum CombinationalType rGroup[numberOfRobotTypes], int numRobotsForType[numberOfRobotTypes], int numberOfPositions, int numRobotsUsedForType[numberOfRobotTypes])
    int maxUsedRobotsForType[numberOfRobotTypes];
    int totalMatrixRows = 0;
    for (int i = 0; i<numberOfRobotTypes; i++)
    {
        int minimum = minInt2(numRobotsForType[i],numberOfPositions);
        maxUsedRobotsForType[i] = minimum;
        totalMatrixRows += minimum;
    }
    int feasibilityMatrix[totalMatrixRows][numberOfPositions];
    int currentRobotTypeIndex = 0;
    
    if (numberOfPositions > totalMatrixRows)
    {
        return 0;
    }
    
    for (int i = 0; i < totalMatrixRows; currentRobotTypeIndex++)
    {
        for (int j = 0; j < numberOfPositions; j++)
        {
            if (doShareInstrument(rGroup[currentRobotTypeIndex],positions[j]))
            {
                if (currentRobotTypeIndex == jStarRGroupIndex)
                {
                    feasibilityMatrix[i][j] = 0;
                }
                else
                {
                    feasibilityMatrix[i][j] = -1;
                }
            }
            else
            {
                feasibilityMatrix[i][j] = 1000;
            }
        }
        
        for (int j = 1; j < maxUsedRobotsForType[currentRobotTypeIndex]; j++)
        {
            memcpy(feasibilityMatrix[i+j],feasibilityMatrix[i], sizeof(feasibilityMatrix[i]));
        }
        i += maxUsedRobotsForType[currentRobotTypeIndex];
    }
    int cost = 0;
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
        //printf("NEW %i : %i\n", robotTypeIndex, numRobotsUsedForType[robotTypeIndex]);
        i += maxUsedRobotsForType[robotTypeIndex];
    }
    return 1;
}



int findMinRobotDistrib(int numTimeInstances, int numberOfRobotTypes, int numberOfPositionsForTime[numTimeInstances], enum CombinationalType *positionMatrix[numTimeInstances], enum CombinationalType rGroup[numberOfRobotTypes], int maxRobotsForType[numberOfRobotTypes], int assignmentMatrix[numTimeInstances][numberOfRobotTypes], int jMaxArray[numberOfRobotTypes], int *jMaxIndices[numberOfRobotTypes], int numberOfJMaxIndicesForRobotType[numberOfRobotTypes], int *totalRobotsUsed)
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
    
    int i = 0;
    *totalRobotsUsed = 0;
    for (int i = 0; i <numberOfRobotTypes; i++)
    {
        //jMaxIndices[i] = (int *)realloc(jMaxIndices[i], numTimeInstances * sizeof(int));
        *totalRobotsUsed += jMaxArray[i];
    }
    
    int pastTotalRobotsUsed = *totalRobotsUsed + 1;
    while (*totalRobotsUsed < pastTotalRobotsUsed)
    {
        printf("total Rob Used: %i\n", *totalRobotsUsed);
        //for loop over each robot type
        for (int k = 0; k < numberOfRobotTypes; k++)
        {
            //looping over each max index of the particular type to reduce cost
            for (int l = 0; l<numberOfJMaxIndicesForRobotType[k]; l++)
            {
                i = jMaxIndices[k][l];
                //doing assignment
                if (!minRobotsAssignment(numberOfRobotTypes,positionMatrix[i], rGroup, jMaxArray, numberOfPositionsForTime[i], k, assignmentMatrix[i]))
                {
                    return 0;
                }
            }
                //checking new maxes for each robot type
            for (int j = 0; j<numberOfRobotTypes; j++)
            {
                jMaxArray[j] = 0;
                numberOfJMaxIndicesForRobotType[j] = 0;
                for (int m = 0; m < numTimeInstances; m++)
                {
                    if (jMaxArray[j] == assignmentMatrix[m][j])
                    {
                        jMaxIndices[j][numberOfJMaxIndicesForRobotType[j]] = m;
                        numberOfJMaxIndicesForRobotType[j]++;
                    }
                    else if (jMaxArray[j] < assignmentMatrix[m][j])
                    {
                        jMaxIndices[j][0] = m;
                        numberOfJMaxIndicesForRobotType[j] = 1;
                        jMaxArray[j] = assignmentMatrix[m][j];
                        //printf("%i\n",assignmentMatrix[m][j]);
                    }
                }
            }
        }
        pastTotalRobotsUsed = *totalRobotsUsed;
        *totalRobotsUsed = 0;
        //can comment out the realloc below for speed.... it just saves memory and gives us a nonzero "total number of robots used"
        for (int i = 0; i <numberOfRobotTypes; i++)
        {
            //jMaxIndices[i] = (int *)realloc(jMaxIndices[i], numberOfJMaxIndicesForRobotType[i] * sizeof(int));
            *totalRobotsUsed += jMaxArray[i];
        }
    }
    
    return 1;
}

