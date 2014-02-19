//
//  PhotoViewController.m
//  theotherhalf
//
//  Created by Joris Heuberger on 11.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "PhotoViewController.h"
#import <Social/Social.h>

CGRect rectCenteredInRect(CGRect rect, CGRect mainRect)
{
	return CGRectOffset(rect, CGRectGetMidX(mainRect)-CGRectGetMidX(rect), CGRectGetMidY(mainRect)-CGRectGetMidY(rect));
}

@interface PhotoViewController ()

@property (nonatomic, weak) IBOutlet UIView *buttonsPlaceholderView;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) IBOutlet UIView *photoButtonsView;
@property (nonatomic, weak) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, weak) IBOutlet UIButton *choosePhotoButton;
@property (nonatomic, weak) IBOutlet UIView *sharingButtonsView;

@end

@implementation PhotoViewController {
    CGRect _initialFrame;
    CGPoint _currentTranslation;
    CGFloat _currentScale;
}

#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.takePhotoButton.hidden = YES;
    }
    if (! [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.choosePhotoButton.hidden = YES;
    }
    
    // Gesture recognizers. Meant to move the image sublayer
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
    panGestureRecognizer.delegate = self;
    [self.photoImageView addGestureRecognizer:panGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    pinchGestureRecognizer.delegate = self;
    [self.photoImageView addGestureRecognizer:pinchGestureRecognizer];
    
    self.photoImageView.userInteractionEnabled = YES;
	
	// Action buttons
	[self.buttonsPlaceholderView addSubview:self.photoButtonsView];
	[self.buttonsPlaceholderView addSubview:self.sharingButtonsView];
	self.sharingButtonsView.hidden = YES;
}

#pragma mark Helpers

- (void)displayImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)updateImage
{
    // Convert in the coordinate system of the view so that scaling applies from the center, not from the upper left angle
    CGAffineTransform centerTransform = CGAffineTransformMakeTranslation(-self.photoImageView.center.x, -self.photoImageView.center.y);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(_currentScale, _currentScale);
    CGAffineTransform convScaleTransform = CGAffineTransformConcat(CGAffineTransformConcat(centerTransform, scaleTransform),
                                                               CGAffineTransformInvert(centerTransform));
    
    CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(_currentTranslation.x, _currentTranslation.y);
    CGAffineTransform transform = CGAffineTransformConcat(convScaleTransform, translationTransform);
    
    self.photoImageView.frame = CGRectApplyAffineTransform(_initialFrame, transform);
}

#pragma mark UIGestureRecognizerDelegate protocol implementation

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    _initialFrame = self.photoImageView.frame;
    
    _currentTranslation = CGPointZero;
    _currentScale = 1.f;
    
    return YES;
}

#pragma mark UIImagePickerControllerDelegate protocol implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	CGRect viewBounds = self.photoImageView.bounds;
	CGSize imageSize = image.size;
	CGFloat scale = (imageSize.height>imageSize.width) ? CGRectGetHeight(viewBounds)/imageSize.height : CGRectGetWidth(viewBounds)/imageSize.width;
	CGRect frame = CGRectMake(0.0, 0.0, imageSize.width * scale, imageSize.height * scale);
	frame = rectCenteredInRect(frame, viewBounds);
	
	self.photoImageView.transform = CGAffineTransformIdentity;
	self.photoImageView.frame = frame;
    self.photoImageView.image = image;
	
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Actions

- (IBAction)goToWebSite:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.theotherhalf.ch"]];
}

- (IBAction)changeLanguage:(id)sender
{
    [self.stackController popToRootViewControllerAnimated:YES];
}

- (IBAction)takePhoto:(id)sender
{
    [self displayImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)choosePhoto:(id)sender
{
    [self displayImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)validate:(id)sender
{
	self.sharingButtonsView.hidden = NO;
	self.photoButtonsView.hidden = YES;
}

- (UIImage *)maskedImage
{
	return nil;
}

- (IBAction)shareOnFacebook:(id)sender
{
	[self shareOnServiceType:SLServiceTypeFacebook];
}

- (IBAction)shareOnTwitter:(id)sender
{
	[self shareOnServiceType:SLServiceTypeTwitter];
}

- (void)shareOnServiceType:(NSString*)serviceType
{
	BOOL shouldComposeMessage = NO;
	if ([SLComposeViewController isAvailableForServiceType:serviceType])
	{
		shouldComposeMessage = YES;
	}
	else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
	{
		shouldComposeMessage = YES;
	}
	
	if(shouldComposeMessage)
	{
		SLComposeViewController *messageSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
		[messageSheet setInitialText:NSLocalizedString(@"I am the other half.", @"Default message content for sharing")];
		[messageSheet addImage:[self maskedImage]];
		[messageSheet addURL:[NSURL URLWithString:@"http://theotherhalf.ch"]];
		[self presentViewController:messageSheet animated:YES completion:nil];
	}
}

- (IBAction)saveToCameraRoll:(id)sender
{
	UIImageWriteToSavedPhotosAlbum([self maskedImage], nil, nil, nil);
}

#pragma mark Gesture recognizers

- (void)panImage:(UIPanGestureRecognizer *)panGestureRecognizer
{
    _currentTranslation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    [self updateImage];
}

- (void)pinchImage:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    _currentScale = pinchGestureRecognizer.scale;
    [self updateImage];
}

@end
