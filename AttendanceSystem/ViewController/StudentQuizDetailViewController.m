//
//  StudentQuizDetailViewController.m
//  AttendanceSystem
//
//  Created by TamTran on 4/7/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "StudentQuizDetailViewController.h"
#import "QuestionModel.h"
#import "QuizModel.h"

@import SocketIO;

@interface StudentQuizDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblQuizTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblQuizQuestion;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctrWidth;
@property (weak, nonatomic) IBOutlet UIButton *buttonA;
@property (weak, nonatomic) IBOutlet UIButton *buttonB;
@property (weak, nonatomic) IBOutlet UIButton *buttonC;
@property (weak, nonatomic) IBOutlet UIButton *buttonD;

@property (nonatomic) NSArray* questions ;

@property (nonatomic) SocketIOClient *socket;

@property (nonatomic) NSUInteger questionIndex;

@property (nonatomic) QuizModel* quiz;

@end

@implementation StudentQuizDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"QUIZ";
    
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    //    });
    
    
    [self showQuestionOrNot:NO];
    
    [[ConnectionManager connectionDefault] getPublishQuiz:self.quiz_id success:^(id  _Nonnull responseObject) {
        self.quiz = [[QuizModel alloc] initWithDictionary:responseObject[@"quiz"] error:nil] ;
        self.questions = [QuestionModel arrayOfModelsFromDictionaries:self.quiz.questions error:nil];
        
        self.title = self.quiz.title;
        
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        
    }];
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
    
    
    [self resetButtonColor];
    
    [self enableButtonOrNot:TRUE];
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
            NSDictionary* dictionary = [data objectAtIndex:0];
            NSString* option = dictionary[@"option"];
            
            NSInteger questionIndex = [[dictionary objectForKey:@"question_index"] integerValue];
            
            QuestionModel* question = [self.questions objectAtIndex:questionIndex];
            if(question) {
                question.answers = @[option];
            }
            
            NSInteger correctAnswer = 0 ;
            if(questionIndex == self.questions.count - 1) {
                for(QuestionModel* question in self.questions) {
                    
                    if(question.answers && question.answers.count > 0)
                    {
                        if([[question.answers objectAtIndex:0] isEqualToString:@"a"])
                        {
                            if([question.option_a isEqualToString:question.correct_option])
                                correctAnswer++;
                        }
                        else  if([[question.answers objectAtIndex:0] isEqualToString:@"b"])
                        {
                            if([question.option_b isEqualToString:question.correct_option])
                                correctAnswer++;
                        }
                        else  if([[question.answers objectAtIndex:0] isEqualToString:@"c"])
                        {
                            if([question.option_c isEqualToString:question.correct_option])
                                correctAnswer++;
                        }
                        else if([[question.answers objectAtIndex:0] isEqualToString:@"d"])
                        {
                            if([question.option_d isEqualToString:question.correct_option])
                                correctAnswer++;
                        }
                    }
                    
                }
                
                BOOL isChecked = FALSE;
                
                if([self.quiz.type isEqualToString:@"0"])
                    isChecked = correctAnswer >= [self.quiz.required_correct_answers integerValue];
                else
                    isChecked = correctAnswer == self.questions.count;
                
                if(isChecked)
                    [self showAlertNoticeWithMessage:@"You've checked attendance" completion:^(NSInteger buttonIndex) {
                        [self tappedAtLeftButton:nil];
                    }];
                else
                    [self showAlertNoticeWithMessage:@"You've not checked attendance" completion:^(NSInteger buttonIndex) {
                        [self tappedAtLeftButton:nil];
                    }];
            }
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
    
    [self resetButtonColor];
    [_buttonA setBackgroundColor:[UIColor greenColor]];
    [self didAnswerWithOption:@"a"];
    
}

- (IBAction)didTouchBButton:(id)sender {
    
    [self resetButtonColor];
    [_buttonB setBackgroundColor:[UIColor greenColor]];
    [self didAnswerWithOption:@"b"];
    
}

- (IBAction)didTouchCButton:(id)sender {
    
    [self resetButtonColor];
    [_buttonC setBackgroundColor:[UIColor greenColor]];
    [self didAnswerWithOption:@"c"];
}

- (IBAction)didTouchDButton:(id)sender {
    
    [self resetButtonColor];
    [_buttonD setBackgroundColor:[UIColor greenColor]];
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
    
    [self enableButtonOrNot:FALSE];
    //                }];
}

- (void)resetButtonColor {
    
    [_buttonA setBackgroundColor:[UIColor blueColor]];
    [_buttonB setBackgroundColor:[UIColor blueColor]];
    [_buttonC setBackgroundColor:[UIColor blueColor]];
    [_buttonD setBackgroundColor:[UIColor blueColor]];
    
}

- (void)enableButtonOrNot:(BOOL)isEnable {
    [_buttonA setEnabled:isEnable];
    [_buttonB setEnabled:isEnable];
    [_buttonC setEnabled:isEnable];
    [_buttonD setEnabled:isEnable];
}

@end
