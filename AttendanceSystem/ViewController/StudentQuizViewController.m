//
//  StudentQuizViewController.m
//  AttendanceSystem
//
//  Created by TrungTruc on 3/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "StudentQuizViewController.h"
#import "QuestionModel.h"
#import "QuestionViewCell.h"

static CGFloat const kCellHeightRatio = 70.0f/667.0f;
static CGFloat kCellHeight;

@interface StudentQuizViewController ()<UITableViewDelegate,UITableViewDataSource,QuestionViewCellDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tbleQuestion;

@property (nonatomic) NSArray *questionList;

@end

@implementation StudentQuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.questionList = [[NSArray alloc] init];
    
    kCellHeight = SCREEN_HEIGHT * kCellHeightRatio;
    
    self.tbleQuestion.dataSource = self;
    self.tbleQuestion.delegate = self;
    
    //    [self.tableComments registerNib:[UINib nibWithNibName:kCommentTableViewCell bundle:nil] forCellReuseIdentifier:kCommentCell];
    self.tbleQuestion.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbleQuestion.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    ///Fuck line below will make bounce horizontal on table view/////
    //    self.tableComments.contentInset = UIEdgeInsetsMake(8,16,8,16);
    self.tbleQuestion.showsHorizontalScrollIndicator = FALSE;
    self.tbleQuestion.rowHeight = UITableViewAutomaticDimension;
    self.tbleQuestion.estimatedRowHeight = kCellHeight; // set to whatever your "average" cell height is
    [self.tbleQuestion setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    
    self.title = @"QUIZ";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.questionList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuestionViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionViewCellID"];
    QuestionModel* model = [self.questionList objectAtIndex:indexPath.row];
    
    if(cell) {
        cell.delegate = self;
        [cell loadDataForCell:model];
    }
    
    return cell;
}


- (void)changeAnswerValue:(QuestionModel *)question {
    
    for (QuestionModel* model in self.questionList) {
        if([self.questionList containsObject:model]) {
            model.answers = question.answers;
            break;
        }
    }
    
}
#pragma mark - UITableViewDelegate

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return kCellHeight;
//}


- (void)getQuizListFromId:(NSString*)quizId {
    
    [self showLoadingView];
    
    [[ConnectionManager connectionDefault] getQuizListFromId:quizId success:^(id  _Nonnull responseObject) {
        [self hideLoadingView];
        
        if(!responseObject)
            return;
        
        if([responseObject[@"result"] isEqualToString:@"failure"])
        {
            NSString* error = responseObject[@"message"];
            [self showAlertNoticeWithMessage:error completion:nil];
            return;
        }
        
        NSDictionary* data = responseObject[@"quiz"];
        
        self.questionList = [QuestionModel arrayOfModelsFromDictionaries:data[@"questions"] error:nil];
        
        [self.tbleQuestion reloadData];
        
    } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
        [self hideLoadingView];
        [self showAlertNoticeWithMessage:errorMessage completion:nil];
    }];
    
}



- (IBAction)didTouchSubmitButton:(id)sender {
    
    [self.view endEditing:TRUE];
    
    BOOL isValidate = TRUE;
    
    for (QuestionModel* model in self.questionList) {
        
//        if(model.answers.length == 0)
//        {
//            isValidate = FALSE;
//            break;
//        }
    }
    
    if(isValidate)
    {
        [self showLoadingView];
        
        [[ConnectionManager connectionDefault] submitQuizListWithId:[@(self.quiz_id) stringValue]
                                                            student:@""
                                                       questionList:self.questionList
                                                            success:^(id  _Nonnull responseObject)
         {
             [self hideLoadingView];
             
             if(!responseObject)
                 return;
             
             if([responseObject[@"result"] isEqualToString:@"failure"])
             {
                 NSString* error = responseObject[@"message"];
                 [self showAlertNoticeWithMessage:error completion:nil];
                 return;
             }
             
             [self tappedAtLeftButton:nil];
             
         } andFailure:^(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject) {
             [self hideLoadingView];
             [self showAlertNoticeWithMessage:errorMessage completion:nil];
         }];
        
        
    }
    else {
        [self showAlertNoticeWithMessage:@"You have to answer all questions" completion:nil];
    }
    
    
}


@end
