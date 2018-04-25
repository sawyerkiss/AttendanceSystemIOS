//
//  TeacherQuizCompleteViewController.m
//  AttendanceSystem
//
//  Created by TamTran on 4/14/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "TeacherQuizCompleteViewController.h"

@interface TeacherQuizCompleteViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableStudents;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalStudents;
@property (weak, nonatomic) IBOutlet UILabel *lblParticipatedStudents;

@property (weak, nonatomic) IBOutlet UIButton *buttonChecked;

@property (weak, nonatomic) IBOutlet UIButton *buttonUnchecked;
@property (weak, nonatomic) IBOutlet UIButton *buttonNoAttend;


@end

@implementation TeacherQuizCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didTouchCloseButton:(id)sender {
    
    

}

- (IBAction)didTouchCheckedButton:(id)sender {
    
    
}

- (IBAction)didTouchUncheckedButton:(id)sender {
    
    
}


- (IBAction)didTouchNoAttendButton:(id)sender {
}


@end
