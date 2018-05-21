//
//  LessionTableViewCell.m
//  AttendanceSystem
//
//  Created by TamTran on 5/20/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "LessionTableViewCell.h"

@implementation LessionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)loadLessionData:(LessionInfo *)lession{
    
    
    self.lblCourseName.text = [NSString stringWithFormat:@"%@ - %@ - %@",lession.code,lession.name,lession.class_name];
    self.lblContent.text = lession.content;
    self.lblNote.text = lession.note;
    self.lblOfficeHour.text = lession.office_hour;
    
}

@end
