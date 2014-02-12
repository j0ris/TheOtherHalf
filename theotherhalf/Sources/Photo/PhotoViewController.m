//
//  PhotoViewController.m
//  theotherhalf
//
//  Created by Joris Heuberger on 11.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;

@end

@implementation PhotoViewController

#pragma mark Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    return [super supportedInterfaceOrientations] & UIInterfaceOrientationMaskPortrait;
}

#pragma mark Actions

- (IBAction)takePhoto:(id)sender
{
}

- (IBAction)choosePhoto:(id)sender
{
}

@end
