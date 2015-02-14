//
//  InstantaneousScoreObject.m
//  UDPMatlab
//
//  Created by H. William Rice on 1/25/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import "InstantaneousScoreObject.h"

@implementation InstantaneousScoreObject

@synthesize guitarScoreArray;
@synthesize pianoScoreArray;
@synthesize drumScoreArray;
@synthesize subscores;
@synthesize guitarHasInstrumentType;
@synthesize pianoHasInstrumentType;
@synthesize drumHasInstrumentType;

- (id) initInstantaneousScoreObjectWithUserSubscore:(Subscore *)userSub
{
    self = [super init];
    if (self)
    {
        NSMutableArray *guitarArray = [[NSMutableArray alloc] initWithCapacity:42];
        for (int i = 0; i < 42; i++)
        {
            [guitarArray addObject:[[BooleanObject alloc] initWithBool:NO withSubscore:nil]];
        }
        
        NSMutableArray *pianoArray = [[NSMutableArray alloc] initWithCapacity:42];
        for (int i = 0; i < 42; i++)
        {
            [pianoArray addObject:[[BooleanObject alloc] initWithBool:NO withSubscore:nil]];
        }
        
        NSMutableArray *drumArray = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < 5; i++)
        {
            [drumArray addObject:[[BooleanObject alloc] initWithBool:NO withSubscore:nil]];
        }
        
        self.guitarScoreArray = [NSArray arrayWithArray:guitarArray];
        self.pianoScoreArray = [NSArray arrayWithArray:pianoArray];
        self.drumScoreArray = [NSArray arrayWithArray:drumArray];
        self.subscores = [[NSMutableDictionary alloc] init];
        
        guitarHasInstrumentType = [[NSArray alloc] initWithObjects:[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR],[[InstrumentType alloc] initWithType:TYPE_GUITAR], nil];
        pianoHasInstrumentType = [[NSArray alloc] initWithObjects:[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO],[[InstrumentType alloc] initWithType:TYPE_PIANO], nil];
        drumHasInstrumentType = [[NSArray alloc] initWithObjects:[[InstrumentType alloc] initWithType:TYPE_CYMBAL],[[InstrumentType alloc] initWithType:TYPE_BASS_DRUM],[[InstrumentType alloc] initWithType:TYPE_BASS_DRUM_2],[[InstrumentType alloc] initWithType:TYPE_CYMBAL_2],[[InstrumentType alloc] initWithType:TYPE_SNARE], nil];
        
        
        //comment below to suppress printing of matlab initialization array
//        printf("drumTypeArray = [...\n");
//        for (InstrumentType *drumType in drumHasInstrumentType)
//        {
//            switch (drumType.type)
//            {
//                case TYPE_CYMBAL:
//                    printf("3;...\n");
//                    break;
//                case TYPE_BASS_DRUM:
//                    printf("4;...\n");
//                    break;
//                case TYPE_SNARE:
//                    printf("5;...\n");
//                    break;
//                default:
//                    printf("invalid drum;...\n");
//                    break;
//            }
//        }
//        printf("];\n");
        userSubscore = userSub;
    }
    return self;
}

- (NSDictionary *)subscoresWithNotes
{
    NSMutableDictionary *retSubscores = [[NSMutableDictionary alloc] initWithCapacity:[self.subscores count]];
    for (NSString *key in self.subscores)
    {
        Subscore *subscore = [self.subscores objectForKey:key];
        NSArray *noteArray = nil;
        switch (subscore.type)
        {
            case SUBSCORE_PIANO:
                noteArray = self.pianoScoreArray;
                break;
            case SUBSCORE_GUITAR:
                noteArray = self.guitarScoreArray;
                break;
            case SUBSCORE_DRUM:
                noteArray = self.drumScoreArray;
                break;
            default:
                break;
        }
        
        bool doesSubscoreExistHere = NO;
        for (BooleanObject *note in noteArray)
        {
            if(note.noteSubscore == subscore)
            {
                doesSubscoreExistHere = YES;
            }
        }
        
        if (doesSubscoreExistHere)
        {
            [retSubscores setObject:subscore forKey:subscore.name];
        }
    }
    
    return retSubscores;
}

- (bool)doesHaveUserNotes
{
    bool userNotesExist = NO;
    for (BooleanObject *note in self.pianoScoreArray)
    {
        if (note.doesNoteExist && (note.noteSubscore == nil))
        {
            userNotesExist = YES;
        }
    }
    for (BooleanObject *note in self.guitarScoreArray)
    {
        if (note.doesNoteExist && (note.noteSubscore == nil))
        {
            userNotesExist = YES;
        }
    }
    for (BooleanObject *note in self.drumScoreArray)
    {
        if (note.doesNoteExist && (note.noteSubscore == nil))
        {
            userNotesExist = YES;
        }
    }
    return userNotesExist;
}

@end
