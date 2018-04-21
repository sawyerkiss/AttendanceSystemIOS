//
//  QuizModel.h
//  AttendanceSystem
//
//  Created by TamTran on 4/20/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "JsonBaseModel.h"
#import "StudentModel.h"
#import "QuestionModel.h"

//@protocol QuestionModel;

@interface QuizModel : JsonBaseModel

@property(nonatomic) NSString<Optional> *class_has_course_id;
@property(nonatomic) NSString<Optional> *code;
@property(nonatomic) NSArray<StudentModel*><Optional> *participants;
@property(nonatomic) NSArray<QuestionModel*><Optional> *questions;

@property(nonatomic) NSString<Optional> *required_correct_answers;
@property(nonatomic) NSString<Optional> *title;
@property(nonatomic) NSString<Optional> *type;



@end
