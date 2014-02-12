//
//  LanguageViewController.m
//  theotherhalf
//
//  Created by Joris Heuberger on 11.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "LanguageViewController.h"

#import "TheOtherHalfApplication.h"

@implementation LanguageViewController

#pragma mark Actions

- (IBAction)setGerman:(id)sender
{
    [[TheOtherHalfApplication sharedApplication] displayPhotoViewWithLocalization:@"de"];
}

- (IBAction)setFrench:(id)sender
{
    [[TheOtherHalfApplication sharedApplication] displayPhotoViewWithLocalization:@"fr"];
}

- (IBAction)setItalian:(id)sender
{
    [[TheOtherHalfApplication sharedApplication] displayPhotoViewWithLocalization:@"it"];
}

- (IBAction)setEnglish:(id)sender
{
    [[TheOtherHalfApplication sharedApplication] displayPhotoViewWithLocalization:@"en"];
}

@end
