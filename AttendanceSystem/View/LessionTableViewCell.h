//
//  LessionTableViewCell.h
//  AttendanceSystem
//
//  Created by TamTran on 5/20/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessionInfo.h"

@interface LessionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCourseName;

@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@property (weak, nonatomic) IBOutlet UILabel *lblNote;
@property (weak, nonatomic) IBOutlet UILabel *lblOfficeHour;

- (void)loadLessionData:(LessionInfo*)lession;
@end
