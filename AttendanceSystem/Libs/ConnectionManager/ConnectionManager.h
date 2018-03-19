//
//  ConnectionManager.h
//  Envoy_App
//
//  Created by Nguyen Xuan Tho on 3/2/17.
//  Copyright © 2017 Keaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"

OS_ASSUME_NONNULL_BEGIN

typedef void(^ConnectionProgress)(NSProgress * _Nullable uploadProgress);
typedef void(^ConnectionComplete)(id  _Nonnull responseObject);
typedef void(^ConnectionFailure)(ErrorType errorType, NSString * _Nonnull errorMessage, id  _Nullable responseObject);


@interface ConnectionManager : NSObject

+ (_Nonnull instancetype)connectionDefault;

- (void)setTokenHeaderWithValue:(NSString * _Nonnull)token;
- (void)setSourceHost:(NSString* _Nonnull)host;

- (void)login:(NSString * _Nullable)username
     password:(NSString * _Nonnull)password
   andSuccess:(ConnectionComplete _Nullable)success
   andFailure:(ConnectionFailure _Nullable)failure;

- (void)logout:(ConnectionComplete _Nullable)success
   andFailure:(ConnectionFailure _Nullable)failure;

- (void)getTeachingCourseList:(ConnectionComplete _Nullable)success
                   andFailure:(ConnectionFailure _Nullable)failure;

- (void)getStudyingCourseList:(ConnectionComplete _Nullable)success
                   andFailure:(ConnectionFailure _Nullable)failure;

- (void)getOpeningCourseByTeacher:(ConnectionComplete _Nullable)success
                       andFailure:(ConnectionFailure _Nullable)failure;

- (void)getStudentCourseWithAttendance:(NSString*)attendanceId
                               success:(ConnectionComplete _Nullable)success
                            andFailure:(ConnectionFailure _Nullable)failure;

- (void)syncAttendanceChecklistWithStudentId:(NSString*)studenId
                                attendanceId:(NSString*)attendanceId
                              attendanceType:(NSString*)attendanceType
                                     success:(ConnectionComplete _Nullable)success
                                  andFailure:(ConnectionFailure _Nullable)failure;

- (void)submitDelegateCodeWithCode:(NSString*)code
                           success:(ConnectionComplete _Nullable)success
                        andFailure:(ConnectionFailure _Nullable)failure;

- (void)getDelegateCode:(CourseModel*)course success:(ConnectionComplete _Nullable)success
             andFailure:(ConnectionFailure _Nullable)failure;

- (void)createAttendanceCourse:(CourseModel*)course success:(ConnectionComplete _Nullable)success
andFailure:(ConnectionFailure _Nullable)failure;

- (void)finishAttendanceCourseWithId:(NSString*)attendance success:(ConnectionComplete _Nullable)success
                           andFailure:(ConnectionFailure _Nullable)failure;

- (void)cancelAttendanceCourseWithId:(NSString*)attendance success:(ConnectionComplete _Nullable)success
                          andFailure:(ConnectionFailure _Nullable)failure;

- (void)changePasswordWithCurrentPassword:(NSString*)current newPassword:(NSString*)newPassword success:(ConnectionComplete _Nullable)success
                               andFailure:(ConnectionFailure _Nullable)failure;

- (NSString*)getQRCodeText:(NSString*)attendanceId;

- (void)checkAttendanceByQRCodeWithURL:(NSString*)url success:(ConnectionComplete _Nullable)success
                     andFailure:(ConnectionFailure _Nullable)failure;

- (void)requestForgetPasswordWithEmail:(NSString*)email success:(ConnectionComplete _Nullable)success
                            andFailure:(ConnectionFailure _Nullable)failure;

- (void)sendAbsenceRequestWithReason:(NSString*)reson
                           startDate:(NSString*)startDate
                             endDate:(NSString*)endDate
                             success:(ConnectionComplete _Nullable)success
                          andFailure:(ConnectionFailure _Nullable)failure;

- (void)sendFeedbackRequestWithTitle:(NSString*)title
                             content:(NSString*)content
                         isAnonymous:(BOOL)isAnonymous
                             success:(ConnectionComplete _Nullable)success
                          andFailure:(ConnectionFailure _Nullable)failure;

@end
OS_ASSUME_NONNULL_END
