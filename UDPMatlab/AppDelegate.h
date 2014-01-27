//
//  AppDelegate.h
//  UDPMatlab
//
//  Created by Matthew Rice on 9/23/13.
//  Copyright (c) 2013 Matthew Rice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AsyncUdpSocketDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
