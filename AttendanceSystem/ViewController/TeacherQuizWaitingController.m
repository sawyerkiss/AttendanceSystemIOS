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

@end

@implementation TeacherQuizWaitingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Quiz Waiting";
    
     [self setSocket];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    if(self.socket)
        [self.socket disconnect];
}

- (void)setSocket {
    
    self.socket = [[SocketManagerIO socketManagerIO] getSocketClient];
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self showLoadingView];
        });
    }];
    
    [self.socket  on:@"quizEnded" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"quizEnded : %@",data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            TeacherQuizCompleteViewController * studentQuiz = [self.storyboard instantiateViewControllerWithIdentifier:@"TeacherQuizCompleteViewController"];
            [(UINavigationController*)self.frostedViewController.contentViewController pushViewController:studentQuiz animated:TRUE];
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

@end
