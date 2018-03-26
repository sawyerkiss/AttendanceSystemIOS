//
//  ScanQRViewController.m
//  AttendanceSystem
//
//  Created by BaoLam on 3/8/18.
//  Copyright © 2018 BaoLam. All rights reserved.
//

#import "ScanQRViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ScanQRViewController()

//@property(nonatomic) MTBBarcodeScanner* scanner;

@property (weak, nonatomic) IBOutlet UIView *viewRect;
@property (weak, nonatomic) IBOutlet UILabel *lblAlert;

@property (nonatomic, strong) ZXCapture *capture;

@end

@implementation ScanQRViewController {
    CGAffineTransform _captureSizeTransform;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Scan QR Code";
    
    self.viewRect.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewRect.layer.borderWidth = 1;
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    
    [self.view.layer addSublayer:self.capture.layer];
    
    [self.view bringSubviewToFront:self.viewRect];
    [self.view bringSubviewToFront:self.lblAlert];
    //    self.scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.capture.delegate = self;
    
    [self applyOrientation];
    //    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
    //        if (success) {
    //
    //            NSError *error = nil;
    //            [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
    //                AVMetadataMachineReadableCodeObject *code = [codes firstObject];
    //                NSLog(@"Found code: %@", code.stringValue);
    //
    //                [self.scanner stopScanning];
    //            } error:&error];
    //
    //        } else {
    //            // The user denied access to the camera
    //        }
    //    }];
    //
    //    self.scanner.didStartScanningBlock = ^{
    //        NSLog(@"The scanner started scanning! We can now hide any activity spinners.");
    //    };
    //
    //    self.scanner.resultBlock = ^(NSArray *codes){
    //        NSLog(@"Found these codes: %@", codes);
    //    };
    //
    //    self.scanner.didTapToFocusBlock = ^(CGPoint point){
    //        NSLog(@"The user tapped the screen to focus. \
    //              Here we could present a view at %@", NSStringFromCGPoint(point));
    //    };
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self applyOrientation];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self applyOrientation];
     }];
}

#pragma mark - Private
- (void)applyOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float scanRectRotation;
    float captureRotation;
    
    switch (orientation) {
            case UIInterfaceOrientationPortrait:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
            case UIInterfaceOrientationLandscapeLeft:
            captureRotation = 90;
            scanRectRotation = 180;
            break;
            case UIInterfaceOrientationLandscapeRight:
            captureRotation = 270;
            scanRectRotation = 0;
            break;
            case UIInterfaceOrientationPortraitUpsideDown:
            captureRotation = 180;
            scanRectRotation = 270;
            break;
        default:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
    }
    [self applyRectOfInterest:orientation];
    CGAffineTransform transform = CGAffineTransformMakeRotation((CGFloat) (captureRotation / 180 * M_PI));
    [self.capture setTransform:transform];
    [self.capture setRotation:scanRectRotation];
    self.capture.layer.frame = self.view.frame;
}

- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation {
    CGFloat scaleVideo, scaleVideoX, scaleVideoY;
    CGFloat videoSizeX, videoSizeY;
    CGRect transformedVideoRect = self.viewRect.frame;
    if([self.capture.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        videoSizeX = 1080;
        videoSizeY = 1920;
    } else {
        videoSizeX = 720;
        videoSizeY = 1280;
    }
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        scaleVideoX = self.view.frame.size.width / videoSizeX;
        scaleVideoY = self.view.frame.size.height / videoSizeY;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeY - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeX - self.view.frame.size.width) / 2;
        }
    } else {
        scaleVideoX = self.view.frame.size.width / videoSizeY;
        scaleVideoY = self.view.frame.size.height / videoSizeX;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeX - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeY - self.view.frame.size.width) / 2;
        }
    }
    _captureSizeTransform = CGAffineTransformMakeScale(1/scaleVideo, 1/scaleVideo);
    self.capture.scanRect = CGRectApplyAffineTransform(transformedVideoRect, _captureSizeTransform);
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
            case kBarcodeFormatAztec:
            return @"Aztec";
            
            case kBarcodeFormatCodabar:
            return @"CODABAR";
            
            case kBarcodeFormatCode39:
            return @"Code 39";
            
            case kBarcodeFormatCode93:
            return @"Code 93";
            
            case kBarcodeFormatCode128:
            return @"Code 128";
            
            case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
            case kBarcodeFormatEan8:
            return @"EAN-8";
            
            case kBarcodeFormatEan13:
            return @"EAN-13";
            
            case kBarcodeFormatITF:
            return @"ITF";
            
            case kBarcodeFormatPDF417:
            return @"PDF417";
            
            case kBarcodeFormatQRCode:
            return @"QR Code";
            
            case kBarcodeFormatRSS14:
            return @"RSS 14";
            
            case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
            case kBarcodeFormatUPCA:
            return @"UPCA";
            
            case kBarcodeFormatUPCE:
            return @"UPCE";
            
            case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    
    CGAffineTransform inverse = CGAffineTransformInvert(_captureSizeTransform);
    NSMutableArray *points = [[NSMutableArray alloc] init];
    NSString *location = @"";
    for (ZXResultPoint *resultPoint in result.resultPoints) {
        CGPoint cgPoint = CGPointMake(resultPoint.x, resultPoint.y);
        CGPoint transformedPoint = CGPointApplyAffineTransform(cgPoint, inverse);
        transformedPoint = [self.viewRect convertPoint:transformedPoint toView:self.viewRect.window];
        NSValue* windowPointValue = [NSValue valueWithCGPoint:transformedPoint];
        location = [NSString stringWithFormat:@"%@ (%f, %f)", location, transformedPoint.x, transformedPoint.y];
        [points addObject:windowPointValue];
    }
    
    
    // We got a result. Display information about the result onscreen.
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@\nLocation: %@", formatString, result.text, location];
    //    [self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
    
    [self verifyQRCodeWithURL:result.text];
    
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self.capture stop];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.capture start];
    });
}

- (void)verifyQRCodeWithURL:(NSString*)url {
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    bool valid = [NSURLConnection canHandleRequest:req];
    NSLog(@"url : %@",url);
    
    if(valid)
    {
        [self showLoadingView];
        
        [[ConnectionManager connectionDefault] checkAttendanceByQRCodeWithURL:url success:^(id  _Nonnull responseObject) {
            [self hideLoadingView];
            
            if([responseObject[@"result"] isEqualToString:@"failure"])
            {
                NSString* error = responseObject[@"message"];
                [self showAlertNoticeWithMessage:error completion:nil];
                return;
            }
            
            [super tappedAtLeftButton:nil];
            
        } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
            [self hideLoadingView];
            
            [self showAlertNoticeWithMessage:errorMessage completion:nil];
        }];
    }
    else {
         [self showAlertNoticeWithMessage:@"QR code is invalid. Please scan QR code again" completion:nil];
    }
    
}


@end
