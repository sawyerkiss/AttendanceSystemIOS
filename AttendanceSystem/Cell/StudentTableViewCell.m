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

- (void)loadDataForCell:(StudentModel *)student {
    if(student) {
        self.lblCode.text = student.code;
        self.lblName.text = student.name;
    }
}

@end
