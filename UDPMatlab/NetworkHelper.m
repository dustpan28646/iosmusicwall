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
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<NetworkHelperDelegate>)networkDelegate
{
    self = [super init];
    if (self)
    {
        streamHasBeenOpened = false;
        NSLog(@"Tcp Client Initialise");
        
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        CFStringRef remoteHost = /*CFSTR("192.168.1.10");*/CFSTR("localhost");/*CFSTR("192.168.1.29");*/
        //CFSTR("192.168.1.10");
        
        CFStreamCreatePairWithSocketToHost(NULL, remoteHost, 4380, &readStream, &writeStream);
        
        InputStream = (NSInputStream *)CFBridgingRelease(readStream);
        OutputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
        
        [InputStream setDelegate:self];
        [OutputStream setDelegate:self];
        
        [InputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [OutputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [InputStream open];
        [OutputStream open];
        
        self.delegate = networkDelegate;
    }
    return self;
}

- (void)dealloc
{
    [InputStream close];
    [OutputStream close];
    InputStream = nil;
    OutputStream = nil;
    OutputData = nil;
}

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
                            [self receivedInput];
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
    //just kidding, we expect lot's of fun messages now!
    if((InputString != nil) && ([InputString length] > 0))
    {
        NSArray *commandArray = [InputString componentsSeparatedByString:@">"];
        
        for (int i = 0; i < ([commandArray count] - 1); i++)
        {
            NSString *commandWithBracket = [commandArray objectAtIndex:i];
            if ([[commandWithBracket substringWithRange:NSMakeRange(0,1)] isEqualToString:@"<"])
            {
                NSString *command = [commandWithBracket substringFromIndex:1];
                NSArray *commandElements = [command componentsSeparatedByString:@":"];
                if ([[commandElements objectAtIndex:0] isEqualToString:@"fp"]) //finished playing
                {
                    [self.delegate matlabFinishedPlayingScore];
                }
                else if ([[commandElements objectAtIndex:0] isEqualToString:@"ct"] && ([commandElements count] > 1)) //current time
                {
                    int matlabTime = (int)[[commandElements objectAtIndex:1] integerValue];
                    
                    if(matlabTime == 0) //it throws a zero if it doesn't find a number.  We may actually receive zeros, so we'll actually send it anyway.  We'll throw it out if time ever progresses backwards.
                    {
                        NSLog(@"Warning: Matlab may have sent a time command without valid time");
                        NSLog(@"Command Causing the issue: %@",command);
                    }
                    
                    [self.delegate matlabReachedTimeIndex:matlabTime];
                }
                else
                {
                    NSLog(@"Problem: Received unrecognized command from matlab");
                    NSLog(@"Command causing the issue: %@",command);
                }
            }
            else
            {
                NSLog(@"Problem: Parsed command that didn't begin with '<'");
                NSLog(@"Command causing the issue (command will have bracket still on front): %@", commandWithBracket);
            }
        }
        NSLog(@"Received Message:%@",InputString);
        
        [InputString setString:[commandArray objectAtIndex:[commandArray count]-1]];
        
    }
    NSLog(@"Received Message:%@",InputString);
    
}

@end
