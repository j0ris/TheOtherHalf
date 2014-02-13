//
//  TextViewController.m
//  theotherhalf
//
//  Created by Joris Heuberger on 13.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "TextViewController.h"
#import "TheOtherHalfApplication.h"

@interface TextViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation TextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	NSString *htmlFileName = [NSString stringWithFormat:@"presentation-%@", [NSBundle localization]];
	NSString *htmlFile = [[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"html"];
	NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];

	[self.webView loadHTMLString:htmlString baseURL:baseURL];
}

- (IBAction)close:(id)sender
{
	[[TheOtherHalfApplication sharedApplication] displayPhotoView];
}

@end
