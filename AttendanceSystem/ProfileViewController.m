//
//  ProfileViewController.m
//  AttendanceSystem
//
//  Created by BaoLam on 2/1/18.
//  Copyright © 2018 BaoLam. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageViewLoading.h"
#import "REFrostedViewController.h"
#import "ChangePasswordViewController.h"

@interface ProfileViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageViewLoading *imgProfile;
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfRole;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrHeight;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tfFirstName.delegate = self;
    self.tfLastName.delegate = self;
    self.tfRole.delegate = self;
    self.tfEmail.delegate = self;
    self.tfPhone.delegate = self;
    
    UserModel* user = [[UserManager userCenter] getCurrentUser];
    
    [self.imgProfile setImageWithImageLink:user.avatar andPlaceholderImageName:@"icon_user"];
    self.tfFirstName.text = user.first_name;
    self.tfLastName.text = user.last_name;
    self.tfEmail.text = user.email;
    self.tfPhone.text = user.phone;
    
    if(user.role_id.integerValue == STUDENT) {
        self.ctrHeight.constant = 21;
        self.tfRole.text = @"Student";
        self.tfID.text = [user.email substringWithRange:NSMakeRange(0, 7)];
    }
    else {
        self.ctrHeight.constant = 0;
        self.tfRole.text = @"Teacher";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}
- (IBAction)didTouchChangePassword:(id)sender {
    
    ChangePasswordViewController* qrCode = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:qrCode animated:TRUE];
    
}

@end
