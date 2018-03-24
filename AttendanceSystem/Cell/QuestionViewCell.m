//
//  QuestionViewCell.m
//  AttendanceSystem
//
//  Created by TrungTruc on 3/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "QuestionViewCell.h"
#import <MaterialControls/MDTextField.h>

@interface QuestionViewCell()<MDTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblText;

@property (weak, nonatomic) IBOutlet MDTextField *tfAnswer;

@property (nonatomic) QuestionModel* question;

@end

@implementation QuestionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tfAnswer.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataForCell:(QuestionModel *)question {
    
    
    if(question) {
        self.lblText.text = question.text;
        
        if(question.answer.length > 0)
        self.tfAnswer.text = question.answer;
        
        self.question = question;
    }
    
}

- (BOOL)textField:(MDTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // This allows numeric text only, but also backspace for deletes
    if (string.length > 0 && ![self validateSpecialCharactor:string])
        //![[NSScanner scannerWithString:string] scanInt:NULL])
        return NO;
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
 
    if(newLength == 1) {
        self.question.answer = string;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(changeAnswerValue:)])
            [self.delegate changeAnswerValue:self.question];
    }
    else if (oldLength > 0 && newLength == 0)  {
        self.question.answer = @"";
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(changeAnswerValue:)])
            [self.delegate changeAnswerValue:self.question];
    }
    
    return newLength <= 1;

}

- (BOOL) validateSpecialCharactor: (NSString *) text {
    NSString *Regex = @"[A-Za-z^]*";
    NSPredicate *TestResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [TestResult evaluateWithObject:text];
}

@end
