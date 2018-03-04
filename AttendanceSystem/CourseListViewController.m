//
//  CourseListViewController.m
//  AttendanceSystem
//
//  Created by TrungTruc on 1/24/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "CourseListViewController.h"
#import "REFrostedViewController.h"
#import "CourseViewCell.h"
#import "AttendanceViewController.h"

@import SocketIO;

@interface CourseListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableCourse;

@property (nonatomic) SocketIOClient *socket;

@property (nonatomic) NSArray *courseList;

@end

@implementation CourseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"COURSE LIST";
    
    self.tableCourse.dataSource = self;
    self.tableCourse.delegate = self;
    self.tableCourse.rowHeight = UITableViewAutomaticDimension;
    self.tableCourse.estimatedRowHeight = 100;
//    self.tableCourse.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.courseList = [[NSArray alloc] init];
    
    [self getCourseList];
    
    [self setSocket];
}

- (void)viewWillDisappear:(BOOL)animated {
        if(self.socket)
        [self.socket disconnect];
}

- (void)getCourseList {
    [self showLoadingView];
    
    if([[[UserManager userCenter] getCurrentUser].role_id integerValue] == STUDENT) {
        [[ConnectionManager connectionDefault] getTeachingCourseList:^(id  _Nonnull responseObject) {
            [self hideLoadingView];
            self.courseList = [CourseModel arrayOfModelsFromDictionaries:responseObject[@"courses"] error:nil];
            
            
//            for(CourseModel* course in self.courseList) {
//                [[DBManager getSharedInstance] insertNewCourse:course];
//            }
            
        } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
            [self hideLoadingView];
            [self showAlertNoticeWithMessage:errorMessage completion:nil];
        }];
    }
    else if([[[UserManager userCenter] getCurrentUser].role_id integerValue] == TEACHER){
        [[ConnectionManager connectionDefault] getTeachingCourseList:^(id  _Nonnull responseObject) {
            [self hideLoadingView];
            self.courseList = [CourseModel arrayOfModelsFromDictionaries:responseObject[@"courses"] error:nil];
            
            [self getOpeningCourse];
                
        
            
//            for(CourseModel* course in self.courseList) {
//                [[DBManager getSharedInstance] insertNewCourse:course];
//            }
            
        } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
            [self hideLoadingView];
            [self showAlertNoticeWithMessage:errorMessage completion:nil];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tappedAtLeftButton:(id)sender {
    [self.frostedViewController presentMenuViewController];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.courseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CourseCell";
    CourseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    [cell loadCourseData:[self.courseList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CourseModel* course = [self.courseList objectAtIndex:indexPath.row];
    
    if(course.attendance_id && [course.attendance_id isEqualToString:@"0"])
    {
        [self showAlertQuestionWithMessage:@"Create New Course" completion:^(NSInteger buttonIndex) {
            if(buttonIndex == 1) {
                [self showLoadingView];
                [[ConnectionManager connectionDefault] createAttendanceCourse:course success:^(id  _Nonnull responseObject) {
                    [self hideLoadingView];
                    
                    if([responseObject[@"result"] isEqualToString:@"failure"])
                    {
                        NSString* error = responseObject[@"message"];
                        [self showAlertNoticeWithMessage:error completion:nil];
                        return;
                    }
                    
                    course.attendance_id = responseObject[@"attendance_id"];
                    AttendanceViewController* attendance = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendanceViewController"];
                    attendance.course = course;
                    [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:attendance animated:TRUE];
                    
                } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
                    [self hideLoadingView];
                    [self showAlertNoticeWithMessage:errorMessage completion:nil];
                }];
            }
            else {
                
            }
        } cancelButtonTitle:@"No" otherButtonTitle:@"Yes"];
    }
    else {
        if(course.attendance_id) {
        AttendanceViewController* attendance = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendanceViewController"];
        attendance.course = course;
        [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:attendance animated:TRUE];
        }
    }
}

- (void)setSocket {
    NSString* host = HOST;
    NSURL* url = [[NSURL alloc] initWithString:host];
    SocketManager* manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
    self.socket = manager.defaultSocket;
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];
    
    [self.socket on:@"checkAttendanceCreated" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        [self getOpeningCourse];
    }];
    
    [self.socket on:@"checkAttendanceStopped" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        [self getOpeningCourse];
    }];
    
    [self.socket on:@"disconnect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
     NSLog(@"socket disconnected");
    }];
    
//    [self.socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
//        double cur = [[data objectAtIndex:0] floatValue];
//
//        [[self.socket emitWithAck:@"canUpdate" with:@[@(cur)]] timingOutAfter:0 callback:^(NSArray* data) {
//            [self.socket emit:@"update" with:@[@{@"amount": @(cur + 2.50)}]];
//        }];
//
//        [ack with:@[@"Got your currentAmount, ", @"dude"]];
//    }];
    
    
    [self.socket connect];
}


- (void)getOpeningCourse {
    [self showLoadingView];
    
    [[ConnectionManager connectionDefault] getOpeningCourseByTeacher:^(id  _Nonnull responseObject) {
        [self hideLoadingView];
        NSArray* data = responseObject[@"opening_attendances"];
        NSMutableArray* openingCourse = [[NSMutableArray alloc] init];
        NSMutableArray* attendanceList = [[NSMutableArray alloc] init];
       
        for(NSDictionary* openingData in data)
        {
            [openingCourse addObject:[openingData[@"class_has_course_id"] stringValue]];
            [attendanceList addObject:[openingData[@"attendance_id"] stringValue]];
        }
        
        for(CourseModel* course in self.courseList) {
            
            if([openingCourse containsObject:course.chcid]) {
                course.opening = @"1";
                course.attendance_id = [attendanceList objectAtIndex:[openingCourse indexOfObject:course.chcid]];
            } else {
                course.opening = @"0";
                course.attendance_id = @"0";
            }
        }
        
        [self.tableCourse reloadData];
        
        
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        
        [self.tableCourse reloadData];
        [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
}
@end
