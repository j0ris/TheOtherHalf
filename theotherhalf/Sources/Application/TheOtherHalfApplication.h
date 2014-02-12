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
 * Display the photo screen. The localization is mandatory
 */
- (void)displayPhotoViewWithLocalization:(NSString *)localization;

@end
