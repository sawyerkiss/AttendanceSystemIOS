//
//  SendAbsenceViewController.m
//  AttendanceSystem
//
//  Created by BaoLam on 3/15/18.
//  Copyright © 2018 BaoLam. All rights reserved.
//

#import "SendAbsenceViewController.h"
#import <MaterialControls/MDTextField.h>
#import "DateViewController.h"

static NSString* kDateFormat = @"dd-MM-yyyy";

@interface SendAbsenceViewController()
@property (weak, nonatomic) IBOutlet MDTextField *tfReason;
@property (weak, nonatomic) IBOutlet UIButton *buttonFromDate;
@property (weak, nonatomic) IBOutlet UIButton *buttonToDate;

@property (nonatomic) NSDate *fromDate;
@property (nonatomic) NSDate *toDate;

@end


@implementation SendAbsenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SEND ABSENCE REQUEST";
    
    self.fromDate = [NSDate date];
    self.toDate = [NSDate date];
 
}
- (IBAction)didTouchSendButton:(id)sender {
    
    if(self.tfReason.text && self.tfReason.text.length == 0) {
        [self showAlertNoticeWithMessage:@"Missing Reason" completion:nil];
        return;
    }
    
    if(self.toDate.timeIntervalSince1970 < self.fromDate.timeIntervalSince1970){
        [self showAlertNoticeWithMessage:@"To Date must be greater than From Date" completion:nil];
        return;
    }
    
    [self showLoadingView];
    
    [[ConnectionManager connectionDefault] sendAbsenceRequestWithReason:self.tfReason.text startDate:self.buttonFromDate.titleLabel.text endDate:self.buttonToDate.titleLabel.text success:^(id  _Nonnull responseObject) {
        [self hideLoadingView];
        [self tappedAtLeftButton:nil];
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
}

- (IBAction)didTouchFromDate:(id)sender {
    
    [DateViewController showDateTimeSelectionWithView:self.navigationController
                                                 date:self.fromDate
                                           miniumDate:[NSDate date]
                                           completion:^(NSDate *result) {
        if(result){
        self.fromDate = result;
        NSString* fromDateText = [self stringFromDateWithFormat:kDateFormat date:self.fromDate];
        [self.buttonFromDate setTitle:fromDateText forState:UIControlStateNormal];
        }
    }];
    
    
}

- (IBAction)didTouchToDate:(id)sender {
    
    [DateViewController showDateTimeSelectionWithView:self.navigationController
                                                 date:self.toDate
                                           miniumDate:self.fromDate
                                           completion:^(NSDate *result) {
        if(result) {
        self.toDate = result;
        NSString* toDateText = [self stringFromDateWithFormat:kDateFormat date:self.toDate];
        [self.buttonToDate setTitle:toDateText forState:UIControlStateNormal];
        }
    }];
    
}

- (NSString *)stringFromDateWithFormat:(NSString *)dateFormat date:(NSDate*)date{
    NSDateFormatter *formatter = [NSDateFormatter new];
//    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.dateFormat = dateFormat;
    
    return [formatter stringFromDate:date];
}

@end
