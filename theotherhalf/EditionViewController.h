//
//  EditionViewController.h
//  theotherhalf
//
//  Created by Joris Heuberger on 11.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditionViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *photoView;
@property (nonatomic, retain) IBOutlet UIImageView *maskView;

- (IBAction)takePhoto:(id)sender;
- (IBAction)choosePhoto:(id)sender;

@end
