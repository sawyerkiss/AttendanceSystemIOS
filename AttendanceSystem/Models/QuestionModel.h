//
//  QuestionModel.h
//  AttendanceSystem
//
//  Created by TrungTruc on 3/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "JsonBaseModel.h"

@interface QuestionModel : JsonBaseModel

@property(nonatomic) NSString<Optional> *questionId;
@property(nonatomic) NSString<Optional> *text;

@property (nonatomic) NSString<Optional> *answer;

@end
