//
//  MasterViewController.m
//  UDPMatlab
//
//  Created by Matthew Rice on 9/23/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "MasterTableCell.h"

@interface MasterViewController ()
{
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize myTable;
@synthesize subscoreNames;

static float const coloredCircleDiameter = 28.0;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void) viewWillAppear:(BOOL)animated
{
    [myTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:0];
    [myTable setContentOffset:CGPointMake(0, -myTable.contentInset.top) animated:YES];
    myTable.separatorColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //UIBarButtonItem*addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    colorArray = [[NSArray alloc] initWithObjects:[UIColor blueColor], [UIColor brownColor], [UIColor greenColor], [UIColor cyanColor], [UIColor purpleColor], [UIColor orangeColor], [UIColor magentaColor], nil];
    [self createUIImageArray];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self.detailViewController setMasterView:self];
    numberOfTimesInScore = 4;
    subscoreDictionary = [[NSMutableDictionary alloc] init];
    currentSubscoreName = @"";
    subscoreNames = [[NSMutableArray alloc] initWithCapacity:6];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ScoreXML" ofType:@"csv"];
    CHCSVParser *parser = [[CHCSVParser alloc] initWithContentsOfCSVFile:filePath];
    parser.delegate = self;
    [parser parse];
    indexFactor = 1.0;
}

- (void) createUIImageArray
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:[colorArray count]];
    for (UIColor *circleColor in colorArray)
    {
        CGSize size = CGSizeMake(coloredCircleDiameter, coloredCircleDiameter);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        [[UIColor clearColor] setFill];
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect circleRect = CGRectMake(0, 0,
                                       size.width,
                                       size.height);
        CGContextFillRect(ctx, circleRect);
        circleRect = CGRectInset(circleRect, 5, 5);
        [circleColor setFill];
        CGContextFillEllipseInRect(ctx, circleRect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [mutableArray addObject:image];
    }
    circleImageArray = [NSArray arrayWithArray:mutableArray];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewScrollPosition scrollPos = UITableViewScrollPositionNone;

    [myTable selectRowAtIndexPath:path animated:YES scrollPosition:scrollPos];
    
    [self.detailViewController initializeScoreWithSubscores:subscoreDictionary withNumberOfTimeIndices:numberOfTimesInScore];
    [self.tableView reloadData];
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(initialSelection:) userInfo:nil repeats:NO];
}
     
- (void)initialSelection:(id)sender
{
    [myTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
            if (([field intValue]) > numberOfTimesInScore)
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
                    if (currentSubscoreName != nil && ![currentSubscoreName isEqualToString:@""])
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
                    else if (([field rangeOfString:@"drum" options:NSCaseInsensitiveSearch].location != NSNotFound) || ([field rangeOfString:@"cymbal" options:NSCaseInsensitiveSearch].location != NSNotFound))
                    {
                        instrumentType = SUBSCORE_DRUM;
                    }
                    else
                    {
                        instrumentType = SUBSCORE_PIANO;
                    }
                    
                    bool isSubscoreDefault = false;
                    //bool isSubscoreDefault = [field isEqualToString:@"Piano/Guitar Lead"] || [field isEqualToString:@"Guitar Chords"] || [field isEqualToString:@"Piano Bass"];
                    
                    SubscoreSuper *defaultSubscore = [self findDefaultSubscoreForSubscoreName:field];
                    
                    if (defaultSubscore != nil)
                    {
                        SubscoreLinked *linkedSubscore = [[SubscoreLinked alloc] initWithInstrumentType:instrumentType withIsDefault:isSubscoreDefault wthName:field withColor:defaultSubscore.color withUpLinkedSubscore:defaultSubscore];
                        defaultSubscore.downLinkedSubscore = linkedSubscore;
                    }
        
                    Subscore *subscore = [[Subscore alloc] initWithInstrumentType:instrumentType withIsDefault:isSubscoreDefault wthName:field withColor:[colorArray objectAtIndex:[subscoreDictionary count]]];
                    [subscoreNames addObject:field];
                    currentSubscoreLine = [[NSMutableArray alloc] initWithCapacity:numberOfTimesInScore];
                    [subscore.noteLines addObject:currentSubscoreLine];
                    
                    [subscoreDictionary setObject:subscore forKey:field];
                }
            }
            else if ((currentSubscoreName != nil) && ![currentSubscoreName isEqualToString:@""])
            {
                [currentSubscoreLine addObject:[[SubscoreNote alloc] initWithNoteString:field withSubscoreName:currentSubscoreName]];
            }
        }
    }
    else if (currentSubscoreLine != nil)
    {
        [currentSubscoreLine addObject:[[SubscoreNote alloc] initWithNoteString:@"" withSubscoreName:currentSubscoreName]];
    }
}

- (void) parserDidEndDocument:(CHCSVParser *)parser
{
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
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"t = %0.1f", (((double)(indexPath.row + 1)) * indexFactor)];
    */
    static NSString *cellIdentifier = @"MasterTableCell";
    //3
    MasterTableCell *cell = (MasterTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //3.1 you do not need this if you have set TableCellID as identifier in the storyboard (else you can remove the comments on this code). Do not use this code if you are following this tutorial
    
    if (cell == nil)
       {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MasterTableCell" owner:self options:nil]objectAtIndex:0];//initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
       }
    
    NSArray *circles = [[NSArray alloc] initWithObjects:cell.circle1, cell.circle2, cell.circle3, cell.circle4, cell.circle5, cell.circle6, cell.circle7, nil];
    
    NSArray *noteExistanceArray = [self.detailViewController getNoteExistanceArrayForTime:(int)indexPath.row];
    
    for (int i = 0; i < [circleImageArray count]; i++)
    {
        UIImageView *imageView = [circles objectAtIndex:i];
        imageView.image = [circleImageArray objectAtIndex:i];
        imageView.hidden = !((NoteExistanceStructure *)[noteExistanceArray objectAtIndex:i]).doNotesExist;
    }
    
    if (self.detailViewController && [self.detailViewController doesScoreExist])
    {
        if([[[self.detailViewController getFeasibilityArray] objectAtIndex:indexPath.row] boolValue])
        {
            if ([self.detailViewController isTimeIndexDisabled:(int)indexPath.row])
            {
                cell.backgroundColor = [UIColor lightGrayColor];
            }
            else
            {
                cell.backgroundColor = [UIColor blackColor];
            }
        }
        else
        {
            cell.backgroundColor = [UIColor redColor];
            NSLog(@"Red Row at %i\n", (int)indexPath.row);
        }
        
        if (currentSelection != nil)
        {
            [tableView selectRowAtIndexPath:currentSelection animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    cell.timeText.text = [NSString stringWithFormat:@"t = %0.1f", (((double)(indexPath.row)) * indexFactor)];
    cell.timeText.textColor = [UIColor lightGrayColor];
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor yellowColor];
    cell.selectedBackgroundView = selectionColor;
    //3.2
    if ((currentSelection != nil) && (indexPath.row != currentSelection.row))
    {
        [cell setHighlighted:NO];
    }
    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.detailViewController && [self.detailViewController doesScoreExist])
//    {
//        NSArray *feasArray = [self.detailViewController getFeasibilityArray];
//        if (([feasArray count] < numberOfTimesInScore) || [[feasArray objectAtIndex:indexPath.row] boolValue])
//        {
//            cell.backgroundColor = [UIColor clearColor];
//            NSLog(@"print clear");
//        }
//        else
//        {
//            cell.backgroundColor = [UIColor redColor];
//            NSLog(@"print red");
//        }
//    }
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
    currentSelection = indexPath;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
    
    [self.detailViewController setTimeIndexWithoutUpdate:(int)indexPath.row];
    
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
    [myTable selectRowAtIndexPath:currentSelection animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void) refreshNoteExistance
{
    //optimize by only refreshing certain rows
    //can also add animation to row update
    [self.tableView reloadData];
    [myTable selectRowAtIndexPath:currentSelection animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == currentSelection.row)
    {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != currentSelection.row)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setHighlighted:NO];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    NSLog(@"Highlighted Cell %i",(int)indexPath.row);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row != currentSelection.row))
    {
        [cell setHighlighted:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((currentSelection == nil) && [myTable indexPathForSelectedRow])
    {
        currentSelection = [myTable indexPathForSelectedRow];
    }
    [myTable reloadData];
    if (currentSelection)
    {
        [myTable selectRowAtIndexPath:currentSelection animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    
    //NSLog(@"Did Scroll");
}

- (SubscoreSuper *) findDefaultSubscoreForSubscoreName:(NSString *)name
{
    for (NSString *key in subscoreDictionary)
    {
        if ([self areMatchingGPSubscoresWithFirstName:key withSecondName:name])
        {
            return [subscoreDictionary objectForKey:key];
        }
    }
    return nil;
}


- (bool)areMatchingGPSubscoresWithFirstName:(NSString *)fName withSecondName:(NSString *)sName
{
    NSRange fGuitarRangeValue = [fName rangeOfString:@"guitar" options:NSCaseInsensitiveSearch];
    NSRange fPianoRangeValue = [fName rangeOfString:@"piano" options:NSCaseInsensitiveSearch];
    NSRange sRange;
    NSRange fRange;
    
    if (fGuitarRangeValue.location != NSNotFound)
    {
        sRange = [fName rangeOfString:@"piano" options:NSCaseInsensitiveSearch];
        if (sRange.location == NSNotFound)
        {
            return NO;
        }
        fRange = fGuitarRangeValue;
    }
    else if (fPianoRangeValue.location != NSNotFound)
    {
        sRange = [fName rangeOfString:@"guitar" options:NSCaseInsensitiveSearch];
        if (sRange.location == NSNotFound)
        {
            return NO;
        }
        fRange = fPianoRangeValue;
    }
    else
    {
        return NO;
    }
    
    NSString *reducedFString = [fName stringByReplacingCharactersInRange:fRange withString:@""];
    NSString *reducedSString = [sName stringByReplacingCharactersInRange:sRange withString:@""];
    
    if ([reducedFString caseInsensitiveCompare:reducedSString] == NSOrderedSame)
    {
        return YES;
    }
    
    return NO;
}

@end
