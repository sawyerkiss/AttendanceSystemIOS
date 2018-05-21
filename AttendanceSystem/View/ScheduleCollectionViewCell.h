//
//  ScheduleCollectionViewCell.h
//  AttendanceSystem
//
//  Created by TamTran on 5/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCollectionViewCell : UICollectionViewCell

- (void)loadData:(NSMutableArray *)lessionArray inCell:(NSInteger) index;


@end
