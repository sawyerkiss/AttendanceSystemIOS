//
//  StudentSessionCell.h
//  AttendanceSystem
//
//  Created by TrungTruc on 3/3/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentModel.h"
#import "CourseModel.h"

@protocol StudentSessionDelegate<NSObject>

-(void)checkStudentAttendanceSession:(StudentModel*)student;

@end

@interface StudentSessionCell : UITableViewCell

- (void)loadDataForCell:(StudentModel*)data;

@property (nonatomic) CourseModel* course;

@property (nonatomic , weak) id<StudentSessionDelegate> delegate;

@end
