//
//  LanguageViewController.m
//  theotherhalf
//
//  Created by Joris Heuberger on 11.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "LanguageViewController.h"

#import "PhotoViewController.h"

@implementation LanguageViewController

#pragma mark Helpers

- (void)displayPhotoViewWithLocalization:(NSString *)localization
{
    NSAssert([[[NSBundle mainBundle] localizations] indexOfObject:localization] != NSNotFound, @"Localization must be found in the main bundle");
    
    [NSBundle setLocalization:localization];
    
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    [self.stackController pushViewController:photoViewController withTransitionClass:[HLSTransitionFlowFromRight class] animated:YES];
}

#pragma mark Actions

- (IBAction)setGerman:(id)sender
{
    [self displayPhotoViewWithLocalization:@"de"];
}

- (IBAction)setFrench:(id)sender
{
    [self displayPhotoViewWithLocalization:@"fr"];
}

- (IBAction)setItalian:(id)sender
{
    [self displayPhotoViewWithLocalization:@"it"];
}

- (IBAction)setEnglish:(id)sender
{
    [self displayPhotoViewWithLocalization:@"en"];
}

@end
