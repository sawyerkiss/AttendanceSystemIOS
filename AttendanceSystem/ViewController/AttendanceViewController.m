//
//  AttendanceViewController.m
//  AttendanceSystem
//
//  Created by TrungTruc on 2/28/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "AttendanceViewController.h"
#import "StudentModel.h"
#import "SessionViewCell.h"
#import "SessionViewController.h"
#import "REFrostedViewController.h"
#import "QRCodeViewController.h"
#import "ScanQRViewController.h"
#import "StudentQuizDetailViewController.h"
#import "TeacherQuizViewController.h"
#import "MPOPersonFacesController.h"
#import "MPOVerificationViewController.h"

@import SocketIO;

@interface AttendanceViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *lblStatistic;
@property (weak, nonatomic) IBOutlet UICollectionView *cvAttendance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrCollectionViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrCancelHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrFinishHeight;

@property (nonatomic) NSInteger userRole ;

@property (nonatomic) SocketIOClient *socket;

@property (nonatomic) NSArray *studentList;

@property (nonatomic) NSArray *titleList;

@property (nonatomic) NSMutableArray *valueList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrFaceHeight;

@end

@implementation AttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userRole = [[[UserManager userCenter] getCurrentUser].role_id integerValue];
    
    if(self.userRole == TEACHER) {
        self.title = self.course.name;
        [self setSocket];
        [self setCurrentSessionAdapter];
        self.lblStatistic.text = @"Statistic";
        self.ctrCollectionViewHeight.constant = 200;
        self.ctrCancelHeight.constant = 40 ;
        self.ctrFinishHeight.constant = 40;
        
        self.cvAttendance.dataSource = self;
         self.cvAttendance.delegate = self;
        [self.cvAttendance registerNib:[UINib nibWithNibName:@"SessionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SessionViewCellID"];
        
        self.studentList = [[NSArray alloc] init];
        self.titleList = @[@"Total",@"Present",@"Absence"];
        self.valueList = [[NSMutableArray alloc] init];
        
        self.ctrFaceHeight.constant = 40 ;
        
    }
    else {
        self.title = @"ATTENDANCE";
        self.lblStatistic.text = @"";
        self.ctrCollectionViewHeight.constant = 0;
        self.ctrFinishHeight.constant = 0 ;
        self.ctrCancelHeight.constant = 0 ;
        
        self.ctrFaceHeight.constant = 0 ;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.userRole == TEACHER) {
        
        [self.valueList removeAllObjects];
        
        [self getStudentSession];
    }
    else {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTouchCheckList:(id)sender {
    if(self.userRole == TEACHER) {
        [self.socket disconnect];
        SessionViewController* session = [self.storyboard instantiateViewControllerWithIdentifier:@"SessionViewController"];
        session.course = self.course;
        [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:session animated:TRUE];

    }
    else {
        [self showAlertView:CHECK_LIST];
    }
}

- (IBAction)didTouchQRCode:(id)sender {
    if(self.userRole == TEACHER) {
        [self.socket disconnect];
        QRCodeViewController* qrCode = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeViewController"];
        qrCode.course = self.course;
        [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:qrCode animated:TRUE];
    }
    else {
        ScanQRViewController* qrCode = [self.storyboard instantiateViewControllerWithIdentifier:@"ScanQRViewController"];
        [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:qrCode animated:TRUE];
    }
}


- (IBAction)didTouchQuiz:(id)sender {
    if(self.userRole == TEACHER) {
        [self.socket disconnect];
        [self showLoadingView];
        
        NSString* classId = self.course.classId;
        NSString* courseId = self.course.courseId;
        
//        [[ConnectionManager connectionDefault] getQuizListFromId:courseId classId:classId
//                                                         success:^(id  _Nonnull responseObject) {
//                                                             [self hideLoadingView];
//                                                             NSString* result = responseObject[@"result"];
//                                                             NSArray* quizList = responseObject[@"quiz_list"];
//
//                                                             if([result isEqualToString:@"success"]) {
//                                                           if(quizList && quizList.count > 0)
//                                                           {
                                                               TeacherQuizViewController * quiz = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherQuizViewController"];
                                                             quiz.course = self.course;
                                                            
                                                             [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:quiz animated:TRUE];
//                                                             }
//                                                                 else
//                                                                     [self showAlertQuestionWithMessage:@"Attendance quiz haven't been opened yet" completion:nil];
//                                                             }
//                                                             else
//                                                                 [self showAlertQuestionWithMessage:@"Attendance quiz haven't been opened yet" completion:nil];
//                                                         } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
//                                                             [self hideLoadingView];
//                                                             [self showAlertQuestionWithMessage:errorMessage completion:nil];
//                                                         }];
//
    }
    else {
        [self showAlertView:QUIZ];
    }
}

- (IBAction)didTouchCancelButton:(id)sender {
    
    [self showAlertQuestionWithMessage:@"Delete current attendance ?" completion:^(NSInteger buttonIndex) {
        if(buttonIndex == 1) {
            [self showLoadingView];
            [[ConnectionManager connectionDefault] cancelAttendanceCourseWithId:self.course.attendance_id success:^(id  _Nonnull responseObject) {
                [self hideLoadingView];
                [self tappedAtLeftButton:nil];
            } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
                [self hideLoadingView];
                [self showAlertNoticeWithMessage:errorMessage completion:nil];
            }];
        }
    } cancelButtonTitle:@"No" otherButtonTitle:@"Yes"];
    
}


- (IBAction)didTouchFinishButton:(id)sender {
    
    [self showAlertQuestionWithMessage:@"Finish current attendance ?" completion:^(NSInteger buttonIndex) {
        if(buttonIndex == 1) {
            [self showLoadingView];
            [[ConnectionManager connectionDefault] finishAttendanceCourseWithId:self.course.attendance_id success:^(id  _Nonnull responseObject) {
                [self hideLoadingView];
                 [self tappedAtLeftButton:nil];
            } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
                [self hideLoadingView];
                [self showAlertNoticeWithMessage:errorMessage completion:nil];
            }];
        }
    } cancelButtonTitle:@"No" otherButtonTitle:@"Yes"];
}

- (void)setSocket {
    NSString* host = HOST;
    NSURL* url = [[NSURL alloc] initWithString:host];
    SocketManager* manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
    self.socket = manager.defaultSocket;
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];
    
    [self.socket on:@"checkAttendanceUpdated" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        
    }];
    
    [self.socket on:@"checkAttendanceStopped" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        
    }];
    
    [self.socket on:@"disconnect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"socket disconnected");
    }];
}

- (void)setCurrentSessionAdapter {
    
}

- (void)showAlertView:(AttendanceType)type{
    // use UIAlertController
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:type == CHECK_LIST ? @"Input Code" : @"Input Quiz Code"
                               message:nil
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   //Do Some action here
                                                   UITextField *textField = alert.textFields[0];
                                                   NSLog(@"text was %@", textField.text);
                                                  if(type == CHECK_LIST)
                                                      [self submitCheckListCode:textField.text];
                                                   else
                                                       [self submitQuizCode:textField.text];
                                                   
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
        textField.placeholder = @"Code";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.valueList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SessionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SessionViewCellID" forIndexPath:indexPath];
    NSString* title = [self.titleList objectAtIndex:indexPath.row];
    NSString* value = [self.valueList objectAtIndex:indexPath.row];
    
    [cell loadDataForCell:title value:value];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    CGFloat width = SCREEN_WIDTH/3 - 30;
    
    return CGSizeMake(width, 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 30;
}

- (void)getStudentSession {
    [self showLoadingView];
    if(self.course) {
        [[ConnectionManager connectionDefault] getStudentCourseWithAttendance:self.course.attendance_id success:^(id  _Nonnull responseObject) {
            [self hideLoadingView];
            self.studentList = [StudentModel arrayOfModelsFromDictionaries:responseObject[@"check_attendance_list"] error:nil];
            
            NSString *count = [NSString stringWithFormat:@"%ld",self.studentList.count];
            [self.valueList addObject:count];
            
            NSString* filter = @"self.status MATCHES %@";
            
            NSPredicate* predicate = [NSPredicate predicateWithFormat:filter,@"1"];
            
            NSArray* filteredPresent = [self.studentList filteredArrayUsingPredicate:predicate];
            NSString *present = [NSString stringWithFormat:@"%ld",filteredPresent.count];
            
            [self.valueList addObject:present];
            
            NSString* filter1 = @"self.status MATCHES %@";
            
            NSPredicate* predicate1 = [NSPredicate predicateWithFormat:filter1,@"0"];
            
            NSArray* filteredAbsence = [self.studentList filteredArrayUsingPredicate:predicate1];
            NSString *absence = [NSString stringWithFormat:@"%ld",filteredAbsence.count];
            
            [self.valueList addObject:absence];
            
            [self.cvAttendance reloadData];
            
        } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
            [self hideLoadingView];
            [self showAlertNoticeWithMessage:errorMessage completion:nil];
        }];
    }
    else
        [self hideLoadingView];
}

- (void)tappedAtLeftButton:(id)sender {
    
     if(self.userRole == TEACHER)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self.frostedViewController presentMenuViewController];
}

- (void)submitCheckListCode:(NSString*)code {
    [self showLoadingView];
    
    [[ConnectionManager connectionDefault] submitDelegateCodeWithCode:code success:^(id  _Nonnull responseObject) {
        [self hideLoadingView];
        
        if([responseObject[@"result"] isEqualToString:@"failure"])
        {
            NSString* error = responseObject[@"message"];
            [self showAlertNoticeWithMessage:error completion:nil];
            return;
        }
        
        NSDictionary* data = responseObject[@"delegate_detail"];
        
        CourseModel* course = [[CourseModel alloc] init];
        course.courseId = data[@"course_id"];
        course.classId = data[@"class_id"];
        course.attendance_id = data[@"attendance_id"];
        
        SessionViewController* session = [self.storyboard instantiateViewControllerWithIdentifier:@"SessionViewController"];
        session.course = course;
        [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:session animated:TRUE];
        
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
    
}

- (void)submitQuizCode:(NSString*)code {
    [self showLoadingView];
    [[ConnectionManager connectionDefault] checkQuizCodeWithCode:code success:^(id  _Nonnull responseObject) {
        [self hideLoadingView];
        
        if(!responseObject)
            return;
        
        if([responseObject[@"result"] isEqualToString:@"failure"])
        {
            NSString* error = responseObject[@"message"];
            [self showAlertNoticeWithMessage:error completion:nil];
            return;
        }
        
//        NSInteger quiz_id = [responseObject[@"quiz_id"] integerValue];
        //StudentQuizViewController
        StudentQuizDetailViewController* studentQuiz = [self.storyboard instantiateViewControllerWithIdentifier:@"StudentQuizDetailViewController"];
//        studentQuiz.quiz_id = quiz_id;
        studentQuiz.quiz_id = code;
        [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:studentQuiz animated:TRUE];
            
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
}
- (IBAction)didTouchFaceDetection:(id)sender {
    
    if(self.userRole == TEACHER) {
        MPOVerificationViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MPOVerificationViewController"];
        controller.verificationType = VerificationTypeFaceAndPerson;
        controller.course = self.course;
        PersonGroup* group = [[PersonGroup alloc] init];
        group.groupId = GROUP;
        controller.group = group;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}


@end
