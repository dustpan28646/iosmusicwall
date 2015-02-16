//
//  DetailViewController.m
//  UDPMatlab
//
//  Created by Matthew Rice on 9/23/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import "DetailViewController.h"
#define DYNAMIC_OFFSET 10

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize imageView;
@synthesize tempoControl;
@synthesize tempoText;
@synthesize Grid1;
@synthesize Grid2;
@synthesize Grid3;
@synthesize Grid4;
@synthesize Grid5;
@synthesize Grid6;
@synthesize Grid7;
@synthesize Grid8;
@synthesize Grid9;
@synthesize Grid10;
@synthesize Grid11;
@synthesize Grid12;
@synthesize Grid13;
@synthesize Grid14;
@synthesize Drum1;
@synthesize Drum2;
@synthesize Drum3;
@synthesize Drum4;
@synthesize Drum5;
@synthesize ScoreView;
@synthesize gridImageView;
@synthesize buttonOne;
@synthesize buttonTwo;
@synthesize buttonThree;
@synthesize buttonFour;
@synthesize buttonFive;
@synthesize buttonSix;
@synthesize currentScoreIndex;
@synthesize PSlider;
@synthesize GSlider;
@synthesize DSlider;
@synthesize PGSlider;
@synthesize GDSlider;
@synthesize PDSlider;
@synthesize PGDSlider;
@synthesize PAvailableText;
@synthesize GAvailableText;
@synthesize DAvailableText;
@synthesize PGAvailableText;
@synthesize GDAvailableText;
@synthesize PDAvailableText;
@synthesize PGDAvailableText;
@synthesize PInUseText;
@synthesize GInUseText;
@synthesize DInUseText;
@synthesize PGInUseText;
@synthesize GDInUseText;
@synthesize PDInUseText;
@synthesize PGDInUseText;
@synthesize PTypeText;
@synthesize GTypeText;
@synthesize DTypeText;
@synthesize PGTypeText;
@synthesize GDTypeText;
@synthesize PDTypeText;
@synthesize PGDTypeText;
@synthesize topBar;
@synthesize startButton;


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem)
    {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    lastControlValue = 0;
    currentScoreIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self drawDrumWithCenter:CGPointMake(50, 50) withRadius:20];
    [gridImageView setAlpha:0.0];
    //PAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PSlider.value)];
    //GAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(GSlider.value)];
    //DAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(DSlider.value)];
    //PGAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PGSlider.value)];
    //GDAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(GDSlider.value)];
    //PDAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PDSlider.value)];
    //PGDAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PGDSlider.value)];
    
    [self PSliderValueChanged:self];
    [self GSliderValueChanged:self];
    [self DSliderValueChanged:self];
    [self PGSliderValueChanged:self];
    [self GDSliderValueChanged:self];
    [self PDSliderValueChanged:self];
    [self PGDSliderValueChanged:self];
    isGloballyFeasible = false;
    isCurrentlyPlaying = false;
    scoreMask = nil;
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    tempoControl.minimumValue = 0.5;
    tempoControl.maximumValue = 1.5;
    tempoControl.stepValue = 0.1;
    tempoControl.value = 1.0;
    [score changeTimeIndexTo:currentScoreIndex];
    [self updateButtonColors];
    [self updateNoteExistanceFromCurrentTimeToEnd];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateButtonColors) userInfo:nil repeats:NO];
    self.currentMatlabTime = 0;
}

- (IBAction)PSliderValueChanged:(id)sender
{
    [self changedSliderValue:PSlider withAvailableText:PAvailableText withInUseText:PInUseText withTypeText:PTypeText];
}

- (IBAction)GSliderValueChanged:(id)sender
{
    [self changedSliderValue:GSlider withAvailableText:GAvailableText withInUseText:GInUseText withTypeText:GTypeText];
}

- (IBAction)DSliderValueChanged:(id)sender
{
    [self changedSliderValue:DSlider withAvailableText:DAvailableText withInUseText:DInUseText withTypeText:DTypeText];
}

- (IBAction)PGSliderValueChanged:(id)sender
{
    [self changedSliderValue:PGSlider withAvailableText:PGAvailableText withInUseText:PGInUseText withTypeText:PGTypeText];
}

- (IBAction)GDSliderValueChanged:(id)sender
{
    [self changedSliderValue:GDSlider withAvailableText:GDAvailableText withInUseText:GDInUseText withTypeText:GDTypeText];
}

- (IBAction)PDSliderValueChanged:(id)sender
{
    [self changedSliderValue:PDSlider withAvailableText:PDAvailableText withInUseText:PDInUseText withTypeText:PDTypeText];
}

- (IBAction)PGDSliderValueChanged:(id)sender
{
    [self changedSliderValue:PGDSlider withAvailableText:PGDAvailableText withInUseText:PGDInUseText withTypeText:PGDTypeText];
}

-(void)changedSliderValue:(UISlider *)slider withAvailableText:(UILabel *)availableText withInUseText:(UILabel *)inUseText withTypeText:(UILabel *)typeText
{
    int oldVal = [availableText.text intValue];
    int newVal = (int)round(slider.value);
    slider.value = newVal;
    if (oldVal != newVal)
    {
        availableText.text = [NSString stringWithFormat:@"%i", (int)round(slider.value)];
        if (slider.value > 0)
        {
            [inUseText setTextColor:[UIColor yellowColor]];
            [typeText setTextColor:[UIColor yellowColor]];
            [availableText setTextColor:[UIColor yellowColor]];
        }
        else
        {
            [inUseText setTextColor:[UIColor whiteColor]];
            [typeText setTextColor:[UIColor whiteColor]];
            [availableText setTextColor:[UIColor whiteColor]];
        }
        if (score != nil)
        {
            [self updateFeasibilityAndRobotDistribution];
        }
    }
}

- (IBAction)touchedButtonOne:(id)sender
{
    [self buttonAddOrRemoveSubscoreWithName:[buttonOne titleLabel].text];
}

- (IBAction)touchedButtonTwo:(id)sender
{
    [self buttonAddOrRemoveSubscoreWithName:[buttonTwo titleLabel].text];
}

- (IBAction)touchedButtonThree:(id)sender
{
    [self buttonAddOrRemoveSubscoreWithName:[buttonThree titleLabel].text];
}

- (IBAction)touchedButtonFour:(id)sender
{
    [self buttonAddOrRemoveSubscoreWithName:[buttonFour titleLabel].text];
}

- (IBAction)touchedButtonFive:(id)sender
{
    [self buttonAddOrRemoveSubscoreWithName:[buttonFive titleLabel].text];
}

- (IBAction)touchedButtonSix:(id)sender
{
    [self buttonAddOrRemoveSubscoreWithName:[buttonSix titleLabel].text];
}

- (void)buttonAddOrRemoveSubscoreWithName:(NSString *)name
{
    int startTime = [self getFirstEditableTimeForScore];
    bool isAddingSubscore = [score addOrRemoveSubscoreWithName:name withTimeIndex:startTime];
    [score changeTimeIndexTo:currentScoreIndex];  //maybe reorder these so we don't have to do visual updates until we know if its feasible.  not sure right now, so we'll wait
    [self updateButtonColors];
    [self updateNoteExistanceToEndFromTime:startTime];
    if (isCurrentlyPlaying && !isGloballyFeasible)
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Infeasible Change"
                                                         message:@"Your score change was infeasible for the robots that are currently playing."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        [score addOrRemoveSubscoreWithName:name withTimeIndex:startTime];
        [score changeTimeIndexTo:currentScoreIndex];
        [self updateButtonColors];
        [self updateNoteExistanceToEndFromTime:startTime];
        if (!isGloballyFeasible)
        {
            NSLog(@"Problem: reversed subscore change didn't reverse infeasibility.");
        }
    }
    else
    {
        if (isAddingSubscore)
        {
            [score sendAddSubscoreMessage:name withStartTimeIndex:startTime];
        }
        else
        {
            [score sendRemoveSubscoreMessage:name withStartTimeIndex:startTime];
        }
    }
}

- (IBAction)startPush:(id)sender
{
    PSlider.enabled = false;
    GSlider.enabled = false;
    DSlider.enabled = false;
    PGSlider.enabled = false;
    GDSlider.enabled = false;
    PDSlider.enabled = false;
    PGDSlider.enabled = false;
    [self updateFeasibilityAndRobotDistribution];
//    scoreMask = [[UIView alloc] initWithFrame:self.view.window.frame];
//    [scoreMask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0/*.78*/]];
//    [self.view addSubview:scoreMask];
//    [score startPlayingWithMessage:[NSString stringWithFormat:@":%@:%@:%@:%@:%@:%@:%@:%0.1f", PInUseText.text, GInUseText.text, DInUseText.text, PGInUseText.text, GDInUseText.text, PDInUseText.text, PGDInUseText.text,(tempoControl.maximumValue - tempoControl.value + tempoControl.minimumValue)]];
    [score startPlayingWithMessage:[NSString stringWithFormat:@":%@:%@:%@:%@:%@:%@:%@:%0.1f", PAvailableText.text, GAvailableText.text, DAvailableText.text, PGAvailableText.text, GDAvailableText.text, PDAvailableText.text, PGDAvailableText.text,(tempoControl.maximumValue - tempoControl.value + tempoControl.minimumValue)]];
    isCurrentlyPlaying = true;
    startButton.enabled = false;
    [self updateScoreMaskExistance];
}

- (IBAction)didTouchTempo:(id)sender
{
    [masterView setTempoFactor:(tempoControl.maximumValue - tempoControl.value + tempoControl.minimumValue)];
    tempoText.text = [NSString stringWithFormat:@"Tempo (%0.1fx)", (tempoControl.maximumValue - tempoControl.value + tempoControl.minimumValue)];
    
    /*for(UIView *myView in [ScoreView subviews])
    {
        [myView removeFromSuperview];
    }*/
    
//    UIGraphicsBeginImageContextWithOptions(ScoreView.bounds.size, ScoreView.opaque, 0.0);
//    [ScoreView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"GridImage.png"];
//    
//    NSLog(@"path = %@",[paths objectAtIndex:0]);
//    
//    if ([UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES])
//    {
//        NSLog(@"wrote to file: %@",filePath);
//    }
//    else
//    {
//        NSLog(@"Failed to write to file");
//    }
}

-(void)setMasterView:(id)master
{
    masterView = master;
}

- (void) initializeScoreWithSubscores:(NSMutableDictionary *)subscores withNumberOfTimeIndices:(int)numTimes
{
    buttonArray = [[NSArray alloc] initWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive, buttonSix, nil];
    NSArray *guitarArray = [[NSArray alloc] initWithObjects:Grid2, Grid3, Grid7, Grid9, Grid11, Grid13, Grid14, nil];
    NSArray *pianoArray = [[NSArray alloc] initWithObjects:Grid1, Grid4, Grid5, Grid6, Grid8, Grid10, Grid12, nil];
    NSArray *drumArray = [[NSArray alloc] initWithObjects:Drum1, Drum2, Drum3, Drum4, Drum5, nil];
    
    for (GridView *view in guitarArray)
    {
        view.delegate = self;
    }
    
    for (GridView *view in pianoArray)
    {
        view.delegate = self;
    }
    
    for (CymbalView *view in drumArray)
    {
        view.delegate = self;
    }
    
    NetworkHelper *networkHelper = [[NetworkHelper alloc] initWithDelegate:self];
    InstrumentViewsManager *manager = [[InstrumentViewsManager alloc] initWithGuitars:guitarArray andPianos:pianoArray andDrums:drumArray andNetworkHelper:networkHelper];
    //comment line below when we don't wanna print the position crud anymore
    printf("frameSize = [%0.2f,%0.2f];\n",ScoreView.frame.size.width,ScoreView.frame.size.height);
    
    score = [[ScoreObject alloc] initWithInstrumentManager:manager withSubscoreDictionary:subscores withTimeIndices:numTimes withNetworkHelper:networkHelper];
    
    NSArray *subscoreTitles = [subscores allKeys];
    
    for (int i = 0; i < [subscoreTitles count]; i++)
    {
        [[buttonArray objectAtIndex:i] setTitle:[subscoreTitles objectAtIndex:i] forState:UIControlStateNormal];
    }
    
    
    NSMutableArray *myArray = [[NSMutableArray alloc] initWithCapacity:numTimes];
    for (int i = 0; i < numTimes; i++)
    {
        NSMutableArray *secondTierArray = [[NSMutableArray alloc] initWithCapacity:7];
        for (int i = 0; i < 7; i++)
        {
            NoteExistanceStructure *subscoreExists = [[NoteExistanceStructure alloc] init];
            subscoreExists.doNotesExist = NO;
            [secondTierArray addObject:subscoreExists];
        }
        [myArray addObject:secondTierArray];
    }
    doSubscoreNotesExistAtTimes = myArray;
}

-(void) setTimeIndexWithoutUpdate:(int)index
{
    [score changeTimeIndexTo:index];
    currentScoreIndex = index;
    [self updateScoreMaskExistance];
    [self updateButtonColors];
}


- (void) updateButtonColors
{
    for (UIButton *button in buttonArray)
    {
        NSString *subscoreName = button.titleLabel.text;
        if ([score isSubscoreName:subscoreName includedInScoreAtTime:currentScoreIndex])
        {
            Subscore *subscore = [score.subscoreDictionary objectForKey:subscoreName];
            [button setTitleColor:subscore.color forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void) didTapChangeDrumInView:(CymbalView *)view withInstrumentType:(InstrumentType *)instrumentType
{
    [score changeDrumView:view toInstrumentType:instrumentType withTimeIndex:currentScoreIndex];
    [self updateFeasibilityAndRobotDistribution];
}

- (void) didTapChangeGridInView:(GridView *)view withInstrumentType:(InstrumentType *)instrumentType
{
    [score changeGridView:view toInstrumentType:instrumentType withTimeIndex:currentScoreIndex];
    [self updateFeasibilityAndRobotDistribution];
}

- (NSArray *) getNoteExistanceArrayForTime:(int)timeInstant
{
    if(doSubscoreNotesExistAtTimes == nil)
    {
        return nil;
    }
    return [doSubscoreNotesExistAtTimes objectAtIndex:timeInstant];
}

- (void) updateNoteExistanceForCurrentTime
{
    [self updateNoteExistanceForTime:currentScoreIndex];
    [masterView refreshNoteExistance];
    [self updateFeasibilityAndRobotDistribution];
}

- (void) updateNoteExistanceForTime:(int)time
{
    InstantaneousScoreObject *instantScore = [score.instantaneousScoreArray objectAtIndex:time];
    NSDictionary *existingScores = [instantScore subscoresWithNotes];
    NSArray *arrayForTime = [doSubscoreNotesExistAtTimes objectAtIndex:time];
    for (int i = 0; i < 6; i++)
    {
        NSString *name = [((MasterViewController *)masterView).subscoreNames objectAtIndex:i];
        NoteExistanceStructure *currentNoteExistance = ((NoteExistanceStructure *)[arrayForTime objectAtIndex:i]);
        if ([existingScores objectForKey:name] != nil)
        {
            currentNoteExistance.doNotesExist = YES;
        }
        else
        {
            currentNoteExistance.doNotesExist = NO;
        }
    }
    
    if ([instantScore doesHaveUserNotes])
    {
        ((NoteExistanceStructure *)[arrayForTime objectAtIndex:6]).doNotesExist = YES;
    }
    else
    {
        ((NoteExistanceStructure *)[arrayForTime objectAtIndex:6]).doNotesExist = NO;
    }
}

- (void) updateNoteExistanceFromTime:(int)startTime throughTime:(int)endTime
{
    for (int i = startTime; i <= endTime; i++)
    {
        [self updateNoteExistanceForTime:i];
    }
    [self updateFeasibilityAndRobotDistribution];
    [masterView refreshNoteExistance];
}

- (void) updateNoteExistanceToEndFromTime:(int)time
{
    [self updateNoteExistanceFromTime:time throughTime:(score.numberOfTimeInstances - 1)];
}

- (void) updateNoteExistanceFromCurrentTimeToEnd
{
    [self updateNoteExistanceToEndFromTime:currentScoreIndex];
}

- (bool) isValidNoteChangeForCurrentTime
{
    [self updateNoteExistanceForCurrentTime];
    if ((!isGloballyFeasible) && isCurrentlyPlaying)
    {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Infeasible Choice"
                                                         message:@"Your score change was infeasible for the robots that are currently playing."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)updateFeasibilityAndRobotDistribution
{
    UIColor *textColor;
    NSArray *availableRobots = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithInt:round(PSlider.value)],[[NSNumber alloc] initWithInt:round(GSlider.value)],[[NSNumber alloc] initWithInt:round(DSlider.value)],[[NSNumber alloc] initWithInt:round(PGSlider.value)],[[NSNumber alloc] initWithInt:round(GDSlider.value)],[[NSNumber alloc] initWithInt:round(PDSlider.value)],[[NSNumber alloc] initWithInt:round(PGDSlider.value)], nil];
    NSMutableArray *optimalDistrib = [[NSMutableArray alloc] initWithCapacity:7];
    bool isFeasible = [score isCurrentScoreFeasible:availableRobots withOptimalDistribution:optimalDistrib withFeasibilityArray:[self getFeasibilityArray]];
    if (!isFeasible)
    {
        textColor = [UIColor redColor];
        NSLog(@"NOT FEASIBLE");
        PInUseText.text = @"0";
        GInUseText.text = @"0";
        DInUseText.text = @"0";
        PGInUseText.text = @"0";
        GDInUseText.text = @"0";
        PDInUseText.text = @"0";
        PGDInUseText.text = @"0";
        startButton.enabled = false;
        isGloballyFeasible = false;
        self.navigationController.navigationBar.barTintColor = [UIColor redColor];
        NSLog(@"nav bar frame: %0.2f", self.navigationController.navigationBar.frame.size.height);
        ((MasterViewController *)masterView).navigationController.navigationBar.barTintColor = [UIColor redColor];
    }
    else
    {
        textColor = [UIColor clearColor];
        PInUseText.text = [[NSString alloc] initWithFormat:@"%i",[[optimalDistrib objectAtIndex:0] intValue]];
        GInUseText.text = [[NSString alloc] initWithFormat:@"%i",[[optimalDistrib objectAtIndex:1] intValue]];
        DInUseText.text = [[NSString alloc] initWithFormat:@"%i",[[optimalDistrib objectAtIndex:2] intValue]];
        PGInUseText.text = [[NSString alloc] initWithFormat:@"%i",[[optimalDistrib objectAtIndex:3] intValue]];
        GDInUseText.text = [[NSString alloc] initWithFormat:@"%i",[[optimalDistrib objectAtIndex:4] intValue]];
        PDInUseText.text = [[NSString alloc] initWithFormat:@"%i",[[optimalDistrib objectAtIndex:5] intValue]];
        PGDInUseText.text = [[NSString alloc] initWithFormat:@"%i",[[optimalDistrib objectAtIndex:6] intValue]];
        NSLog(@"WOOOO FEASIBLE!!!!");
        if (!isCurrentlyPlaying)
        {
            startButton.enabled = true;
        }
        isGloballyFeasible = true;
        self.navigationController.navigationBar.barTintColor = nil;
        NSLog(@"nav bar frame: %0.2f", self.navigationController.navigationBar.frame.size.height);
        ((MasterViewController *)masterView).navigationController.navigationBar.barTintColor = nil;
        
    }
    
    [[masterView tableView] reloadData];
}

- (NSMutableArray *) getFeasibilityArray
{
    if (feasibilityArray == nil)
    {
        feasibilityArray = [[NSMutableArray alloc] initWithCapacity:score.numberOfTimeInstances];
        for (int i = 0; i < score.numberOfTimeInstances; i++)
        {
            [feasibilityArray addObject:[NSNumber numberWithBool:YES]];
        }
    }
    return feasibilityArray;
}

- (bool)doesScoreExist
{
    if (score)
    {
        return YES;
    }
    return NO;
}

- (void)matlabFinishedPlayingScore
{
    isCurrentlyPlaying = false;
    self.currentMatlabTime = 0;
    if (isGloballyFeasible)
    {
        startButton.enabled = true;
    }
    [self updateScoreMaskExistance];
    [[masterView tableView] reloadData];
    PSlider.enabled = true;
    GSlider.enabled = true;
    DSlider.enabled = true;
    PGSlider.enabled = true;
    GDSlider.enabled = true;
    PDSlider.enabled = true;
    PGDSlider.enabled = true;
}

- (void) matlabReachedTimeIndex:(int)index
{
    if (isCurrentlyPlaying && index < self.currentMatlabTime)
    {
        NSLog(@"Problem: Matlab sent a previous time before finishing the score.");
    }
    else
    {
        self.currentMatlabTime = index - 1;
    }
    [self updateScoreMaskExistance];
    NSLog(@"Matlab stuff");
    [[masterView tableView] reloadData];
    //[[masterView tableView] performSelector:@selector(reloadData) onThread:<#(NSThread *)#> withObject:<#(id)#> waitUntilDone:<#(BOOL)#>];
    //[[masterView tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void) updateScoreMaskExistance
{
    if ([self isTimeIndexDisabled:currentScoreIndex])
    {
        if (scoreMask == nil)
        {
            CGRect coverFrame = self.view.window.frame;
            coverFrame.size.height = coverFrame.size.height - 170;
            scoreMask = [[UIView alloc] initWithFrame:coverFrame];
            [scoreMask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:.5]];
        }
        
        if (![scoreMask isDescendantOfView:self.view])
        {
            [self.view addSubview:scoreMask];
        }
    }
    else if ([scoreMask isDescendantOfView:self.view])
    {
        [scoreMask removeFromSuperview];
    }
}

-(bool)isTimeIndexDisabled:(int)timeIndex
{
    return ([self getFirstEditableTimeForScore] > timeIndex);
}

-(int)getFirstEditableTimeForScore
{
    if (!isCurrentlyPlaying)
    {
        return 0;
    }
    return (self.currentMatlabTime + 2);
}

@end