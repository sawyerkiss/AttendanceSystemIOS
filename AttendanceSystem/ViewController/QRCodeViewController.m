//
//  QRCodeViewController.m
//  AttendanceSystem
//
//  Created by BaoLam on 3/8/18.
//  Copyright © 2018 BaoLam. All rights reserved.
//

#import "QRCodeViewController.h"
#import <ZXingObjC/ZXingObjC.h>

@interface QRCodeViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imgQRCode;

@end

@implementation QRCodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"QR Code";
    
    NSString *data = [[ConnectionManager connectionDefault] getQRCodeText:self.course.attendance_id];
    
    if (data == 0) return;
    
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:data
                                  format:kBarcodeFormatQRCode
                                   width:self.imgQRCode.frame.size.width
                                  height:self.imgQRCode.frame.size.width
                                   error:nil];
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        self.imgQRCode.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        self.imgQRCode.image = nil;
    }
    
}

- (IBAction)didTouchReturnButton:(id)sender {
    
    [super tappedAtLeftButton:sender];
}
@end
