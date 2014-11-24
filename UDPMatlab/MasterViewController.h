//
//  MasterViewController.h
//  UDPMatlab
//
//  Created by Matthew Rice on 9/23/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "CHCSVParser.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <CHCSVParserDelegate>
{
    int numberOfTimesInScore;
    double indexFactor;
    NSMutableArray *score;
    int currentLine;
    NSMutableDictionary *subscoreDictionary;
    NSMutableArray *currentSubscoreLine;
    NSString *currentSubscoreName;
    NSArray *colorArray;
    NSArray *circleImageArray;
    NSIndexPath *currentSelection;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (strong, nonatomic) NSMutableArray *subscoreNames;

- (void) setTempoFactor:(double)newFactor;
- (void) refreshNoteExistance;

@end
