//
//  DateViewController.h
//  AttendanceSystem
//
//  Created by BaoLam on 3/15/18.
//  Copyright © 2018 BaoLam. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^DateTimeSelectionCompletion)(NSDate *result);

@interface DateViewController : BaseViewController

+ (void)showDateTimeSelectionWithView:(UINavigationController *)controller
                               date:(NSDate *)date
                           miniumDate:(NSDate *)miniumDate
                         completion:(DateTimeSelectionCompletion)completion;


@end
