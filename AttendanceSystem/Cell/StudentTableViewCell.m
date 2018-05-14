//
//  StudentTableViewCell.m
//  AttendanceSystem
//
//  Created by TamTran on 4/14/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "StudentTableViewCell.h"

@interface StudentTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@property (weak, nonatomic) IBOutlet UILabel *lblCode;
@end

@implementation StudentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataForCell:(StudentModel *)student completeQuiz:(BOOL)isComplete{
    if(student) {
        
        self.lblCode.text = isComplete ? student.stud_id : student.code;
        self.lblName.text = isComplete ? [NSString stringWithFormat:@"%@ %@",student.first_name,student.last_name] :student.name;
    }
}

@end
