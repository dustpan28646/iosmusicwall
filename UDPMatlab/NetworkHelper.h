//
//  NetworkHelper.h
//  UDPMatlab
//
//  Created by Matthew Rice on 11/24/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

@interface NetworkHelper : NSObject<NSStreamDelegate>
//UDP<GCDAsyncUdpSocketDelegate>
{
    //UDP
//    NSMutableDictionary *messageBuffer;
//    int lastSentID;
//    int nextIDToAddToBuffer;
//    GCDAsyncUdpSocket *networkSocket;
//    NSTimer *timeoutTimer;
    //TCP
    NSInputStream *InputStream;
    NSOutputStream *OutputStream;
    NSMutableData *OutputData;
    NSMutableString *InputString;
    bool streamHasBeenOpened;
}

- (void) sendString:(NSString *)string;

@end
