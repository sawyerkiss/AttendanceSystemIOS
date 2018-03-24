//
//  QuestionModel.m
//  AttendanceSystem
//
//  Created by TrungTruc on 3/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"questionId": @"id"
                                                                  }];
}

-(BOOL) isEqual:(id)object {
    QuestionModel* model = object;
    return [model.questionId isEqualToString:self.questionId];
}

@end
