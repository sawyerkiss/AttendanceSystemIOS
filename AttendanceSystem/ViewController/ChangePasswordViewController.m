//
//  ChangePasswordViewController.m
//  AttendanceSystem
//
//  Created by BaoLam on 3/8/18.
//  Copyright © 2018 BaoLam. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <MaterialControls/MDTextField.h>
#import "BEMCheckBox.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet MDTextField *tfCurrentPassword;
@property (weak, nonatomic) IBOutlet MDTextField *tfNewPassword;
@property (weak, nonatomic) IBOutlet BEMCheckBox *cboxShowPassword;


@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Change Password";
    self.tfCurrentPassword.secureTextEntry = TRUE;
    self.tfNewPassword.secureTextEntry = TRUE;
    self.cboxShowPassword.boxType = BEMBoxTypeSquare;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchChangePassword:(id)sender {
    [self showLoadingView] ;
    
    [[ConnectionManager connectionDefault] changePasswordWithCurrentPassword:self.tfCurrentPassword.text newPassword:self.tfNewPassword.text success:^(id  _Nonnull responseObject) {
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


- (IBAction)didTouchCancelPassword:(id)sender {
    [super tappedAtLeftButton:sender];
}


- (IBAction)didChangeShowPassword:(id)sender {
    
    self.tfCurrentPassword.secureTextEntry = !self.tfCurrentPassword.secureTextEntry;
    self.tfNewPassword.secureTextEntry = !self.tfNewPassword.secureTextEntry;
    
}

@end
