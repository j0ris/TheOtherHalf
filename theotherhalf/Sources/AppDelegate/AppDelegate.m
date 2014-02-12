//
//  AppDelegate.m
//  theotherhalf
//
//  Created by Joris Heuberger on 11.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "AppDelegate.h"

#import "LanguageViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[LanguageViewController alloc] init];
    
    return YES;
}

@end
