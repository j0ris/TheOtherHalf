//
//  PhotoViewController.m
//  theotherhalf
//
//  Created by Joris Heuberger on 11.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "PhotoViewController.h"

#import "WBSuccessNoticeView.h"
#import <Social/Social.h>

@interface PhotoViewController ()

@property (nonatomic, weak) IBOutlet UIView *buttonsPlaceholderView;
@property (nonatomic, weak) IBOutlet UIView *photoPlaceholderView;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) IBOutlet UIImageView *maskImageView;
@property (nonatomic, weak) IBOutlet UIView *photoButtonsView;
@property (nonatomic, weak) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, weak) IBOutlet UIButton *choosePhotoButton;
@property (nonatomic, weak) IBOutlet UIView *sharingButtonsView;

@property (nonatomic, strong) NSArray *gestureRecognizers;

@end

@implementation PhotoViewController {
    CGRect _initialFrame;
    CGPoint _currentTranslation;
    CGFloat _currentScale;
}

#pragma mark View lifecycle

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetImage:)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.photoImageView addGestureRecognizer:tapGestureRecognizer];
    
    self.gestureRecognizers = @[panGestureRecognizer, pinchGestureRecognizer];
    
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImageView.userInteractionEnabled = YES;
    
    self.photoPlaceholderView.clipsToBounds = YES;
    
    // Action buttons
    [self.buttonsPlaceholderView addSubview:self.photoButtonsView];
    [self.buttonsPlaceholderView addSubview:self.sharingButtonsView];
    self.sharingButtonsView.alpha = 0.f;
}

#pragma mark Localization

- (void)localize
{
    [super localize];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"mask-overlay" ofType:@"png"];
    self.maskImageView.image = [UIImage imageWithContentsOfFile:imagePath];
}

#pragma mark Helpers

- (void)displayImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)updateImageForScale:(BOOL)isScale
{
    // Convert in the coordinate system of the view so that scaling applies from the center, not from the upper left angle
    CGAffineTransform centerTransform = CGAffineTransformMakeTranslation(-self.photoImageView.center.x, -self.photoImageView.center.y);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(_currentScale, _currentScale);
    CGAffineTransform convScaleTransform = CGAffineTransformConcat(CGAffineTransformConcat(centerTransform, scaleTransform),
                                                                   CGAffineTransformInvert(centerTransform));
    
    CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(_currentTranslation.x, _currentTranslation.y);
    CGAffineTransform transform = CGAffineTransformConcat(convScaleTransform, translationTransform);
    
    CGRect frame = CGRectApplyAffineTransform(_initialFrame, transform);
    
    // If the mask covers the new frame, apply the frame. Only takes the left half of the mask into account (where most of the
    // photo appears), so that photos with subject on the right can be displayed properly
    CGRect maskOptimalFrame = CGRectMake(0.f,
                                         0.f,
                                         roundf(CGRectGetWidth(self.photoPlaceholderView.bounds) / 2.f),
                                         CGRectGetHeight(self.photoPlaceholderView.bounds));
    if (CGRectContainsRect(frame, maskOptimalFrame)) {
        self.photoImageView.frame = frame;
    }
    // Reset with an animation (cancel the regonizer(
    else if (isScale) {
        for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
            gestureRecognizer.enabled = NO;
            gestureRecognizer.enabled = YES;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.photoImageView.frame = self.photoPlaceholderView.bounds;
        }];
    }
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
    
    self.photoImageView.image = image;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UINavigationControllerDelegate protocol implementation

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // Fix issues with the status bar color when the image picker is displayed
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

#pragma mark Actions Buttons

- (void)setSharingInterfaceHidden:(BOOL)hidden
{
    self.photoImageView.userInteractionEnabled = hidden;
    
    [UIView animateWithDuration:0.4f animations:^{
        self.sharingButtonsView.alpha = hidden ? 0.f : 1.f;
        self.photoButtonsView.alpha = hidden ? 1.f : 0.f;
    }];
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
    [self setSharingInterfaceHidden:NO];
}

- (UIImage *)maskedImage
{
    UIGraphicsBeginImageContextWithOptions(self.photoPlaceholderView.bounds.size, NO, 0.f);
    [self.photoPlaceholderView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)shareOnFacebook:(id)sender
{
    [self shareOnServiceType:SLServiceTypeFacebook];
}

- (IBAction)shareOnTwitter:(id)sender
{
    [self shareOnServiceType:SLServiceTypeTwitter];
}

- (void)shareOnServiceType:(NSString *)serviceType
{
    BOOL shouldComposeMessage = NO;
    if ([SLComposeViewController isAvailableForServiceType:serviceType]) {
        shouldComposeMessage = YES;
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        shouldComposeMessage = YES;
    }
    
    if (shouldComposeMessage) {
        SLComposeViewController *messageSheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [messageSheet setInitialText:NSLocalizedString(@"We are the other half. #wearetheotherhalf", @"Default message content for sharing")];
        [messageSheet addImage:[self maskedImage]];
        [messageSheet addURL:[NSURL URLWithString:@"http://theotherhalf.ch"]];
        [self presentViewController:messageSheet animated:YES completion:nil];
    }
}

- (IBAction)saveToCameraRoll:(id)sender
{
    UIImageWriteToSavedPhotosAlbum([self maskedImage], nil, nil, nil);
    
    WBSuccessNoticeView *successNoticeView = [WBSuccessNoticeView successNoticeInView:self.view title:NSLocalizedString(@"Saved to Camera Roll", nil)];
    [successNoticeView show];
}

#pragma mark Gesture recognizers

- (void)panImage:(UIPanGestureRecognizer *)panGestureRecognizer
{
    _currentTranslation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    [self updateImageForScale:NO];
}

- (void)pinchImage:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    _currentScale = pinchGestureRecognizer.scale;
    [self updateImageForScale:YES];
}

- (void)resetImage:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [UIView animateWithDuration:0.2 animations:^{
        self.photoImageView.frame = self.photoPlaceholderView.bounds;
    }];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        [self resetImage:nil];
        self.photoImageView.image = nil;
        [self setSharingInterfaceHidden:YES];
    }
}

@end
