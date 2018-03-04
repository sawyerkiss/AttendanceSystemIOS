//
//  SessionViewCell.m
//  AttendanceSystem
//
//  Created by TrungTruc on 3/1/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "SessionViewCell.h"

@interface SessionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;

@end

@implementation SessionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)loadDataForCell:(NSString *)title value:(NSString *)value {
    self.lblTitle.text = title;
    self.lblValue.text = value;
}

@end
