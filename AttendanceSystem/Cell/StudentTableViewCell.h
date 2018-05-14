//
//  StudentTableViewCell.h
//  AttendanceSystem
//
//  Created by TamTran on 4/14/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentModel.h"

@interface StudentTableViewCell : UITableViewCell

-(void)loadDataForCell:(StudentModel*)student completeQuiz:(BOOL) isComplete;

@end
