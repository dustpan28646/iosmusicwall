//
//  CymbalView.h
//  UDPMatlab
//
//  Created by Matthew Rice on 10/24/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstrumentType.h"
#import "BooleanObject.h"

enum DRUM_TYPE
{
    CYMBAL,
    BASS_DRUM,
    SNARE,
    NO_DRUM
};

@class CymbalView;

@protocol DrumViewDelegate <NSObject>
@required
- (void) didTapChangeDrumInView:(CymbalView *)view withInstrumentType:(InstrumentType *)instrumentType;
- (void) didChangeNoteForCurrentTime;
@end

@interface CymbalView : UIView
{
    InstrumentType *type;
    BooleanObject *note;
    NSMutableArray *centers;
    CGPoint center;
}

@property (weak, nonatomic) id<DrumViewDelegate> delegate;

- (void)setNote:(BooleanObject *)booleanNoteObject withInstrumentType:(InstrumentType *)instType;
- (void) printPosition;
- (enum INSTRUMENT_TYPE) getInstrumentType;

@end
