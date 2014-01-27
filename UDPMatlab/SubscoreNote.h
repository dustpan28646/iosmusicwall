//
//  SubscoreNote.h
//  UDPMatlab
//
//  Created by Matthew Rice on 1/27/14.
//  Copyright (c) 2014 Matthew Rice. All rights reserved.
//

#import <Foundation/Foundation.h>

enum NOTE_OCTAVE
{
    OCTAVE_ZERO = 0,
    OCTAVE_ONE = 1,
    OCTAVE_TWO = 2,
    OCTAVE_THREE = 3,
    DRUM_NOTE_OCTAVE = 4,
    OCTAVE_NO_NOTE = 10
};

enum NOTE_LETTER
{
    NOTE_G = 0,
    NOTE_G_SHARP = 1,
    NOTE_A = 2,
    NOTE_B_FLAT = 3,
    NOTE_B = 4,
    NOTE_C = 5,
    NOTE_C_SHARP = 6,
    NOTE_D = 7,
    NOTE_E_FLAT = 8,
    NOTE_E = 9,
    NOTE_F = 10,
    NOTE_F_SHARP = 11,
    NOTE_NO_NOTE = 100
};

enum DRUM_NOTES
{
    DRUM_NOTE_ZERO = 0,
    DRUM_NOTE_ONE = 1,
    DRUM_NOTE_TWO = 2,
    DRUM_NOTE_THREE = 3,
    DRUM_NOTE_FOUR = 4
};

@interface SubscoreNote : NSObject

@property (nonatomic) enum NOTE_OCTAVE octave;
@property (nonatomic) enum NOTE_LETTER letter;

- (id) initWithOctave:(enum NOTE_OCTAVE)noteOctave withLetter:(enum NOTE_LETTER)noteLetter;

- (id) initWithNoteString:(NSString *)noteString;

- (int) getIntegerIndexForNote;

+ (enum NOTE_OCTAVE) getOctaveForString:(NSString *)noteString;

+ (enum NOTE_LETTER) getLetterForString:(NSString *)noteString;

@end
