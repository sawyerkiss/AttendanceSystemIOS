//
//  CustomNavigationController.h
//  AttendanceSystem
//
//  Created by TamTran on 1/25/18.
//  Copyright © 2018 TamTran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationController : UINavigationController<UIGestureRecognizerDelegate>

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender;

@end
