//
//  TeacherQuizCompleteViewController.m
//  AttendanceSystem
//
//  Created by TamTran on 4/14/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "TeacherQuizCompleteViewController.h"
#import "QuizModel.h"
#import "StudentTableViewCell.h"

@interface TeacherQuizCompleteViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableStudents;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalStudents;
@property (weak, nonatomic) IBOutlet UILabel *lblParticipatedStudents;

@property (weak, nonatomic) IBOutlet UIButton *buttonChecked;

@property (weak, nonatomic) IBOutlet UIButton *buttonUnchecked;
@property (weak, nonatomic) IBOutlet UIButton *buttonNoAttend;

@property (nonatomic) QuizModel *quiz;

@property (nonatomic) NSMutableArray<StudentModel*> * studentList;

@end

@implementation TeacherQuizCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.tableStudents.dataSource = self;
    self.tableStudents.delegate = self;
    self.tableStudents.rowHeight = UITableViewAutomaticDimension;
    self.tableStudents.estimatedRowHeight = 100;
    
    [self showLoadingView];
    [[ConnectionManager connectionDefault] getPublishQuiz:_quizCode success:^(id  _Nonnull responseObject) {
        [self hideLoadingView];
        
        NSString* result = responseObject[@"result"];
        
        if([result isEqualToString:@"success"])
        {
            self.quiz = [[QuizModel alloc] initWithDictionary:responseObject[@"quiz"] error:nil];
            
//            self.lblQuizCode.text = self.quiz.code;
//            self.lblQuizType.text = [self.quiz.type isEqualToString:@"0"] ? @"Academic" : @"Miscellaneous";
            self.studentList = [StudentModel arrayOfModelsFromDictionaries:self.quiz.participants error:nil];
            
            [self.tableStudents reloadData];
            
        }
        
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];
        
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.studentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"StudentTableViewCellID";
    StudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell loadDataForCell:[self.studentList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return 70.0f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)didTouchCloseButton:(id)sender {
    
    [(UINavigationController*)self.frostedViewController.contentViewController popToRootViewControllerAnimated:TRUE];

}

- (IBAction)didTouchCheckedButton:(id)sender {
    
    [self.buttonChecked setBackgroundColor:[UIColor blueColor]];
    [self.buttonNoAttend setBackgroundColor:[UIColor whiteColor]];
    [self.buttonUnchecked setBackgroundColor:[UIColor whiteColor]];
    
    [self.buttonChecked setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonNoAttend setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonUnchecked setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

- (IBAction)didTouchUncheckedButton:(id)sender {
    
    [self.buttonChecked setBackgroundColor:[UIColor whiteColor]];
    [self.buttonNoAttend setBackgroundColor:[UIColor whiteColor]];
    [self.buttonUnchecked setBackgroundColor:[UIColor blueColor]];
    
    [self.buttonChecked setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonNoAttend setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonUnchecked setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (IBAction)didTouchNoAttendButton:(id)sender {
    
    [self.buttonChecked setBackgroundColor:[UIColor whiteColor]];
    [self.buttonNoAttend setBackgroundColor:[UIColor blueColor]];
    [self.buttonUnchecked setBackgroundColor:[UIColor whiteColor]];
    
    [self.buttonChecked setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonNoAttend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonUnchecked setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}


@end
