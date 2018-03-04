//
//  StudentModel.m
//  AttendanceSystem
//
//  Created by TamTran on 3/3/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "StudentModel.h"

@implementation StudentModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"studentId": @"id"
                                                                  }];
}

@end
