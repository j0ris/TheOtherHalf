//
//  PhotoViewController.m
//  theotherhalf
//
//  Created by Joris Heuberger on 11.02.14.
//  Copyright (c) 2014 The Other Half. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, weak) IBOutlet UIButton *choosePhotoButton;

@end

@implementation PhotoViewController {
    CATransform3D _initialTransform;                    // Initial transform when a gesture begins
    CGPoint _currentTranslation;
    CGFloat _currentScale;
    CGFloat _currentRotation;
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
    
    self.photoImageView.image = [UIImage imageWithColor:[UIColor colorWithNonNormalizedRed:38.f green:41.f blue:39.f alpha:1.f]];
    
    // Mask
	NSString *maskName = [NSString stringWithFormat:@"mask-%@.png", [NSBundle localization]];
	UIImage *maskImage = [UIImage imageNamed:maskName];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.photoImageView.bounds;
    maskLayer.contents = (id)maskImage.CGImage;
    self.photoImageView.layer.mask = maskLayer;
    
    self.photoImageView.image = [UIImage imageWithColor:[UIColor redColor]];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
    panGestureRecognizer.delegate = self;
    [self.photoImageView addGestureRecognizer:panGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    pinchGestureRecognizer.delegate = self;
    [self.photoImageView addGestureRecognizer:pinchGestureRecognizer];
    
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    rotationGestureRecognizer.delegate = self;
    [self.photoImageView addGestureRecognizer:rotationGestureRecognizer];
    
    self.photoImageView.userInteractionEnabled = YES;
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
    CATransform3D currentTranslationTransform = CATransform3DMakeTranslation(_currentTranslation.x, _currentTranslation.y, 0.f);
    CATransform3D currentScaleTransform = CATransform3DMakeScale(_currentScale, _currentScale, 1.f);
    CATransform3D currentRotationTransform = CATransform3DMakeRotation(_currentRotation, 0.f, 0.f, 1.f);
    
    CATransform3D currentTransform = CATransform3DConcat(currentRotationTransform, currentScaleTransform);
    currentTransform = CATransform3DConcat(currentTranslationTransform, currentTransform);
    self.photoImageView.layer.transform = CATransform3DConcat(currentTransform, _initialTransform);
}

#pragma mark UIGestureRecognizerDelegate protocol implementation

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    _initialTransform = self.photoImageView.layer.transform;
    
    _currentTranslation = CGPointZero;
    _currentScale = 1.f;
    _currentRotation = 0.f;
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // It is much more intuitive to be able to rotate and scale simultaneously
    return YES;
}

#pragma mark UIImagePickerControllerDelegate protocol implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.photoImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
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

- (void)rotateImage:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    _currentRotation = rotationGestureRecognizer.rotation;
    [self updateImage];
}

@end
