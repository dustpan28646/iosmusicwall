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
    NOTE_A = 0,
    NOTE_B_FLAT = 1,
    NOTE_B = 2,
    NOTE_C = 3,
    NOTE_C_SHARP = 4,
    NOTE_D = 5,
    NOTE_E_FLAT = 6,
    NOTE_E = 7,
    NOTE_F = 8,
    NOTE_F_SHARP = 9,
    NOTE_G = 10,
    NOTE_G_SHARP = 11,
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

enum SUBSCORE_TYPE
{
    SUBSCORE_TYPE_GUITAR = 0,
    SUBSCORE_TYPE_PIANO = 1,
    SUBSCORE_TYPE_DRUM = 2
};

@interface SubscoreNote : NSObject
{
}

@property (nonatomic) enum NOTE_OCTAVE octave;
@property (nonatomic) enum NOTE_LETTER letter;
@property (nonatomic) enum SUBSCORE_TYPE subscoreType;

- (id) initWithOctave:(enum NOTE_OCTAVE)noteOctave withLetter:(enum NOTE_LETTER)noteLetter withSubscoreName:(NSString *)subscoreName;

- (id) initWithNoteString:(NSString *)noteString withSubscoreName:(NSString *)subscoreName;

- (int) getIntegerIndexForNote;

+ (enum NOTE_OCTAVE) getOctaveForString:(NSString *)noteString;

+ (enum NOTE_LETTER) getLetterForString:(NSString *)noteString;

@end
