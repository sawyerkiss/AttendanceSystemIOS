//
//  LoginViewController.m
//  AttendanceSystem
//
//  Created by TrungTruc on 1/24/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "LoginViewController.h"
#import <MaterialControls/MDTextField.h>
#import "LoadingManager.h"
#import "HomeViewController.h"
#import "ConnectionManager.h"

@interface LoginViewController ()<MDTextFieldDelegate>
@property (weak, nonatomic) IBOutlet MDTextField *tfEmail;
@property (weak, nonatomic) IBOutlet MDTextField *tfPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    MDTextField *textField = [[MDTextField alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    //    textField.delegate = self;
    //    textField.singleLine = true;
    //    textField.maxCharacterCount = 30;
    //    textField.errorMessage = @"Wrong password";
    //    textField.errorColor = [UIColor redColor];
    //    textField.secureTextEntry = true;
    //    textField.label = @"Email";
    //    textField.floatingLabel = true;
    //    [self.tfEmail addSubview:textField];
    //    [self.tfEmail layoutIfNeeded];
    self.tfEmail.text = @"";
    self.tfPassword.text = @"";
    [self.tfPassword setSecureTextEntry:TRUE];
    [self.tfPassword layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTouchLogin:(id)sender {
    [self.view endEditing:TRUE];
    [LoadingManager showLoadingViewInView:self.view];
    
    NSString* userName = self.tfEmail.text;
    NSString* password = self.tfPassword.text;
    
    [[ConnectionManager connectionDefault] login:userName password:password andSuccess:^(id  _Nonnull responseObject) {
        [LoadingManager hideLoadingViewForView:self.view];
        
        NSString* token = responseObject[@"token"];
        [[UserManager userCenter] setCurrentUserToken:token];
        UserModel* user = [[UserModel alloc] initWithDictionary:responseObject[@"user"] error:nil];
        [[UserManager userCenter] setCurrentUser:user];
        

        ////////////////////////
        HomeViewController* homeController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self presentViewController:homeController animated:TRUE completion:nil];
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [LoadingManager hideLoadingViewForView:self.view];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
        
        [_tfEmail setErrorMessage:@"Email is empty"];
        [_tfPassword setErrorMessage:@"Password is empty"];
        [_tfEmail setErrorColor:[UIColor redColor]];
        [_tfPassword setErrorColor:[UIColor redColor]];
    }];
    
}


- (IBAction)didTouchForgotPassword:(id)sender {
    
    // use UIAlertController
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Submit your email address"
                               message:nil
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Request" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   //Do Some action here
                                                   UITextField *textField = alert.textFields[0];
                                                   NSLog(@"text was %@", textField.text);
                                                   
                                                   [self requestForgetPasswordWithEmail:textField.text];
                                                   
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       NSLog(@"cancel btn");
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email";
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (void)requestForgetPasswordWithEmail:(NSString*)email {
    [self showLoadingView];
    
    [[ConnectionManager connectionDefault] requestForgetPasswordWithEmail:email success:^(id  _Nonnull responseObject) {
        [self hideLoadingView];
        
        if([responseObject[@"result"] isEqualToString:@"failure"])
        {
            NSString* error = responseObject[@"message"];
            [self showAlertNoticeWithMessage:error completion:nil];
            return;
        }
        
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
}

@end
