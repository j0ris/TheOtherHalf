//
//  TheOtherHalfApplication.m
//  theotherhalf
//
//  Created by Samuel Défago on 12/02/14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "TheOtherHalfApplication.h"

#import "LanguageViewController.h"
#import "TextViewController.h"
#import "PhotoViewController.h"

@interface TheOtherHalfApplication ()

@property (nonatomic, strong) HLSStackController *stackController;

@end

@implementation TheOtherHalfApplication

#pragma mark Class methods

+ (instancetype)sharedApplication
{
    static TheOtherHalfApplication *s_sharedApplication;
    static dispatch_once_t s_onceToken;
    dispatch_once(&s_onceToken, ^{
        s_sharedApplication = [[TheOtherHalfApplication alloc] init];
    });
    return s_sharedApplication;
}

#pragma mark Accessors and mutators

- (UIViewController *)rootViewController
{
    if (! self.stackController) {
        LanguageViewController *languageViewController = [[LanguageViewController alloc] init];
        self.stackController = [[HLSStackController alloc] initWithRootViewController:languageViewController];
        
        [self displayTextView];
    }
    return self.stackController;
}

- (void)setLocalization:(NSString *)localization
{
    NSAssert([[[NSBundle mainBundle] localizations] indexOfObject:localization] != NSNotFound, @"Localization must be found in the main bundle");
    [NSBundle setLocalization:localization];
    
    [self displayTextView];
}

- (void)displayTextView
{
    TextViewController *textViewController = [[TextViewController alloc] init];
    [self.stackController pushViewController:textViewController withTransitionClass:[HLSTransitionPushFromRight class] animated:YES];
}

- (void)displayPhotoView
{
    PhotoViewController *photoViewController = [[PhotoViewController alloc] init];
    [self.stackController pushViewController:photoViewController withTransitionClass:[HLSTransitionPushFromRight class] animated:YES];
}

@end
