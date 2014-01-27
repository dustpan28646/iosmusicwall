//
//  SubscoreNote.m
//  UDPMatlab
//
//  Created by Matthew Rice on 1/27/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import "SubscoreNote.h"

@implementation SubscoreNote

@synthesize letter;
@synthesize octave;

- (id) initWithOctave:(enum NOTE_OCTAVE)noteOctave withLetter:(enum NOTE_LETTER)noteLetter
{
    self = [super init];
    if (self)
    {
        self.octave = noteOctave;
        self.letter = noteLetter;
    }
    return self;
}

- (id) initWithNoteString:(NSString *)noteString
{
    return [self initWithOctave:[SubscoreNote getOctaveForString:noteString] withLetter:[SubscoreNote getLetterForString:noteString]];
}

+ (enum NOTE_OCTAVE) getOctaveForString:(NSString *)noteString
{
    if ([noteString isEqualToString:@""])
    {
        return OCTAVE_NO_NOTE;
    }
    
    if ([noteString rangeOfString:@"drum" options:NSCaseInsensitiveSearch].location == NSNotFound)
    {
        NSString *octaveString = [noteString substringFromIndex:([noteString length] - 1)];
        int octave = [octaveString intValue];
        if (octave < 5)
        {
            return octave;
        }
        else
        {
            NSLog(@"Warning! Received Strange Octave Value.  Unparsable");
            return OCTAVE_NO_NOTE;
        }
    }
    else
    {
        return DRUM_NOTE_OCTAVE;
    }
}

- (int) getIntegerIndexForNote
{
    return ((self.octave * 12) + (self.letter));
}

+ (enum NOTE_LETTER) getLetterForString:(NSString *)noteString
{
    if ([noteString isEqualToString:@""])
    {
        return NOTE_NO_NOTE;
    }
    
    if ([noteString rangeOfString:@"drum" options:NSCaseInsensitiveSearch].location == NSNotFound)
    {
        NSString *letterString = [noteString substringToIndex:([noteString length] - 1)];
        
        if ([letterString isEqualToString:@"G"])
        {
            return NOTE_G;
        }
        else if ([letterString isEqualToString:@"G#"] || [letterString isEqualToString:@"Ab"])
        {
            return NOTE_G_SHARP;
        }
        else if ([letterString isEqualToString:@"A"])
        {
            return NOTE_A;
        }
        else if ([letterString isEqualToString:@"Bb"] || [letterString isEqualToString:@"A#"])
        {
            return NOTE_B_FLAT;
        }
        else if ([letterString isEqualToString:@"B"])
        {
            return NOTE_B;
        }
        else if ([letterString isEqualToString:@"C"])
        {
            return NOTE_C;
        }
        else if ([letterString isEqualToString:@"C#"] || [letterString isEqualToString:@"Db"])
        {
            return NOTE_C_SHARP;
        }
        else if ([letterString isEqualToString:@"D"])
        {
            return NOTE_D;
        }
        else if ([letterString isEqualToString:@"Eb"] || [letterString isEqualToString:@"D#"])
        {
            return NOTE_E_FLAT;
        }
        else if ([letterString isEqualToString:@"E"])
        {
            return NOTE_E;
        }
        else if ([letterString isEqualToString:@"F"])
        {
            return NOTE_F;
        }
        else if ([letterString isEqualToString:@"F#"] || [letterString isEqualToString:@"Gb"])
        {
            return NOTE_F_SHARP;
        }
        else
        {
            NSLog(@"Warning! Unparsable Note");
            return NOTE_NO_NOTE;
        }
    }
    else
    {
        NSString *drumNoteString = [noteString substringFromIndex:([noteString length] - 1)];
        int drumNote = [drumNoteString intValue];
        if (drumNote < 5)
        {
            return drumNote;
        }
        else
        {
            NSLog(@"Warning! Unparsable Drum Note!");
            return NOTE_NO_NOTE;
        }
    }
}

@end
