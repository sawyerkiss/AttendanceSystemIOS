//
//  StudentModel.h
//  AttendanceSystem
//
//  Created by TamTran on 3/3/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "JsonBaseModel.h"

@interface StudentModel : JsonBaseModel

@property (nonatomic) NSString <Optional> *studentId;
@property (nonatomic) NSString <Optional> *code;
@property (nonatomic) NSString <Optional> *name;
@property (nonatomic) NSString <Optional> *status;

@end
