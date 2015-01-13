//
//  GridView.h
//  UDPMatlab
//
//  Created by Matthew Rice on 10/24/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstrumentType.h"
#import "BooleanObject.h"
#import "NetworkHelper.h"


@class GridView;

@protocol GridViewDelegate <NSObject>
@required
- (void) didTapChangeGridInView:(GridView *)view withInstrumentType:(InstrumentType *)instrumentType;
- (void) didChangeNoteForCurrentTime;
@end

@interface GridView : UIView
{
    NSArray *score;
    InstrumentType *type;
    double jumpSize;
    NetworkHelper *networkHelper;
    int gridIndex;
    int time;
}

@property (weak, nonatomic) id<GridViewDelegate> delegate;

- (void)setNoteArray:(NSArray *)notes withInstrumentType:(InstrumentType *)instType withNetworkHelper:(NetworkHelper *)helper withInstrumentIndex:(int)index withTimeIndex:(int)timeIndex;
-(void) printButtonPositions;

@end
