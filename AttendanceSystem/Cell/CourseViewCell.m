//
//  CourseViewCell.m
//  AttendanceSystem
//
//  Created by TrungTruc on 2/21/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "CourseViewCell.h"
#import "UIColor+Categories.h"

@interface CourseViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblCourceCode;
@property (weak, nonatomic) IBOutlet UILabel *lblCourseName;
@property (weak, nonatomic) IBOutlet UIButton *btnOpening;

@end


@implementation CourseViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCourseData:(CourseModel *)data {
    
    if(data) {
        self.lblCourceCode.text = [NSString stringWithFormat:@"%@ %@",data.code,data.class_name];
        self.lblCourseName.text = data.name;
        
        if([data.opening isEqualToString:@"1"]) {
            [self.btnOpening setTitle:@"opening" forState:UIControlStateNormal];
            [self.btnOpening setBackgroundColor:[UIColor colorWithHexString:@"#00ff00"]];
        }
        else {
            [self.btnOpening setTitle:@"" forState:UIControlStateNormal];
            [self.btnOpening setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
        }
        
    }
    
}

@end
