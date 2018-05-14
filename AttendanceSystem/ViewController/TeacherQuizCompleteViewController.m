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

typedef enum {
    
    NOT_PARTICIPATE,
    CHECKED,
    NOT_CHECKED
    
} SEGMENT_STUDENT;

@interface TeacherQuizCompleteViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableStudents;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalStudents;
@property (weak, nonatomic) IBOutlet UILabel *lblParticipatedStudents;

@property (weak, nonatomic) IBOutlet UIButton *buttonChecked;

@property (weak, nonatomic) IBOutlet UIButton *buttonUnchecked;
@property (weak, nonatomic) IBOutlet UIButton *buttonNoAttend;

@property (nonatomic) QuizModel *quiz;

@property (nonatomic) NSMutableArray<StudentModel*> * studentNotChecked;

@property (nonatomic) NSMutableArray<StudentModel*> * studentChecked;

@property (nonatomic) NSMutableArray<StudentModel*> * studentNotParticipate;

@property (nonatomic) NSArray *studentList;

@property (nonatomic) SocketIOClient *socket;

@property (nonatomic) SEGMENT_STUDENT segment;

@end

@implementation TeacherQuizCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Quiz Complete";
    
    self.tableStudents.dataSource = self;
    self.tableStudents.delegate = self;
    self.tableStudents.rowHeight = UITableViewAutomaticDimension;
    self.tableStudents.estimatedRowHeight = 100;
    
    self.studentChecked = [[NSMutableArray alloc] init];
    self.studentNotChecked = [[NSMutableArray alloc] init];
    self.studentNotParticipate = [[NSMutableArray alloc] init];
    
    self.studentList = [[NSArray alloc] init];
    
    // change the back button to cancel and add an event handler
    
    self.segment = CHECKED;
    
    [self showLoadingView];
    [[ConnectionManager connectionDefault] getQuizMobileResults:self.quizCode
                                               classHasCourseId:self.class_has_course_id
                                                        success:^(id  _Nonnull responseObject) {
        [self hideLoadingView];

        NSString* result = responseObject[@"result"];

        if([result isEqualToString:@"success"])
        {
            self.studentChecked = [StudentModel arrayOfModelsFromDictionaries:responseObject[@"checked_student_list"] error:nil];
            self.studentNotChecked = [StudentModel arrayOfModelsFromDictionaries:responseObject[@"unchecked_student_list"] error:nil];
            self.studentNotParticipate = [StudentModel arrayOfModelsFromDictionaries:responseObject[@"not_participate_list"] error:nil];

            NSInteger studentParticipate = self.studentChecked.count + self.studentNotChecked.count;
            NSInteger totalStudent = studentParticipate + self.studentNotParticipate.count;
            
            self.lblParticipatedStudents.text = [NSString stringWithFormat:@"Participated Students: %ld", studentParticipate];
            self.lblTotalStudents.text = [NSString stringWithFormat:@"Total Students: %ld", totalStudent];
            
            if(self.segment == CHECKED)
                self.studentList = self.studentChecked;
            else if(self.segment == NOT_CHECKED)
                self.studentList = self.studentNotChecked;
            else if(self.segment == NOT_PARTICIPATE)
                self.studentList = self.studentNotParticipate;
            
            [self.tableStudents reloadData];
        }

    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];

        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
//    [self setSocket];
}

- (void)viewWillDisappear:(BOOL)animated {
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if(self.socket)
//            [self.socket disconnect];
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.segment == CHECKED)
        self.studentList = self.studentChecked;
    else if(self.segment == NOT_CHECKED)
        self.studentList = self.studentNotChecked;
    else if(self.segment == NOT_PARTICIPATE)
        self.studentList = self.studentNotParticipate;
    
    return self.studentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"StudentTableViewCellID";
    StudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(self.studentList && self.studentList.count > 0)
    [cell loadDataForCell:[self.studentList objectAtIndex:indexPath.row] completeQuiz:TRUE];
    
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

- (void)tappedAtLeftButton:(id)sender {
     [(UINavigationController*)self.frostedViewController.contentViewController popToRootViewControllerAnimated:TRUE];
}

- (IBAction)didTouchCheckedButton:(id)sender {
    
    self.segment = CHECKED;
    
    [self.buttonChecked setBackgroundColor:[UIColor blueColor]];
    [self.buttonNoAttend setBackgroundColor:[UIColor whiteColor]];
    [self.buttonUnchecked setBackgroundColor:[UIColor whiteColor]];
    
    [self.buttonChecked setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonNoAttend setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonUnchecked setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    
    if(self.segment == CHECKED)
        self.studentList = self.studentChecked;
    else if(self.segment == NOT_CHECKED)
        self.studentList = self.studentNotChecked;
    else if(self.segment == NOT_PARTICIPATE)
        self.studentList = self.studentNotParticipate;
    
    [self.tableStudents reloadData];
}

- (IBAction)didTouchUncheckedButton:(id)sender {
    
    self.segment = NOT_CHECKED;
    
    [self.buttonChecked setBackgroundColor:[UIColor whiteColor]];
    [self.buttonNoAttend setBackgroundColor:[UIColor whiteColor]];
    [self.buttonUnchecked setBackgroundColor:[UIColor blueColor]];
    
    [self.buttonChecked setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonNoAttend setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonUnchecked setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if(self.segment == CHECKED)
        self.studentList = self.studentChecked;
    else if(self.segment == NOT_CHECKED)
        self.studentList = self.studentNotChecked;
    else if(self.segment == NOT_PARTICIPATE)
        self.studentList = self.studentNotParticipate;
    
    [self.tableStudents reloadData];
}


- (IBAction)didTouchNoAttendButton:(id)sender {
    
    self.segment = NOT_PARTICIPATE;
    
    [self.buttonChecked setBackgroundColor:[UIColor whiteColor]];
    [self.buttonNoAttend setBackgroundColor:[UIColor blueColor]];
    [self.buttonUnchecked setBackgroundColor:[UIColor whiteColor]];
    
    [self.buttonChecked setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.buttonNoAttend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonUnchecked setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    if(self.segment == CHECKED)
        self.studentList = self.studentChecked;
    else if(self.segment == NOT_CHECKED)
        self.studentList = self.studentNotChecked;
    else if(self.segment == NOT_PARTICIPATE)
        self.studentList = self.studentNotParticipate;
    
    [self.tableStudents reloadData];
}

- (void)setSocket {
    
    self.socket = [[SocketManagerIO socketManagerIO] getSocketClient];
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self showLoadingView];
        });
    }];
    
    [self.socket on:@"quizCompletedMobile" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"quizCompletedMobile: %@", data);
//            NSDictionary* dictionary = [data objectAtIndex:0];
//            NSString* quiz_code = dictionary[@"quiz_code"];
//            if([quiz_code isEqualToString:self.quiz_code])
//                [self endQuiz:quiz_code];
        });
    }];
    
    
    [self.socket on:@"disconnect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"socket disconnected");
            [self hideLoadingView];
        });
    }];
    
    [self.socket connect];
    
}


@end
