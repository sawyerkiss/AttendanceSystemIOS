//
//  LessionInfo.h
//  AttendanceSystem
//
//  Created by TamTran on 5/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "JsonBaseModel.h"

@interface LessionInfo : JsonBaseModel

@property (nonatomic) NSString <Optional> *code;
@property (nonatomic) NSString <Optional> *name;
@property (nonatomic) NSString <Optional> *class_name;
@property (nonatomic) NSString <Optional> *office_hour;
@property (nonatomic) NSString <Optional> *note;

@property (nonatomic) NSString <Optional> *content;

@property (nonatomic) BOOL isUnderLine;

-(instancetype)init:(NSString*)code;

@end
