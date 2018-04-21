//
//  QuestionModel.h
//  AttendanceSystem
//
//  Created by TrungTruc on 3/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "JsonBaseModel.h"

@protocol QuestionModel;

@interface QuestionModel : JsonBaseModel

@property(nonatomic) NSString<Optional> *questionId;
@property(nonatomic) NSString<Optional> *text;

@property (nonatomic) NSArray<Optional> *answers;

@property (nonatomic) NSString<Optional> *correct_option;
@property (nonatomic) NSString<Optional> *option_a;
@property (nonatomic) NSString<Optional> *option_b;
@property (nonatomic) NSString<Optional> *option_c;
@property (nonatomic) NSString<Optional> *option_d;


@end
