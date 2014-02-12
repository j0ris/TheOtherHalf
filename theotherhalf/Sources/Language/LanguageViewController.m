//
//  LanguageViewController.m
//  theotherhalf
//
//  Created by Joris Heuberger on 11.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "LanguageViewController.h"

@implementation LanguageViewController

#pragma mark Actions

- (IBAction)setGerman:(id)sender
{
    [NSBundle setLocalization:@"de"];
}

- (IBAction)setFrench:(id)sender
{
    [NSBundle setLocalization:@"fr"];
}

- (IBAction)setItalian:(id)sender
{
    [NSBundle setLocalization:@"it"];
}

- (IBAction)setEnglish:(id)sender
{
    [NSBundle setLocalization:@"en"];
}

@end
