//
//  StudentQuizDetailViewController.m
//  AttendanceSystem
//
//  Created by TamTran on 4/7/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "StudentQuizDetailViewController.h"

@import SocketIO;

@interface StudentQuizDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblQuizTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblQuizQuestion;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrWidth;

@property (nonatomic) SocketIOClient *socket;

@property (nonatomic) NSUInteger questionIndex;

@end

@implementation StudentQuizDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title = @"QUIZ";
   
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self setSocket];
//    });

    
    [self showQuestionOrNot:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    if(self.socket)
        [self.socket disconnect];
//    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showQuestionOrNot:(BOOL)isShow {
    
    if(isShow) {
        _lblQuizQuestion.text = [NSString stringWithFormat:@"Question %ld",self.questionIndex+1];
        _lblQuizTitle.text = @"";
        _ctrHeight.constant = 60 ;
        _ctrWidth.constant = 160;
    }
    else {
        _lblQuizTitle.text = @"You joined the quiz.\n Wait for teacher start the quiz";
        _lblQuizQuestion.text = @"";
        _ctrHeight.constant = 0 ;
        _ctrWidth.constant = 0;
    }
}

- (void)setSocket {
//    NSString* host = HOST;
//    NSURL* url = [[NSURL alloc] initWithString:host];
//    NSString* strToken = [[UserManager userCenter] getCurrentUserToken];
//    SocketManager* manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES,@"forcePolling": @YES,@"connectParams": @{@"Authorization":strToken}}];
//    self.socket = manager.defaultSocket;
    
    self.socket = [[SocketManagerIO socketManagerIO] getSocketClient];
    
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
     
      dispatch_async(dispatch_get_main_queue(), ^{
        [self showQuestionOrNot:NO];
        [self showLoadingView];
      });
    }];
    
    [self.socket on:@"quizQuestionReady" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
         dispatch_async(dispatch_get_main_queue(), ^{
        [self showLoadingView];
        NSLog(@"quizQuestionReady : %@",data);
         });
    }];
    
    [self.socket on:@"quizQuestionLoaded" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
     dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"quizQuestionLoaded : %@",data);
        [self hideLoadingView];
         
         NSDictionary* firstData = [data objectAtIndex:0];
         
         self.questionIndex = [[firstData objectForKey:@"question_index"] integerValue];
         self.quiz_id = [firstData objectForKey:@"quiz_code"];
         
        [self showQuestionOrNot:TRUE];
     });
    }];
    
    [self.socket on:@"quizQuestionEnded" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
       dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingView];
         NSLog(@"quizQuestionEnded : %@",data);
       });
    }];
    
    [self.socket on:@"answeredQuiz" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"answeredQuiz : %@",data);
//        [self showLoadingView];
            [self hideLoadingView];
        });
    }];
    
    [self.socket on:@"disconnect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
       dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"socket disconnected");
        [self hideLoadingView];
       });
    }];
    
    [self.socket connect];
//    dispatch_async(dispatch_get_main_queue(), ^{
//    CFRunLoopRun();
//    });
}

- (IBAction)didTouchAButton:(id)sender {

    [self didAnswerWithOption:@"a"];
    
}

- (IBAction)didTouchBButton:(id)sender {
     [self didAnswerWithOption:@"b"];
    
}

- (IBAction)didTouchCButton:(id)sender {
    
     [self didAnswerWithOption:@"c"];
}

- (IBAction)didTouchDButton:(id)sender {
    
     [self didAnswerWithOption:@"d"];
}


- (void)didAnswerWithOption:(NSString*)answer {
    //    [[self.socket emitWithAck:@"answeredQuiz" with:@[@(cur)]] timingOutAfter:0 callback:^(NSArray* data) {
    
    //    { quiz_code: '73926',
    //       question_index: 0,
    //       option: 'a',
    //      student_id: 127 }
    
    [self showLoadingView];
    
    NSMutableArray* data = [[NSMutableArray alloc] init];
    
    NSDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    NSString* quiz_code = [NSString stringWithFormat:@"%@",self.quiz_id];
    NSString* studendId = [[UserManager userCenter] getCurrentUser].userId;
    
    [dictionary setValue:quiz_code forKey:@"quiz_code"];
    [dictionary setValue:[@(self.questionIndex) stringValue] forKey:@"question_index"];
    [dictionary setValue:answer forKey:@"option"];
    [dictionary setValue:studendId forKey:@"student_id"];
    
    [data addObject:dictionary];
    
    [self.socket emit:@"answeredQuiz" with:data];
    //                }];
}

@end
