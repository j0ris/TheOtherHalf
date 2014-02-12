//
//  LanguageViewController.m
//  theotherhalf
//
//  Created by Joris Heuberger on 11.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "LanguageViewController.h"

@implementation LanguageViewController

#pragma mark Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    return [super supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortrait;
}

#pragma mark Actions

- (IBAction)setGerman:(id)sender
{
}

- (IBAction)setFrench:(id)sender
{
}

- (IBAction)setItalian:(id)sender
{
}

- (IBAction)setEnglish:(id)sender
{
}

@end
