//
//  SessionViewController.m
//  AttendanceSystem
//
//  Created by TrungTruc on 3/2/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "SessionViewController.h"
#import "StudentSessionCell.h"

typedef enum {
    PRESENT = 1,
    ABSENCE = 2
}SESSION_TYPE;

@interface SessionViewController ()<UITableViewDelegate,UITableViewDataSource,StudentSessionDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrPresentLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrAbsenceLineHeight;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableSession;

@property (nonatomic) NSArray *sessionList;

@property (nonatomic) NSArray *absenceList;

@property (nonatomic) NSArray *presentList;

@property (nonatomic) SESSION_TYPE session_type ;

@property (nonatomic) NSArray *courseList;

@end

@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableSession.dataSource = self;
    self.tableSession.delegate = self;
    self.tableSession.rowHeight = UITableViewAutomaticDimension;
    self.tableSession.estimatedRowHeight = 100;
//    self.tableSession.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.sessionList = [[NSArray alloc] init];
    
    self.absenceList = [[NSArray alloc] init];
    self.presentList = [[NSArray alloc] init];
    
    self.session_type = ABSENCE;
    
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showLoadingView];
    if(self.course) {
        
        self.title = self.course.name;
        
        [self getStudentSessionList];
        
        [self getCourseList];
    }
    else
        [self hideLoadingView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchPresentButton:(id)sender {
    if(self.session_type != PRESENT)
    [self loadSessionListWithType:PRESENT];
}

- (IBAction)didTouchAbsenceButton:(id)sender {
    if(self.session_type != ABSENCE)
    [self loadSessionListWithType:ABSENCE];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sessionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"StudentSessionCell";
    StudentSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.course = self.course;
    cell.delegate = self;
    [cell loadDataForCell:[self.sessionList objectAtIndex:indexPath.row] withAttendanceType:CHECK_LIST];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)loadSessionListWithType:(SESSION_TYPE)type {
    if(type == ABSENCE) {
        self.ctrAbsenceLineHeight.constant = 5;
        self.ctrPresentLineHeight.constant = 0 ;
        self.sessionList = self.absenceList;
    }
    else {
        self.ctrAbsenceLineHeight.constant = 0;
        self.ctrPresentLineHeight.constant = 5 ;
        self.sessionList = self.presentList;
    }
    
    self.session_type = type;
    
    [self.tableSession reloadData];
}

- (void)checkStudentAttendanceSession:(StudentModel *)student {
    
    [self showLoadingView];
    
    NSString* attendaceType = [NSString stringWithFormat:@"%@",[student.status isEqualToString:@"1"] ? @"0" : @"1"];
    
    [[ConnectionManager connectionDefault] syncAttendanceChecklistWithStudentId:student.studentId
                                                                   attendanceId:self.course.attendance_id
                                                                 attendanceType:attendaceType
                                                                        success:^(id  _Nonnull responseObject) {
        [self hideLoadingView];
        [self getStudentSessionList];
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
          [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];

}

- (void)getStudentSessionList {
    [[ConnectionManager connectionDefault] getStudentCourseWithAttendance:self.course.attendance_id success:^(id  _Nonnull responseObject) {
        [self hideLoadingView];
        NSArray* studentList = [StudentModel arrayOfModelsFromDictionaries:responseObject[@"check_attendance_list"] error:nil];
        
        NSString* filter = @"self.status MATCHES %@";
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter,@"1"];
        
        NSArray* filteredPresent = [studentList filteredArrayUsingPredicate:predicate];
        self.presentList = filteredPresent;
        
        NSString* filter1 = @"self.status MATCHES %@";
        
        NSPredicate* predicate1 = [NSPredicate predicateWithFormat:filter1,@"0"];
        
        NSArray* filteredAbsence = [studentList filteredArrayUsingPredicate:predicate1];
        
        self.absenceList = filteredAbsence;
        
        [self loadSessionListWithType:self.session_type];
        
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
}

- (void)getCourseList {
    if([[[UserManager userCenter] getCurrentUser].role_id integerValue] == STUDENT) {
        [[ConnectionManager connectionDefault] getStudyingCourseList:^(id  _Nonnull responseObject) {
            [self hideLoadingView];
            self.courseList = [CourseModel arrayOfModelsFromDictionaries:responseObject[@"courses"] error:nil];
            
            for(CourseModel *course in self.courseList)
            {
                if([course.courseId isEqualToString:self.course.courseId])
                {
                    self.title = course.name;
                    break;
                }
            }
            
        } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
            [self hideLoadingView];
        }];
    }
}

- (void)tappedAtRightButton:(id)sender {
    [self showLoadingView];
    
    [[ConnectionManager connectionDefault] getDelegateCode:self.course success:^(id  _Nonnull responseObject) {
         [self hideLoadingView];
        [self showAlertNoticeWithMessage:[NSString stringWithFormat:@"Delegate code : %@",responseObject[@"code"]] completion:nil];
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
    
}

@end
