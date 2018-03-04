//
//  CourseModel.m
//  AttendanceSystem
//
//  Created by TamTran on 2/21/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel


+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"courseId": @"id",
                                                                  @"classId":@"class"
                                                                  }];
}



@end
