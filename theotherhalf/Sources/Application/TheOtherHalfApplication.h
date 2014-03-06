//
//  TheOtherHalfApplication.h
//  theotherhalf
//
//  Created by Samuel Défago on 12/02/14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

@interface TheOtherHalfApplication : NSObject

/**
 * Application singleton
 */
+ (instancetype)sharedApplication;

/**
 * Application root view controller
 */
@property (nonatomic, strong) UIViewController *rootViewController;

/**
 * Set the localization
 */
- (void)setLocalization:(NSString *)localization;

/**
 * Display the photo view
 */

- (void)displayPhotoView;

@end
