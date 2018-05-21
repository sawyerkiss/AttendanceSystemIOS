//
//  CourseModel.h
//  AttendanceSystem
//
//  Created by TamTran on 2/21/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "JsonBaseModel.h"

@interface CourseModel : JsonBaseModel

@property (nonatomic) NSString <Optional> *courseId;
@property (nonatomic) NSString <Optional> *code;
@property (nonatomic) NSString <Optional> *name;
@property (nonatomic) NSString <Optional> *classId;
@property (nonatomic) NSString <Optional> *class_name;
@property (nonatomic) NSString <Optional> *chcid;
@property (nonatomic) NSString <Optional> *total_stud;
@property (nonatomic) NSString <Optional> *schedules;
@property (nonatomic) NSString <Optional> *office_hour;
@property (nonatomic) NSString <Optional> *note;

@property (nonatomic) NSString <Optional> *opening;
@property (nonatomic) NSString <Optional> *attendance_id;
@end
