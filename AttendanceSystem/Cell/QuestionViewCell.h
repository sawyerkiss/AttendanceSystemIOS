//
//  QuestionViewCell.h
//  AttendanceSystem
//
//  Created by TrungTruc on 3/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"


@protocol QuestionViewCellDelegate<NSObject>

- (void) changeAnswerValue:(QuestionModel*)question;

@end

@interface QuestionViewCell : UITableViewCell

@property (nonatomic,weak) id<QuestionViewCellDelegate> delegate;

- (void)loadDataForCell:(QuestionModel*)question;

@end
