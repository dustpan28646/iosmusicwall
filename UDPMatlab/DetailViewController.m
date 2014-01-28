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
}

- (void)drawDrumWithCenter:(CGPoint)center withRadius:(int)radius
{
//    CGRect r;
//    
//    r.origin.y = center.y - radius;
//    r.origin.x = center.x - radius;
//    r.size.width = 2*radius;
//    r.size.height = 2*radius;
    
    //CGRect borderRect = CGRectMake(0.0, 0.0, 60.0, 60.0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
//    CGContextSetRGBFillColor(context, 0, 255, 0, 1.0);
//    CGContextSetLineWidth(context, 2.0);
//    CGContextFillEllipseInRect (context, r);
//    CGContextStrokeEllipseInRect(context, r);
//    CGContextFillPath(context);
    
//    UIView *lineView = [[GridView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.y, self.view.bounds.origin.x, self.view.bounds.size.width, self.view.bounds.size.height)];
//    [self.view addSubview:lineView];
    //lineView.backgroundColor = [UIColor blackColor];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
//    CGContextSetRGBFillColor(context,1.0 ,0.0 , 1.0, .5);
//    CGContextAddEllipseInRect(context, lineView.frame);
    //lineView.backgroundColor = [UIColor blackColor];
    
}

- (void)drawGridInRect:(CGRect)rectangle withVerticalLines:(int)vertical withHorizontalLines:(int)horizontal
{
    
}

- (void)drawPianoWithBottomLeftPoint:(CGPoint)bottomLeft withHeight:(int)height withWidth:(int)width
{
    
}

- (void) viewDidAppear:(BOOL)animated
{
    tempoControl.minimumValue = 0.5;
    tempoControl.maximumValue = 1.5;
    tempoControl.stepValue = 0.1;
    tempoControl.value = 1.0;
    [self newTimeIndex:currentScoreIndex withScore:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateButtonColors) userInfo:nil repeats:NO];
//    [self sendData];
//    [self receiveData];
}

- (void) sendData
{
    sendSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [sendSocket bindToPort:4550 error:nil];
    NSString * string = @"Sample String";
    NSString * address = @"128.61.61.11";
    UInt16 port = 4560;
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    [sendSocket sendData:data toHost:address port:port withTimeout:-1 tag:1];
}

- (void) receiveData
{
    receiveSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [receiveSocket bindToPort:4590 error:nil];
    [receiveSocket receiveWithTimeout:-1 tag:1];
}

- (BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Received Data");
    NSLog(@"data:%@",[NSString stringWithUTF8String:[data bytes]]);
    NSLog(@"port: %d",port);
    NSLog(@"host: %@",host);
    [sock close];
    [self receiveData];
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
    sleep(5);
    [sendSocket close];
    [self sendData];
}

- (IBAction)touchedButtonOne:(id)sender
{
    [score addOrRemoveSubscoreWithName:[buttonOne titleLabel].text withTimeIndex:currentScoreIndex];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)touchedButtonTwo:(id)sender
{
    [score addOrRemoveSubscoreWithName:[buttonTwo titleLabel].text withTimeIndex:currentScoreIndex];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)touchedButtonThree:(id)sender
{
    [score addOrRemoveSubscoreWithName:[buttonThree titleLabel].text withTimeIndex:currentScoreIndex];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)touchedButtonFour:(id)sender
{
    [score addOrRemoveSubscoreWithName:[buttonFour titleLabel].text withTimeIndex:currentScoreIndex];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)touchedButtonFive:(id)sender
{
    [score addOrRemoveSubscoreWithName:[buttonFive titleLabel].text withTimeIndex:currentScoreIndex];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)touchedButtonSix:(id)sender
{
    [score addOrRemoveSubscoreWithName:[buttonSix titleLabel].text withTimeIndex:currentScoreIndex];
    [self newTimeIndex:currentScoreIndex withScore:nil];
}

- (IBAction)didTouchTempo:(id)sender
{
    [masterView setTempoFactor:(tempoControl.maximumValue - tempoControl.value + tempoControl.minimumValue)];
    tempoText.text = [NSString stringWithFormat:@"Tempo (%0.1f seconds)", (tempoControl.maximumValue - tempoControl.value + tempoControl.minimumValue)];
    
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
        NSLog(@"wrote to file");
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
    InstrumentViewsManager *manager = [[InstrumentViewsManager alloc] initWithGuitars:guitarArray andPianos:pianoArray andDrums:drumArray];
    
    score = [[ScoreObject alloc] initWithInstrumentManager:manager withSubscoreDictionary:subscores withTimeIndices:numTimes];
    
    NSArray *subscoreTitles = [subscores allKeys];
    
    [buttonOne setTitle:[subscoreTitles objectAtIndex:0] forState:UIControlStateNormal];
    [buttonTwo setTitle:[subscoreTitles objectAtIndex:1] forState:UIControlStateNormal];
    [buttonThree setTitle:[subscoreTitles objectAtIndex:2] forState:UIControlStateNormal];
    [buttonFour setTitle:[subscoreTitles objectAtIndex:3] forState:UIControlStateNormal];
    [buttonFive setTitle:[subscoreTitles objectAtIndex:4] forState:UIControlStateNormal];
    [buttonSix setTitle:[subscoreTitles objectAtIndex:5] forState:UIControlStateNormal];
    
}

-(void)newTimeIndex:(int)index withScore:(NSDictionary *)scoreDict
{
    [score changeTimeIndexTo:index];
    currentScoreIndex = index;
    [self updateButtonColors];
//    scoreDictionary = scoreDict;
//    NSMutableArray *drumArray = [scoreDictionary objectForKey:@"drum"];
//    NSMutableArray *drum1 = [drumArray objectAtIndex:0];
//    NSMutableArray *drum2 = [drumArray objectAtIndex:1];
//    NSMutableArray *drum3 = [drumArray objectAtIndex:2];
//    NSMutableArray *drum4 = [drumArray objectAtIndex:3];
//    NSMutableArray *drum5 = [drumArray objectAtIndex:4];
//    
//    [Drum1 setType:CYMBAL withNoteArray:drum1];
//    [Drum2 setType:SNARE withNoteArray:drum2];
//    [Drum3 setType:SNARE withNoteArray:drum3];
//    [Drum4 setType:SNARE withNoteArray:drum4];
//    [Drum5 setType:BASS_DRUM withNoteArray:drum5];
//    
//    NSMutableArray *gridArray = [scoreDictionary objectForKey:@"grid"];
//    
//    [Grid1 setInstrument:NO withSelectedNotes:[gridArray objectAtIndex:0]];
//    [Grid2 setInstrument:YES withSelectedNotes:[gridArray objectAtIndex:1]];
//    [Grid3 setInstrument:YES withSelectedNotes:[gridArray objectAtIndex:2]];
//    [Grid4 setInstrument:NO withSelectedNotes:[gridArray objectAtIndex:3]];
//    [Grid5 setInstrument:NO withSelectedNotes:[gridArray objectAtIndex:4]];
//    [Grid6 setInstrument:NO withSelectedNotes:[gridArray objectAtIndex:5]];
//    [Grid7 setInstrument:YES withSelectedNotes:[gridArray objectAtIndex:6]];
//    [Grid8 setInstrument:NO withSelectedNotes:[gridArray objectAtIndex:7]];
//    [Grid9 setInstrument:YES withSelectedNotes:[gridArray objectAtIndex:8]];
//    [Grid10 setInstrument:NO withSelectedNotes:[gridArray objectAtIndex:9]];
//    [Grid11 setInstrument:YES withSelectedNotes:[gridArray objectAtIndex:10]];
//    [Grid12 setInstrument:NO withSelectedNotes:[gridArray objectAtIndex:11]];
//    [Grid13 setInstrument:YES withSelectedNotes:[gridArray objectAtIndex:12]];
//    [Grid14 setInstrument:YES withSelectedNotes:[gridArray objectAtIndex:13]];
//    //yes if it is a guitar
//    
//    gridViews = [[NSArray alloc] initWithObjects:Grid1,Grid2,Grid3,Grid4,Grid5,Grid6,Grid7,Grid8,Grid9,Grid10,Grid11,Grid12,Grid13,Grid14, nil];
//    drumViews = [[NSArray alloc] initWithObjects:Drum1,Drum2,Drum3,Drum4,Drum5, nil];
    
}

- (void) updateButtonColors
{
    for (UIButton *button in buttonArray)
    {
        if ([score isSubscoreName:button.titleLabel.text includedInScoreAtTime:currentScoreIndex])
        {
            [button setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
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
}

- (void) didTapChangeGridInView:(GridView *)view withInstrumentType:(InstrumentType *)instrumentType
{
    [score changeGridView:view toInstrumentType:instrumentType withTimeIndex:currentScoreIndex];
}

@end
