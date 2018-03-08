//
//  ScanQRViewController.h
//  AttendanceSystem
//
//  Created by BaoLam on 3/8/18.
//  Copyright © 2018 BaoLam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <ZXingObjC/ZXingObjC.h>

@interface ScanQRViewController : BaseViewController<ZXCaptureDelegate>

@end
