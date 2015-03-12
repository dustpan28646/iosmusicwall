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

- (id) initWithOctave:(enum NOTE_OCTAVE)noteOctave withLetter:(enum NOTE_LETTER)noteLetter withSubscoreName:(NSString *)subscoreName
{
    self = [super init];
    if (self)
    {
        self.octave = noteOctave;
        self.letter = noteLetter;
        if ([subscoreName rangeOfString:@"Guitar"].location != NSNotFound)
        {
            self.subscoreType = SUBSCORE_TYPE_GUITAR;
        }
        else if ([subscoreName rangeOfString:@"Piano"].location != NSNotFound)
        {
            self.subscoreType = SUBSCORE_TYPE_PIANO;
        }
        else if ([subscoreName rangeOfString:@"Drum"].location != NSNotFound)
        {
            self.subscoreType = SUBSCORE_TYPE_DRUM;
        }
        else
        {
            NSLog(@"No valid type for subscore name!  Problem!");
        }
    }
    return self;
}

- (id) initWithNoteString:(NSString *)noteString withSubscoreName:(NSString *)subscoreName
{
    return [self initWithOctave:[SubscoreNote getOctaveForString:noteString] withLetter:[SubscoreNote getLetterForString:noteString] withSubscoreName:subscoreName];
}

+ (enum NOTE_OCTAVE) getOctaveForString:(NSString *)noteString
{
    if ([noteString isEqualToString:@""])
    {
        return OCTAVE_NO_NOTE;
    }
    
    if ([noteString length]>1)//[noteString rangeOfString:@"drum" options:NSCaseInsensitiveSearch].location == NSNotFound)
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
    if (self.octave == DRUM_NOTE_OCTAVE)
    {
        return self.letter;
    }
    
    if ((self.octave == OCTAVE_ONE) && (self.letter == NOTE_F) && (self.subscoreType == SUBSCORE_TYPE_PIANO))
    {
        return ((OCTAVE_THREE *12) + (NOTE_B));
    }
    
    if ((self.octave == OCTAVE_THREE) && (self.letter == NOTE_C_SHARP) && (self.subscoreType == SUBSCORE_TYPE_PIANO))
    {
        return ((OCTAVE_ONE *12) + (NOTE_G_SHARP));
    }
    
    if ((self.octave == OCTAVE_THREE) && (self.letter == NOTE_B) && (self.subscoreType == SUBSCORE_TYPE_PIANO))
    {
        return ((OCTAVE_THREE *12) + (NOTE_C_SHARP));
    }
    
    if ((self.octave == OCTAVE_ONE) && (self.letter == NOTE_G_SHARP) && (self.subscoreType == SUBSCORE_TYPE_PIANO))
    {
        return ((OCTAVE_ONE *12) + (NOTE_F));
    }
    
    //new swaps
    if ((self.octave == OCTAVE_ONE) && (self.letter == NOTE_C) && (self.subscoreType == SUBSCORE_TYPE_GUITAR))
    {
        return ((OCTAVE_ONE *12) + (NOTE_E));
    }
    
    if ((self.octave == OCTAVE_ONE) && (self.letter == NOTE_E) && (self.subscoreType == SUBSCORE_TYPE_GUITAR))
    {
        return ((OCTAVE_ONE *12) + (NOTE_C));
    }
    
    if ((self.octave == OCTAVE_ONE) && (self.letter == NOTE_F) && (self.subscoreType == SUBSCORE_TYPE_GUITAR))
    {
        return ((OCTAVE_ONE *12) + (NOTE_C_SHARP));
    }
    
    if ((self.octave == OCTAVE_ONE) && (self.letter == NOTE_C_SHARP) && (self.subscoreType == SUBSCORE_TYPE_GUITAR))
    {
        return ((OCTAVE_TWO *12) + (NOTE_C));
    }
    
    if ((self.octave == OCTAVE_TWO) && (self.letter == NOTE_C) && (self.subscoreType == SUBSCORE_TYPE_GUITAR))
    {
        return ((OCTAVE_ONE *12) + (NOTE_F));
    }
    
    // new piano swaps
    
    //D3 <-> B2
    if ((self.octave == OCTAVE_THREE) && (self.letter == NOTE_D) && (self.subscoreType == SUBSCORE_TYPE_PIANO))
    {
        return ((OCTAVE_TWO *12) + (NOTE_B));
    }
    
    if ((self.octave == OCTAVE_TWO) && (self.letter == NOTE_B) && (self.subscoreType == SUBSCORE_TYPE_PIANO))
    {
        return ((OCTAVE_THREE *12) + (NOTE_D));
    }
    
    
    //F#2 <-> D#2
    if ((self.octave == OCTAVE_TWO) && (self.letter == NOTE_F_SHARP) && (self.subscoreType == SUBSCORE_TYPE_PIANO))
    {
        return ((OCTAVE_TWO *12) + (NOTE_E_FLAT));
    }
    
    if ((self.octave == OCTAVE_TWO) && (self.letter == NOTE_E_FLAT) && (self.subscoreType == SUBSCORE_TYPE_PIANO))
    {
        return ((OCTAVE_TWO *12) + (NOTE_F_SHARP));
    }
    
    //G#2 <-> G1
    
    if ((self.octave == OCTAVE_TWO) && (self.letter == NOTE_G_SHARP) && (self.subscoreType == SUBSCORE_TYPE_PIANO))
    {
        return ((OCTAVE_ONE *12) + (NOTE_G));
    }
    
    if ((self.octave == OCTAVE_ONE) && (self.letter == NOTE_G) && (self.subscoreType == SUBSCORE_TYPE_PIANO))
    {
        return ((OCTAVE_TWO *12) + (NOTE_G_SHARP));
    }
    
    return ((self.octave * 12) + (self.letter));
}

+ (enum NOTE_LETTER) getLetterForString:(NSString *)noteString
{
    if ([noteString isEqualToString:@""])
    {
        return NOTE_NO_NOTE;
    }
    
    if ([noteString length]>1)
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
        int drumNote = [drumNoteString intValue] - 1;
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
