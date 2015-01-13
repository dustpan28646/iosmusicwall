//
//  DetailViewController.m
//  UDPMatlab
//
//  Created by Matthew Rice on 9/23/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import "DetailViewController.h"

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
    PAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PSlider.value)];
    GAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(GSlider.value)];
    DAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(DSlider.value)];
    PGAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PGSlider.value)];
    GDAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(GDSlider.value)];
    PDAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PDSlider.value)];
    PGDAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PGDSlider.value)];
    [self PSliderValueChanged:self];
    [self GSliderValueChanged:self];
    [self DSliderValueChanged:self];
    [self PGSliderValueChanged:self];
    [self GDSliderValueChanged:self];
    [self PDSliderValueChanged:self];
    [self PGDSliderValueChanged:self];
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    tempoControl.minimumValue = 0.5;
    tempoControl.maximumValue = 1.5;
    tempoControl.stepValue = 0.1;
    tempoControl.value = 1.0;
    [self newTimeIndex:currentScoreIndex withScore:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateButtonColors) userInfo:nil repeats:NO];
    [self sendData];
}

- (void) sendData
{
    //rework sending and receiving
//    if(sendSocket == nil)
//    {
//        sendSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//        [sendSocket bindToPort:4550 error:nil];
//        [sendSocket beginReceiving:nil];
//    }
//    
//    NSString * string = @"Indices: 1 2 3 4 5 6 7";
//    //NSString * address = @"128.61.61.11";
//    NSString * address = @"143.215.117.137";
//    UInt16 port = 4560;
//    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    [sendSocket sendData:data toHost:address port:port withTimeout:-1 tag:1];
}

- (void) receiveDataWithSocket:(AsyncUdpSocket *)socket
{
    //receiveSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    //[socket bindToPort:4560 error:nil];
}

- (BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Received Data");
    NSLog(@"data:%@",[NSString stringWithUTF8String:[data bytes]]);
    NSLog(@"port: %d",port);
    NSLog(@"host: %@",host);
    [self sendData];
    return YES;
}

- (void) onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"SENT TAG!");
}

- (void) onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"Error:");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"Sent!!");
}

- (void) udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
//    NSString *mystring = [NSString stringWithUTF8String:[data bytes]];
//    NSLog(@"Received %@", mystring);
//    [self sendData];
}

- (IBAction)PSliderValueChanged:(id)sender
{
    PAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PSlider.value)];
    PSlider.value = round(PSlider.value);
    if (PSlider.value > 0)
    {
        [PInUseText setTextColor:[UIColor yellowColor]];
        [PTypeText setTextColor:[UIColor yellowColor]];
        [PAvailableText setTextColor:[UIColor yellowColor]];
    }
    else
    {
        [PInUseText setTextColor:[UIColor whiteColor]];
        [PTypeText setTextColor:[UIColor whiteColor]];
        [PAvailableText setTextColor:[UIColor whiteColor]];
    }
    if (score != nil)
    {
        [self updateFeasibilityAndRobotDistribution];
    }
}

- (IBAction)GSliderValueChanged:(id)sender
{
    GAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(GSlider.value)];
    GSlider.value = round(GSlider.value);
    if (GSlider.value > 0)
    {
        [GInUseText setTextColor:[UIColor yellowColor]];
        [GTypeText setTextColor:[UIColor yellowColor]];
        [GAvailableText setTextColor:[UIColor yellowColor]];
    }
    else
    {
        [GInUseText setTextColor:[UIColor whiteColor]];
        [GTypeText setTextColor:[UIColor whiteColor]];
        [GAvailableText setTextColor:[UIColor whiteColor]];
    }
    if (score != nil)
    {
        [self updateFeasibilityAndRobotDistribution];
    }
}

- (IBAction)DSliderValueChanged:(id)sender
{
    DAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(DSlider.value)];
    DSlider.value = round(DSlider.value);
    if (DSlider.value > 0)
    {
        [DInUseText setTextColor:[UIColor yellowColor]];
        [DTypeText setTextColor:[UIColor yellowColor]];
        [DAvailableText setTextColor:[UIColor yellowColor]];
    }
    else
    {
        [DInUseText setTextColor:[UIColor whiteColor]];
        [DTypeText setTextColor:[UIColor whiteColor]];
        [DAvailableText setTextColor:[UIColor whiteColor]];
    }
    if (score != nil)
    {
        [self updateFeasibilityAndRobotDistribution];
    }
}

- (IBAction)PGSliderValueChanged:(id)sender
{
    PGAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PGSlider.value)];
    PGSlider.value = round(PGSlider.value);
    if (PGSlider.value > 0)
    {
        [PGInUseText setTextColor:[UIColor yellowColor]];
        [PGTypeText setTextColor:[UIColor yellowColor]];
        [PGAvailableText setTextColor:[UIColor yellowColor]];
    }
    else
    {
        [PGInUseText setTextColor:[UIColor whiteColor]];
        [PGTypeText setTextColor:[UIColor whiteColor]];
        [PGAvailableText setTextColor:[UIColor whiteColor]];
    }
    if (score != nil)
    {
        [self updateFeasibilityAndRobotDistribution];
    }
}

- (IBAction)GDSliderValueChanged:(id)sender
{
    GDAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(GDSlider.value)];
    GDSlider.value = round(GDSlider.value);
    if (GDSlider.value > 0)
    {
        [GDInUseText setTextColor:[UIColor yellowColor]];
        [GDTypeText setTextColor:[UIColor yellowColor]];
        [GDAvailableText setTextColor:[UIColor yellowColor]];
    }
    else
    {
        [GDInUseText setTextColor:[UIColor whiteColor]];
        [GDTypeText setTextColor:[UIColor whiteColor]];
        [GDAvailableText setTextColor:[UIColor whiteColor]];
    }
    if (score != nil)
    {
        [self updateFeasibilityAndRobotDistribution];
    }
}

- (IBAction)PDSliderValueChanged:(id)sender
{
    PDAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PDSlider.value)];
    PDSlider.value = round(PDSlider.value);
    if (PDSlider.value > 0)
    {
        [PDInUseText setTextColor:[UIColor yellowColor]];
        [PDTypeText setTextColor:[UIColor yellowColor]];
        [PDAvailableText setTextColor:[UIColor yellowColor]];
    }
    else
    {
        [PDInUseText setTextColor:[UIColor whiteColor]];
        [PDTypeText setTextColor:[UIColor whiteColor]];
        [PDAvailableText setTextColor:[UIColor whiteColor]];
    }
    if (score != nil)
    {
        [self updateFeasibilityAndRobotDistribution];
    }
}

- (IBAction)PGDSliderValueChanged:(id)sender
{
    PGDAvailableText.text = [NSString stringWithFormat:@"%i", (int)round(PGDSlider.value)];
    PGDSlider.value = round(PGDSlider.value);
    if (PGDSlider.value > 0)
    {
        [PGDInUseText setTextColor:[UIColor yellowColor]];
        [PGDTypeText setTextColor:[UIColor yellowColor]];
        [PGDAvailableText setTextColor:[UIColor yellowColor]];
    }
    else
    {
        [PGDInUseText setTextColor:[UIColor whiteColor]];
        [PGDTypeText setTextColor:[UIColor whiteColor]];
        [PGDAvailableText setTextColor:[UIColor whiteColor]];
    }
    if (score != nil)
    {
        [self updateFeasibilityAndRobotDistribution];
    }
}

- (IBAction)touchedButtonOne:(id)sender
{
//    [score addOrRemoveSubscoreWithName:[buttonOne titleLabel].text withTimeIndex:currentScoreIndex];
    [score addOrRemoveSubscoreWithName:[buttonOne titleLabel].text withTimeIndex:0];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)touchedButtonTwo:(id)sender
{
//    [score addOrRemoveSubscoreWithName:[buttonTwo titleLabel].text withTimeIndex:currentScoreIndex];
    [score addOrRemoveSubscoreWithName:[buttonTwo titleLabel].text withTimeIndex:0];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)touchedButtonThree:(id)sender
{
//    [score addOrRemoveSubscoreWithName:[buttonThree titleLabel].text withTimeIndex:currentScoreIndex];
    [score addOrRemoveSubscoreWithName:[buttonThree titleLabel].text withTimeIndex:0];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)touchedButtonFour:(id)sender
{
//    [score addOrRemoveSubscoreWithName:[buttonFour titleLabel].text withTimeIndex:currentScoreIndex];
    [score addOrRemoveSubscoreWithName:[buttonFour titleLabel].text withTimeIndex:0];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)touchedButtonFive:(id)sender
{
//    [score addOrRemoveSubscoreWithName:[buttonFive titleLabel].text withTimeIndex:currentScoreIndex];
    [score addOrRemoveSubscoreWithName:[buttonFive titleLabel].text withTimeIndex:0];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)touchedButtonSix:(id)sender
{
//    [score addOrRemoveSubscoreWithName:[buttonSix titleLabel].text withTimeIndex:currentScoreIndex];
    [score addOrRemoveSubscoreWithName:[buttonSix titleLabel].text withTimeIndex:0];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)startPush:(id)sender
{
    [self updateFeasibilityAndRobotDistribution];
    UIView *mask = [[UIView alloc] initWithFrame:self.view.window.frame];
    [mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.78]];
    [self.view addSubview:mask];
    [score startPlayingWithMessage:[NSString stringWithFormat:@":%@:%@:%@:%@:%@:%@:%@", PInUseText.text, GInUseText.text, DInUseText.text, PGInUseText.text, GDInUseText.text, PDInUseText.text, PGDInUseText.text]];
}

- (IBAction)didTouchTempo:(id)sender
{
    [masterView setTempoFactor:(tempoControl.maximumValue - tempoControl.value + tempoControl.minimumValue)];
    tempoText.text = [NSString stringWithFormat:@"Tempo (%0.1f sec)", (tempoControl.maximumValue - tempoControl.value + tempoControl.minimumValue)];
    
    /*for(UIView *myView in [ScoreView subviews])
    {
        [myView removeFromSuperview];
    }*/
    
    UIGraphicsBeginImageContextWithOptions(ScoreView.bounds.size, ScoreView.opaque, 0.0);
    [ScoreView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"GridImage.png"];
    
    NSLog(@"path = %@",[paths objectAtIndex:0]);
    
    if ([UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES])
    {
        NSLog(@"wrote to file: %@",filePath);
    }
    else
    {
        NSLog(@"Failed to write to file");
    }
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
    
    NetworkHelper *networkHelper = [[NetworkHelper alloc] init];
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

-(void)newTimeIndex:(int)index withScore:(NSDictionary *)scoreDict
{
    [score changeTimeIndexTo:index];
    currentScoreIndex = index;
    [self updateButtonColors];
    [self updateNoteExistanceFromCurrentTimeToEnd];
}

-(void) setTimeIndexWithoutUpdate:(int)index
{
    [score changeTimeIndexTo:index];
    currentScoreIndex = index;
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

- (void) didChangeNoteForCurrentTime
{
    [self updateNoteExistanceForCurrentTime];
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
        startButton.enabled = true;
    }
//    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor redColor]];
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

@end
