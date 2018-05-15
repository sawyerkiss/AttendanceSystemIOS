//
//  StudentModel.h
//  AttendanceSystem
//
//  Created by TamTran on 3/3/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "JsonBaseModel.h"

@protocol StudentModel;

@interface StudentModel : JsonBaseModel

@property (nonatomic) NSString <Optional> *studentId;
@property (nonatomic) NSString <Optional> *code;
@property (nonatomic) NSString <Optional> *name;
@property (nonatomic) NSString <Optional> *status;

@property (nonatomic) NSString <Optional> *first_name;
@property (nonatomic) NSString <Optional> *last_name;
@property (nonatomic) NSString <Optional> *stud_id;
@property (nonatomic) NSString <Optional> *person_id;

@property (nonatomic) UIImage <Optional> *face;

@end
