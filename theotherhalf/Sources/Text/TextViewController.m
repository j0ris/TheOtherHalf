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

    [self.webView makeBackgroundTransparent];
    self.webView.shadowHidden = YES;
	[self.webView fadeTop:0.1 bottom:0.1];
	
	NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"presentation" ofType:@"html"];
	NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
	[self.webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (IBAction)close:(id)sender
{
	[[TheOtherHalfApplication sharedApplication] displayPhotoView];
}

@end
