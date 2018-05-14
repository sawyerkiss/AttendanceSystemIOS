//
//  TeacherQuizWaitingController.m
//  AttendanceSystem
//
//  Created by TamTran on 4/14/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "TeacherQuizWaitingController.h"
#import "REFrostedViewController.h"
#import "TeacherQuizCompleteViewController.h"

@interface TeacherQuizWaitingController ()

@property (nonatomic) SocketIOClient *socket;

//@property (nonatomic) NSString* quiz_code;

@end

@implementation TeacherQuizWaitingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Quiz Waiting";
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setSocket];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(self.socket)
            [self.socket disconnect];
    });
}

- (void)setSocket {
    
    self.socket = [[SocketManagerIO socketManagerIO] getSocketClient];
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self showLoadingView];
        });
    }];
    
    [self.socket on:@"mobileEndedQuiz" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"mobileEndedQuiz: %@", data);
                        NSDictionary* dictionary = [data objectAtIndex:0];
                        NSString* quiz_code = dictionary[@"quiz_code"];
            self.quiz_code = quiz_code;
        });
    }];
    
    [self.socket on:@"quizCompletedMobile" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"quizCompletedMobile: %@", data);
            NSDictionary* dictionary = [data objectAtIndex:0];
            NSString* quiz_code = dictionary[@"quiz_code"];
            self.quiz_code = quiz_code;
            NSString* class_has_course_id = dictionary[@"class_has_course_id"];
//            if([quiz_code isEqualToString:self.quiz_code])
                [self endQuiz:self.quiz_code class_has_course_id:class_has_course_id];
            
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

- (void)endQuiz:(NSString*)quizCode class_has_course_id:(NSString*)class_has_course_id{
    
    TeacherQuizCompleteViewController * studentQuiz = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherQuizCompleteViewController"];
    studentQuiz.quizCode = quizCode;
    studentQuiz.class_has_course_id = class_has_course_id;
    
    [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:studentQuiz animated:TRUE];
}

@end
