//
//  DateViewController.m
//  AttendanceSystem
//
//  Created by BaoLam on 3/15/18.
//  Copyright © 2018 BaoLam. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (nonatomic, copy) DateTimeSelectionCompletion completion;

@property (nonatomic) NSDate *date ;
@property (nonatomic) NSDate *miniumDate;

@end

@implementation DateViewController

+ (void)showDateTimeSelectionWithView:(UINavigationController *)controller
                               date:(NSDate *)date
                           miniumDate:(NSDate *)miniumDate
                         completion:(DateTimeSelectionCompletion)completion {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DateViewController *dateTimeView = [storyboard instantiateViewControllerWithIdentifier:@"DateViewController"];
    dateTimeView.date = date;
    dateTimeView.miniumDate = miniumDate;
//    [dateTimeView.buttonDone addTarget:dateTimeView action:@selector(didTouchDoneButton:) forControlEvents:UIControlEventTouchUpInside];
//    [dateTimeView.buttonCancel addTarget:dateTimeView action:@selector(didTouchCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    if (completion) {
        dateTimeView.completion = completion;
    }
//    [view addSubview:dateTimeView.view];
    [controller pushViewController:dateTimeView animated:FALSE];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.datePicker.minimumDate = self.miniumDate;
    self.datePicker.date = self.date;
    self.buttonCancel.layer.borderWidth = 1;
    self.buttonCancel.layer.borderColor = [UIColor grayColor].CGColor;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchDoneButton:(id)sender {
    
//    [self.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:FALSE];
    if (self.completion) {
        self.completion(self.datePicker.date);
    }
    
}

- (IBAction)didTouchCancelButton:(id)sender {
    
//    [self.view removeFromSuperview];
     [self.navigationController popViewControllerAnimated:FALSE];
    if (self.completion) {
        self.completion(nil);
    }
    
}
@end
