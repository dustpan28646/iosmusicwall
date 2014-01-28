//
//  DetailViewController.h
//  UDPMatlab
//
//  Created by Matthew Rice on 9/23/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "MasterViewController.h"
#import "ScoreObject.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, AsyncUdpSocketDelegate, GCDAsyncUdpSocketDelegate, DrumViewDelegate, GridViewDelegate>
{
    NSTimer *myTimer;
    GCDAsyncUdpSocket *sendSocket;
    AsyncUdpSocket *receiveSocket;
    float lastControlValue;
    id masterView;
    int currentScoreIndex;
    NSDictionary *scoreDictionary;
    NSArray *gridViews;
    NSArray *drumViews;
    ScoreObject *score;
    NSArray *buttonArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIStepper *tempoControl;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempoText;

@property (weak, nonatomic) IBOutlet UIView *ScoreView;
@property (weak, nonatomic) IBOutlet GridView *Grid1;
@property (weak, nonatomic) IBOutlet GridView *Grid2;
@property (weak, nonatomic) IBOutlet GridView *Grid3;
@property (weak, nonatomic) IBOutlet GridView *Grid4;
@property (weak, nonatomic) IBOutlet GridView *Grid5;
@property (weak, nonatomic) IBOutlet GridView *Grid6;
@property (weak, nonatomic) IBOutlet GridView *Grid7;
@property (weak, nonatomic) IBOutlet GridView *Grid8;
@property (weak, nonatomic) IBOutlet GridView *Grid9;
@property (weak, nonatomic) IBOutlet GridView *Grid10;
@property (weak, nonatomic) IBOutlet GridView *Grid11;
@property (weak, nonatomic) IBOutlet GridView *Grid12;
@property (weak, nonatomic) IBOutlet GridView *Grid13;
@property (weak, nonatomic) IBOutlet GridView *Grid14;
@property (weak, nonatomic) IBOutlet CymbalView *Drum1;
@property (weak, nonatomic) IBOutlet CymbalView *Drum2;
@property (weak, nonatomic) IBOutlet CymbalView *Drum3;
@property (weak, nonatomic) IBOutlet CymbalView *Drum4;
@property (weak, nonatomic) IBOutlet CymbalView *Drum5;
@property (weak, nonatomic) IBOutlet UIImageView *gridImageView;

@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
@property (weak, nonatomic) IBOutlet UIButton *buttonSix;

- (IBAction)touchedButtonOne:(id)sender;
- (IBAction)touchedButtonTwo:(id)sender;
- (IBAction)touchedButtonThree:(id)sender;
- (IBAction)touchedButtonFour:(id)sender;
- (IBAction)touchedButtonFive:(id)sender;
- (IBAction)touchedButtonSix:(id)sender;

- (IBAction)didTouchTempo:(id)sender;
-(void)newTimeIndex:(int)index withScore:(NSDictionary *)scoreDict;
-(void)setMasterView:(id)master;
- (void) initializeScoreWithSubscores:(NSMutableDictionary *)subscores withNumberOfTimeIndices:(int)numTimes;
@end
