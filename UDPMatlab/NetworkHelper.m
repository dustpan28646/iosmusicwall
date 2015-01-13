//
//  NetworkHelper.m
//  UDPMatlab
//
//  Created by Matthew Rice on 11/24/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

- (id)init
{
    self = [super init];
    if (self)
    {
        streamHasBeenOpened = false;
        //UDP
//        if (networkSocket != nil)
//        {
//            networkSocket = nil;
//        }
//        messageBuffer = [[NSMutableDictionary alloc] init];
//        lastSentID = 0;
//        nextIDToAddToBuffer = 1;
//        networkSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//        [networkSocket bindToPort:4550 error:nil];
//        [networkSocket beginReceiving:nil];
        
        //TCP Socket
        NSLog(@"Tcp Client Initialise");
        
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStringRef remoteHost = CFSTR("localhost");
        
        CFStreamCreatePairWithSocketToHost(NULL, remoteHost, 4550, &readStream, &writeStream);
        
        InputStream = (NSInputStream *)CFBridgingRelease(readStream);
        OutputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
        
        [InputStream setDelegate:self];
        [OutputStream setDelegate:self];
        
        [InputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [OutputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [InputStream open];
        [OutputStream open];
    }
    return self;
}

- (void)addMessageToSendQueue:(NSString *)message
{
    //input message format command_code:start_time_index-end_time_index:object_index
    //UDP
//    NSString *ID = [NSString stringWithFormat:@"%i",nextIDToAddToBuffer];
//    NSString *messageWithID = [NSString stringWithFormat:@"<%@:%@>",ID,message];
//    [messageBuffer setObject:message forKey:ID];
//    nextIDToAddToBuffer++;
//    if([messageBuffer count] < 2)
//    {
//        [self sendNextMessage];
//    }
    
    //TCP
    
    
}

- (void)sendNextMessage
{
    //UDP
//    int sendingID = lastSentID + 1;
//    
//    NSString *messageToSend = nil;
//    
//    while (messageToSend == nil)
//    {
//        if (sendingID < nextIDToAddToBuffer)
//        {
//            messageToSend = [messageBuffer objectForKey:[NSString stringWithFormat:@"%i",sendingID]];
//        }
//        else
//        {
//            NSLog(@"Warning: Tried to send message, but no messages in buffer to send.");
//            lastSentID = nextIDToAddToBuffer - 1;
//            return;
//        }
//    }
//    //rework sending and receiving
////    if(sendSocket == nil)
////    {
////        sendSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
////        [sendSocket bindToPort:4550 error:nil];
////        [sendSocket beginReceiving:nil];
////    }
//    
////    NSString * string = @"Indices: 1 2 3 4 5 6 7";
////    NSString * address = @"128.61.61.11";
//    NSString *address = @"143.215.117.137";
//    UInt16 port = 4560;
//    NSData *data = [messageToSend dataUsingEncoding:NSUTF8StringEncoding];
//    [networkSocket sendData:data toHost:address port:port withTimeout:-1 tag:(long)sendingID];
//    timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
//                                     target:self
//                                   selector:@selector(didNotReceiveConfirmation)
//                                   userInfo:nil
//                                    repeats:NO];
//    lastSentID = sendingID;
    
    //TCP
    
    NSString *response  = @"HELLO1234";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [OutputStream write:[data bytes] maxLength:[data length]];	//<<Returns actual number of bytes sent - check if trying to send a large number of bytes as they may well not have all gone in this write and will need sending once there is a hasspaceavailable event
    

}

- (void)dealloc
{
    [InputStream close];
    [OutputStream close];
    InputStream = nil;
    OutputStream = nil;
    OutputData = nil;
}

//UDP
//- (void) didNotReceiveConfirmation
//{
//    [timeoutTimer invalidate];
//    timeoutTimer = nil;
//    lastSentID--;
//    [self sendNextMessage];
//}

//- (void) udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
//{
//    [timeoutTimer invalidate];
//    timeoutTimer = nil;
//    NSString *mystring = [NSString stringWithUTF8String:[data bytes]];
//    NSLog(@"Received %@", mystring);
////    NSArray *openMessageArray = [mystring componentsSeparatedByString:@"<"];
////    NSArray *closeMessageArray = [((NSString *)[openMessageArray objectAtIndex:1]) componentsSeparatedByString:@">"];
//    NSRange openBracket = [mystring rangeOfString:@"<"];
//    NSRange closeBracket = [mystring rangeOfString:@">"];
//    if ((openBracket.location == NSNotFound) || (closeBracket.location == NSNotFound))
//    {
//        NSLog(@"No valid response message found");
//        return;
//    }
//    NSRange numberRange = NSMakeRange(openBracket.location + 1, closeBracket.location - openBracket.location - 1);
//    NSString *messageID = [mystring substringWithRange:numberRange];
//    [messageBuffer removeObjectForKey:messageID];
//    [self sendNextMessage];
//}

//TCP

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)StreamEvent
{
    NSError *err = [theStream streamError];
    switch (StreamEvent)
    {
        case NSStreamEventOpenCompleted:
            if (theStream == OutputStream)
            {
                streamHasBeenOpened = true;
            }
            NSLog(@"TCP Client - Stream opened");
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (theStream == InputStream)
            {
                uint8_t buffer[1024];
                int len;
                
                while ([InputStream hasBytesAvailable])
                {
                    len = (int)[InputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output)
                        {
                            NSLog(@"TCP Client - Server sent: %@", output);
                            if (InputString == nil)
                            {
                                InputString = [[NSMutableString alloc] initWithString:output];
                            }
                            else
                            {
                                [InputString appendString:output];
                            }
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventErrorOccurred:
            
            NSLog(@"Error %li: %@",(long)[err code], [err localizedDescription]);
            [theStream close];
            
            break;
            
        case NSStreamEventEndEncountered:
            NSLog(@"TCP Client - End encountered");
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
            
        case NSStreamEventNone:
            NSLog(@"TCP Client - None event");
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"TCP Client - Has space available event");
            if (OutputData != nil)
            {
                //Send rest of the packet
                int ActualOutputBytes = (int)[OutputStream write:[OutputData bytes] maxLength:[OutputData length]];
                
                if (ActualOutputBytes >= [OutputData length])
                {
                    //It was all sent
                    OutputData = nil;
                }
                else
                {
                    //Only partially sent
                    [OutputData replaceBytesInRange:NSMakeRange(0, ActualOutputBytes) withBytes:NULL length:0];		//Remove sent bytes from the start
                }
            }
            break;
            
        default:
            NSLog(@"TCP Client - Unknown event");
    }
    
}

- (void) sendString:(NSString *)string
{
    NSData *dataToSend = [string dataUsingEncoding:NSUTF8StringEncoding];
    int len = (int)[dataToSend length];
    if (OutputData == nil)
    {
        OutputData = [[NSMutableData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        [OutputData appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //Send some data (large block where the write may not actually send all we request it to send)
    if ([OutputStream hasSpaceAvailable] && streamHasBeenOpened)
    {
        int ActualOutputBytes = (int)[OutputStream write:[OutputData bytes] maxLength:[OutputData length]];
    
        if (ActualOutputBytes >= len)
        {
            //It was all sent
            OutputData = nil;
        }
        else
        {
            //Only partially sent
            [OutputData replaceBytesInRange:NSMakeRange(0, ActualOutputBytes) withBytes:NULL length:0];		//Remove sent bytes from the start
        }
    }
}

- (void) receivedInput
{
    //We don't expect to receive messages, so we just discard them :)
    NSLog(@"Received Message:%@",InputString);
    InputString = nil;
    
}

@end
