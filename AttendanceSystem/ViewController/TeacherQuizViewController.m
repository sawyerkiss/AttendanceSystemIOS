//
//  TeacherQuizViewController.m
//  AttendanceSystem
//
//  Created by TamTran on 4/14/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "TeacherQuizViewController.h"
#import "StudentTableViewCell.h"
#import "QuizModel.h"
#import "TeacherQuizWaitingController.h"
#import "REFrostedViewController.h"
#import "TeacherQuizCompleteViewController.h"

@interface TeacherQuizViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblQuizType;
@property (weak, nonatomic) IBOutlet UILabel *lblQuizCode;
@property (weak, nonatomic) IBOutlet UITableView *tableStudents;

@property (weak, nonatomic) IBOutlet UIButton *buttonStart;

@property (nonatomic) NSMutableArray<StudentModel*> * studentList;
@property (nonatomic) SocketIOClient *socket;
@property (nonatomic) QuizModel *quiz;

@end

@implementation TeacherQuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableStudents.dataSource = self;
    self.tableStudents.delegate = self;
    self.tableStudents.rowHeight = UITableViewAutomaticDimension;
    self.tableStudents.estimatedRowHeight = 100;
    
    self.studentList = [[NSMutableArray alloc] init];
    
    if(self.course) {
        
        self.title = self.course.name;
    }
    
    self.lblQuizType.text = @"";
    self.lblQuizCode.text = @"";
    
    self.buttonStart.enabled = FALSE;
    
}

- (void)viewWillDisappear:(BOOL)animated {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(self.socket)
            [self.socket disconnect];
//    });

}

- (void)viewWillAppear:(BOOL)animated {
    [self setSocket];
}

- (void)setSocket {
    
    self.socket = [[SocketManagerIO socketManagerIO] getSocketClient];
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self showLoadingView];
        });
    }];
    
    [self.socket on:@"joinedQuiz" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"joinedQuiz : %@",data);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"joinedQuiz : %@",data);
            NSDictionary* dictionary = [data objectAtIndex:0];
            NSString* quiz_code = dictionary[@"quiz_code"];
            [self showLoadingView];
            [[ConnectionManager connectionDefault] getPublishQuiz:quiz_code success:^(id  _Nonnull responseObject) {
                [self hideLoadingView];
                
                NSString* result = responseObject[@"result"];
                
                if([result isEqualToString:@"success"])
                {
                    self.quiz = [[QuizModel alloc] initWithDictionary:responseObject[@"quiz"] error:nil];
                
                    self.lblQuizCode.text = self.quiz.code;
                self.lblQuizType.text = [self.quiz.type isEqualToString:@"0"] ? @"Academic" : @"Miscellaneous";
                self.studentList = [StudentModel arrayOfModelsFromDictionaries:self.quiz.participants error:nil];
                
                [self.tableStudents reloadData];
                    
                    self.buttonStart.enabled = YES;
                }
                
            } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
                [self hideLoadingView];
            }];
        });
    }];
    
    [self.socket on:@"portalStartedQuiz" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"portalStartedQuiz: %@", data);
            NSDictionary* dictionary = [data objectAtIndex:0];
            NSString* quiz_code = dictionary[@"quiz_code"];
            if([quiz_code isEqualToString:self.quiz.code])
                [self startQuiz];
        });
    }];
    

    
    [self.socket on:@"disconnect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"socket disconnected");
            [self hideLoadingView];
        });
    }];
    
    [self.socket connect];
    
//     CFRunLoopRun();
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)startQuiz {
    [self showLoadingView];
    
    [[ConnectionManager connectionDefault] startQuizWithId:self.quiz.code success:^(id  _Nonnull responseObject) {
        
        [self hideLoadingView];
        
        [self emitStartQuiz];
        
        NSString* result = responseObject[@"result"];
        
        if([result isEqualToString:@"success"]) {
            TeacherQuizWaitingController * studentQuiz = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherQuizWaitingController"];
            studentQuiz.quiz_code = self.quiz.code;
            [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:studentQuiz animated:TRUE];
        }
        else
            [self showAlertNoticeWithMessage:@"Can't start this quiz" completion:nil];
        
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
}



- (IBAction)didTouchStartButton:(id)sender {
    
    [self startQuiz];

}

-(void)emitStartQuiz {
    NSMutableArray* data = [[NSMutableArray alloc] init];
    
    NSDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    NSString* quiz_code = [NSString stringWithFormat:@"%@",self.quiz.code];
//    NSString* studendId = [[UserManager userCenter] getCurrentUser].userId;
    
    [dictionary setValue:quiz_code forKey:@"quiz_code"];
    
    [data addObject:dictionary];
    
    [self.socket emit:@"mobileStartedQuiz" with:data];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    return 50.0f;
}

@end
