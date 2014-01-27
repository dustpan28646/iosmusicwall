//
//  GridView.h
//  UDPMatlab
//
//  Created by Matthew Rice on 10/24/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GridView;

@protocol GridViewDelegate <NSObject>
@required
- (void) didTapChangeGridInView:(GridView *)view withIsGuitar:(bool)isGuitar;
@end

@interface GridView : UIView
{
    NSMutableArray *score;
    bool isInstrumentGuitar;
    double jumpSize;
}

@property (assign, nonatomic) id<GridViewDelegate> delegate;

- (void)setInstrument:(bool)isGuitar withSelectedNotes:(NSMutableArray *)noteArray;

@end
