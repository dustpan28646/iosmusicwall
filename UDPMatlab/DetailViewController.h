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
#import "NoteExistanceStructure.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, DrumViewDelegate, GridViewDelegate, NetworkHelperDelegate>
{
    NSTimer *myTimer;
    GCDAsyncUdpSocket *sendSocket;
    AsyncUdpSocket *receiveSocket;
    float lastControlValue;
    id masterView;
    NSDictionary *scoreDictionary;
    NSArray *gridViews;
    NSArray *drumViews;
    ScoreObject *score;
    NSArray *buttonArray;
    NSArray *doSubscoreNotesExistAtTimes;
    NSMutableArray *feasibilityArray;
    UIView *scoreMask;
    bool isGloballyFeasible;
    bool isCurrentlyPlaying;
    NSArray *isButtonSelected;
//    bool buttonOneBool;
//    bool buttonTwoBool;
//    bool buttonThreeBool;
//    bool buttonFourBool;
//    bool buttonFiveBool;
//    bool buttonSixBool;
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

@property (nonatomic) int currentScoreIndex;


@property (weak, nonatomic) IBOutlet UISlider *PSlider;
@property (weak, nonatomic) IBOutlet UISlider *GSlider;
@property (weak, nonatomic) IBOutlet UISlider *DSlider;
@property (weak, nonatomic) IBOutlet UISlider *PGSlider;
@property (weak, nonatomic) IBOutlet UISlider *GDSlider;
@property (weak, nonatomic) IBOutlet UISlider *PDSlider;
@property (weak, nonatomic) IBOutlet UISlider *PGDSlider;

@property (weak, nonatomic) IBOutlet UILabel *PAvailableText;
@property (weak, nonatomic) IBOutlet UILabel *GAvailableText;
@property (weak, nonatomic) IBOutlet UILabel *DAvailableText;
@property (weak, nonatomic) IBOutlet UILabel *PGAvailableText;
@property (weak, nonatomic) IBOutlet UILabel *GDAvailableText;
@property (weak, nonatomic) IBOutlet UILabel *PDAvailableText;
@property (weak, nonatomic) IBOutlet UILabel *PGDAvailableText;

@property (weak, nonatomic) IBOutlet UILabel *PInUseText;
@property (weak, nonatomic) IBOutlet UILabel *GInUseText;
@property (weak, nonatomic) IBOutlet UILabel *DInUseText;
@property (weak, nonatomic) IBOutlet UILabel *PGInUseText;
@property (weak, nonatomic) IBOutlet UILabel *GDInUseText;
@property (weak, nonatomic) IBOutlet UILabel *PDInUseText;
@property (weak, nonatomic) IBOutlet UILabel *PGDInUseText;

@property (weak, nonatomic) IBOutlet UILabel *PTypeText;
@property (weak, nonatomic) IBOutlet UILabel *GTypeText;
@property (weak, nonatomic) IBOutlet UILabel *DTypeText;
@property (weak, nonatomic) IBOutlet UILabel *PGTypeText;
@property (weak, nonatomic) IBOutlet UILabel *GDTypeText;
@property (weak, nonatomic) IBOutlet UILabel *PDTypeText;
@property (weak, nonatomic) IBOutlet UILabel *PGDTypeText;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UINavigationItem *topBar;

@property (nonatomic) int currentMatlabTime;

- (IBAction)PSliderValueChanged:(id)sender;
- (IBAction)GSliderValueChanged:(id)sender;
- (IBAction)DSliderValueChanged:(id)sender;
- (IBAction)PGSliderValueChanged:(id)sender;
- (IBAction)GDSliderValueChanged:(id)sender;
- (IBAction)PDSliderValueChanged:(id)sender;
- (IBAction)PGDSliderValueChanged:(id)sender;

- (IBAction)touchedButtonOne:(id)sender;
- (IBAction)touchedButtonTwo:(id)sender;
- (IBAction)touchedButtonThree:(id)sender;
- (IBAction)touchedButtonFour:(id)sender;
- (IBAction)touchedButtonFive:(id)sender;
- (IBAction)touchedButtonSix:(id)sender;
- (IBAction)startPush:(id)sender;

- (IBAction)didTouchTempo:(id)sender;
- (void) setTimeIndexWithoutUpdate:(int)index;
- (void)setMasterView:(id)master;
- (void) initializeScoreWithSubscores:(NSMutableDictionary *)subscores withNumberOfTimeIndices:(int)numTimes;
- (NSArray *) getNoteExistanceArrayForTime:(int)timeInstant;
- (NSMutableArray *) getFeasibilityArray;
- (bool)doesScoreExist;
- (bool)isTimeIndexDisabled:(int)timeIndex;
@end
