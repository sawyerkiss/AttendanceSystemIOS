//
//  SendFeedbackViewController.m
//  AttendanceSystem
//
//  Created by TrungTruc on 3/16/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "SendFeedbackViewController.h"
#import <MaterialControls/MDTextField.h>
#import "BEMCheckBox.h"

@interface SendFeedbackViewController ()
@property (weak, nonatomic) IBOutlet MDTextField *tfTitle;
@property (weak, nonatomic) IBOutlet MDTextField *tfContent;
@property (weak, nonatomic) IBOutlet BEMCheckBox *cbAnonymous;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrCheckBoxWidth;
@property (weak, nonatomic) IBOutlet UILabel *lblAnonymous;
@property (weak, nonatomic) IBOutlet UILabel *lblAnonymousTitle;


@property (nonatomic) NSInteger userRole;
@end

@implementation SendFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SEND FEEDBACK";
    
    self.userRole = [[[UserManager userCenter] getCurrentUser].role_id integerValue];
    
    if(self.userRole == STUDENT) {
        self.ctrCheckBoxWidth.constant = 25;
    }
    else {
        self.ctrCheckBoxWidth.constant = 0 ;
        self.lblAnonymous.text = @"";
        self.lblAnonymousTitle.text = @"";
    }
    self.cbAnonymous.boxType = BEMBoxTypeSquare;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchSendFeedback:(id)sender {
    [self.view endEditing:TRUE];
    
    if(self.tfTitle.text && self.tfTitle.text.length == 0)
    {
        [self showAlertNoticeWithMessage:@"Missing Title" completion:nil];
        return;
    }
    
    if(self.tfContent.text && self.tfContent.text.length == 0)
    {
        [self showAlertNoticeWithMessage:@"Missing Content" completion:nil];
        return;
    }

    
    [self showLoadingView];
    
    BOOL isAnonymous = self.cbAnonymous.on;
    
    [[ConnectionManager connectionDefault] sendFeedbackRequestWithTitle:self.tfTitle.text
                                                                content:self.tfContent.text
                                                            isAnonymous:isAnonymous
                                                                success:^(id  _Nonnull responseObject) {
        [self hideLoadingView];
        [self tappedAtLeftButton:nil];
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];

}

@end
