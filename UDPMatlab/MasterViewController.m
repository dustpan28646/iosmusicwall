//
//  MasterViewController.m
//  UDPMatlab
//
//  Created by Matthew Rice on 9/23/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController ()
{
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize myTable;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem*addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self.detailViewController setMasterView:self];
    numberOfTimesInScore = 4;
    subscoreDictionary = [[NSMutableDictionary alloc] init];
    currentSubscoreName = @"";
    score = [self createScore];
    indexFactor = 1.0;
    [self.detailViewController newTimeIndex:0 withScore:[score objectAtIndex:0]];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewScrollPosition scrollPos = UITableViewScrollPositionNone;

    [myTable selectRowAtIndexPath:path animated:YES scrollPosition:scrollPos];
}

- (void) parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    currentLine = [[NSNumber numberWithUnsignedInteger:recordNumber] intValue];
    //NSLog(@"Began Line: %i",recordNumber);
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    //currentSubscoreName = @"";
    //NSLog(@"Ended Line: %i",recordNumber);
}

- (void) parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    // lowest note in scale in Octave 0 is G0 and top note is F#0
    if ((field != nil) && ![field isEqualToString:@""])
    {
        if (currentLine == 1)
        {
            if ([field intValue] > numberOfTimesInScore)
            {
                numberOfTimesInScore = [field intValue];
            }
        }
        else
        {
            if (fieldIndex == 0)
            {
                if ([field isEqualToString:@"line"])
                {
                    if (currentSubscoreName != nil)
                    {
                        Subscore *subscore = [subscoreDictionary objectForKey:currentSubscoreName];
                        currentSubscoreLine = [[NSMutableArray alloc] initWithCapacity:numberOfTimesInScore];
                        [subscore.noteLines addObject:currentSubscoreLine];
                    }
                }
                else
                {
                    currentSubscoreName = field;
                    enum SUBSCORE_INSTRUMENT instrumentType = SUBSCORE_NO_INSTRUMENT;
                    
                    if ([field rangeOfString:@"piano" options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        instrumentType = SUBSCORE_PIANO;
                    }
                    else if ([field rangeOfString:@"guitar" options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        instrumentType = SUBSCORE_GUITAR;
                    }
                    else if ([field rangeOfString:@"bass drum" options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        instrumentType = SUBSCORE_BASS_DRUM;
                    }
                    else if ([field rangeOfString:@"snare drum" options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        instrumentType = SUBSCORE_SNARE;
                    }
                    else if ([field rangeOfString:@"cymbal" options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        instrumentType = SUBSCORE_CYMBAL;
                    }
                    else if ([field rangeOfString:@"drum" options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        instrumentType = SUBSCORE_BASS_DRUM;
                    }
                    else
                    {
                        instrumentType = SUBSCORE_PIANO;
                    }
                    
                    Subscore *subscore = [[Subscore alloc] initWithInstrumentType:instrumentType];
                    currentSubscoreLine = [[NSMutableArray alloc] initWithCapacity:numberOfTimesInScore];
                    [subscore.noteLines addObject:currentSubscoreLine];
                    
                    [subscoreDictionary setObject:subscore forKey:field];
                }
            }
            else if ((currentSubscoreName != nil) && ![currentSubscoreName isEqualToString:@""])
            {
                [currentSubscoreLine addObject:field];
            }
        }
    }
    else if (currentSubscoreLine != nil)
    {
        [currentSubscoreLine addObject:@""];
    }
}


-(NSMutableArray *)createScore
{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ScoreXML" ofType:@"csv"];
    CHCSVParser *parser = [[CHCSVParser alloc] initWithContentsOfCSVFile:filePath];
    parser.delegate = self;
    [parser parse];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0; i < 4;i++)
    {
        NSMutableArray *gridArray = [[NSMutableArray alloc] initWithCapacity:14];
        
        for (int i2 = 0; i2 < 14; i2++)
        {
            NSMutableArray *grid = [[NSMutableArray alloc] initWithCapacity:6];
            for (int i3 = 0; i3 < 6; i3++)
            {
                if (((i + i2 + i3) % 5) == 0)
                {
                    [grid addObject:[NSNumber numberWithBool:YES]];//[grid addObject:[NSNumber numberWithBool:YES]];
                }
                else
                {
                    [grid addObject:[NSNumber numberWithBool:NO]];
                }
            }
            [gridArray addObject:grid];
        }
        NSMutableArray *drumArray = [[NSMutableArray alloc] initWithCapacity:5];
        
        for (int i4 = 0; i4 < 5; i4++)
        {
            if (((i4 + i) % 3) == 0)
            {
                [drumArray addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithBool:YES]]];//[drumArray addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithBool:YES]]];
            }
            else
            {
                [drumArray addObject:[NSMutableArray arrayWithObject:[NSNumber numberWithBool:NO]]];
            }
        }
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:gridArray,@"grid",drumArray,@"drum", nil];
        [returnArray addObject:dict];
    }
    [[self tableView] reloadData];
    return returnArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numberOfTimesInScore;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"t = %0.1f", (((double)(indexPath.row + 1)) * indexFactor)];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
    if ([score count] > indexPath.row)
    {
        [self.detailViewController newTimeIndex:indexPath.row withScore:[score objectAtIndex:indexPath.row]];
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }*/
}

- (void) setTempoFactor:(double)newFactor
{
    indexFactor = newFactor;
    [myTable reloadData];
}

@end
