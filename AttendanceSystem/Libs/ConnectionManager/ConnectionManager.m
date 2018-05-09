//
//  ConnectionManager.m
//  Envoy_App
//
//  Created by Nguyen Xuan Tho on 3/2/17.
//  Copyright © 2017 Keaz. All rights reserved.
//

#import "ConnectionManager.h"
#import "AFHTTPSessionManager.h"
#import "QuestionModel.h"

//Link API
static NSString *const kLogin = @"authenticate/login";
static NSString *const kLogout = @"authenticate/logout";
static NSString *const kRegister = @"user";
static NSString *const kTeachingCourseList = @"api/course/teaching";
static NSString *const kStudyingCourseList = @"api/course/studying";
static NSString *const kOpeningCourseListByTeacher = @"api/attendance/opening-by-teacher";
static NSString *const kOpeningCourseListForStudent = @"api/attendance/opening-for-student";
static NSString *const kRetrieveStudent = @"api/attendance/check-attendance";
static NSString *const kAttendanceChecklist = @"api/check-attendance/check-list";
static NSString *const kCheckDelegateCode = @"api/attendance/check-delegate-code";
static NSString *const kGetDelegateCode = @"api/attendance/generate-delegate-code";
static NSString *const kCreateAttendance = @"api/attendance/create";
static NSString *const kCancelAttendance = @"api/attendance/delete";
static NSString *const kFinishAttendance = @"api/attendance/close";
static NSString *const kChangePassword = @"api/user/change-password";
static NSString *const kGenerateQRCode = @"api/check-attendance/qr-code/%@";
static NSString *const kForgotPassword = @"authenticate/forgot-password";
static NSString *const kSendAbsenceRequest = @"api/absence-request/create";
static NSString *const kSendFeedbackRequest = @"api/feedback/send";
static NSString *const kCheckQuizCode = @"api/quiz/join";
static NSString *const kGetQuizDetail = @"api/quiz/detail";
static NSString *const kSubmitQuizList = @"api/quiz/submit";
static NSString *const kGetPublishQuiz = @"api/quiz/published";
static NSString *const kGetQuizList = @"api/quiz/list";
static NSString *const kStartQuiz = @"api/quiz/start";
static NSString *const kGetDisplayQuiz = @"api/quiz/display";
static NSString *const kGetStudentDetail =  @"api/student/detail/%@";
static NSString *const kUploadStudentFace = @"api/student/uploadFace";
static NSString *const kUploadFaceImage = @"https://api.imgur.com/3/upload";
//Header
static NSString *kHeaderSourceHostKey = @"X-SOURCE-HOST";
static NSString *kHeaderTokenKey = @"Token";
static NSString *kHeaderAppVersion = @"version";
static NSString *kHeaderAppName = @"app_name";
static NSString *kHeaderDeviceType = @"device_type";

//Parameter


//Error
static NSString *const kErrorResponseData = @"com.alamofire.serialization.response.error.data";
static NSString *const kErrorResponse = @"com.alamofire.serialization.response.error.response";
static NSString *const kErrorDescription = @"description";
static NSString *const kErrorCode = @"code";
static NSString *const kErrorTitle = @"title";
static NSString *const kErrorData = @"data";
static NSString *const kErrorAccount = @"user_account";
static NSString *const kErrorPending = @"user_pending";
static NSString *const kErrorToken = @"token_required";
static NSString *const kErrorPassword = @"user_password";
static NSString *const kErrorUserExist = @"user_exist";
static NSString *const kErrorInThePast = @"in_the_past";
static NSString *const kErrorOutUpdate = @"booking_out_update";
static NSString *const kErrorUserId = @"id";
static NSString *const kErrorBookingIsTooShort = @"booking_too_short";
static NSString *const kErrorBookingDriverExpired = @"booking_driver_expired";
static NSString *const kErrorBookingDriverEmpty = @"booking_driver_empty";
static NSString *const kErrorBookingPaymentEmpty = @"booking_payment_empty";
static NSString * const kErrorSSOLogin = @"sso_login";
static NSString *const kErrorSSORegister = @"sso_register";
static NSString *const kErrorCompanyNotExist = @"company_not_exist";
//Others
static NSString *const kEndPointLink = @"End point link";
static NSString *const kXSourceHost = @"X source host";

NSString *linkService(NSString *subLink) {
    NSString *endPointLink =
    //@"http://192.168.1.107:3000/";
    @"https://iteccyle8.herokuapp.com/";
    //[[NSBundle mainBundle] objectForInfoDictionaryKey:kEndPointLink];
    
    return [endPointLink stringByAppendingString:subLink];
}

@interface ConnectionManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation ConnectionManager

+ (instancetype)connectionDefault {
    static ConnectionManager *connection = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connection = [[self alloc] initPrivate];
    });
    return connection;
}

- (instancetype)initPrivate {
    self = [self init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager.requestSerializer.timeoutInterval = 20.0f;
        
//        [self.sessionManager.requestSerializer setValue:kXSourceHost forHTTPHeaderField:kHeaderSourceHostKey];
        
//        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        [self.sessionManager.requestSerializer setValue:version forHTTPHeaderField:kHeaderAppVersion];
//
//        [self.sessionManager.requestSerializer setValue:kAppName forHTTPHeaderField:kHeaderAppName];
//        [self.sessionManager.requestSerializer setValue:kDeviceType forHTTPHeaderField:kHeaderDeviceType];
    }
    
    return self;
}

- (void)setSourceHost:(NSString *)host {
    NSLog(@"source host : %@",host);
    if(host.length == 0)
        host = [[NSBundle mainBundle] objectForInfoDictionaryKey:kXSourceHost];
    [self.sessionManager.requestSerializer setValue:host forHTTPHeaderField:kHeaderSourceHostKey];
}

- (void)handleResponseData:(id)responseObject
                andSuccess:(ConnectionComplete)success {
    //#if DEBUG
    //    NSError *error = nil;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
    //                                                       options:NSJSONWritingPrettyPrinted
    //                                                         error:&error];
    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSLog(@"Sucess ---- %@", jsonString);
    //#endif
    if (success) {
        success(responseObject);
    }
}

- (void)handleResponseError:(NSError *)error
                 andFailure:(ConnectionFailure)failure {
    if (failure) {
        ErrorType errorType = ErrorType_Other;
        NSString *errorMessage = @"";
        id responseObject = nil;
        
        if (error.code == kCFURLErrorNotConnectedToInternet) {
            errorType = ErrorType_NoNetwork;
        } else if (error.code == kCFURLErrorTimedOut) {
            errorType = ErrorType_TimeOut;
        } else {
            NSData *data = error.userInfo[kErrorResponseData];
            if (data) {
                //#if DEBUG
                //                NSString *errorString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //                NSLog(@"Error ---- %@", errorString);
                //#endif
                NSError *jsonError;
                NSDictionary *dataResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:kNilOptions
                                                                               error:&jsonError];
                if (jsonError) {
                    errorType = ErrorType_InternalServerError;
                } else {
                    if ([dataResponse objectForKey:kErrorCode]) {
                        NSString *errorCode = dataResponse[kErrorCode];
                        if ([errorCode isEqualToString:kErrorAccount]) {
                            errorType = ErrorType_UserNotFound;
                        } else if ([errorCode isEqualToString:kErrorPending]) {
                            errorType = ErrorType_NotActive;
                        } else if([errorCode isEqualToString:kErrorToken]) {
                            errorType  = ErrorType_TokenFail;
                        } else if ([errorCode isEqualToString:kErrorPassword]) {
                            errorType = ErrorType_Password;
                        } else if ([errorCode isEqualToString:kErrorInThePast]) {
                            errorType = ErrorType_InThePast;
                        } else if ([errorCode isEqualToString:kErrorOutUpdate]) {
                            errorType = ErrorType_OutUpdate;
                        } else if ([errorCode isEqualToString:kErrorBookingIsTooShort]) {
                            errorType = ErrorType_BookingIsTooShort;
                        } else if([errorCode isEqualToString:kErrorUserExist]) {
                            errorType = ErrorType_UserExist;
                        } else if([errorCode isEqualToString:kErrorBookingDriverExpired]) {
                            errorType = ErrorType_BookingDriverExpired;
                        } else if([errorCode isEqualToString:kErrorBookingDriverEmpty]) {
                            errorType = ErrorType_BookingDriverEmpty;
                        } else if([errorCode isEqualToString:kErrorBookingPaymentEmpty]) {
                            errorType = ErrorType_BookingPaymentEmpty;
                        } else if([errorCode isEqualToString:kErrorSSOLogin]) {
                            errorType = ErrorType_SSOLogin;
                        } else if([errorCode isEqualToString:kErrorSSORegister]) {
                            errorType = ErrorType_SSORegister;
                        } else if([errorCode isEqualToString:kErrorCompanyNotExist]) {
                            errorType = ErrorType_CompanyNotExist;
                        }
                        else {
                            errorType = ErrorType_Other;
                        }
                    }
                    if ([dataResponse objectForKey:kErrorDescription]) {
                        errorMessage = dataResponse[kErrorDescription];
                    }
                    // Special message for kErrorInThePast
                    if (errorType == ErrorType_InThePast) {
                        errorMessage = SERVER_ERROR_MSG; //NSLocalizedString(@"bookingScreen.inThePast", nil);
                    }
                    
                    if ([dataResponse objectForKey:kErrorData]) {
                        responseObject = dataResponse[kErrorData];
                    }
                }
            }
        }
        if (errorType == ErrorType_InternalServerError ||
            errorType == ErrorType_TokenFail ||
            errorType == ErrorType_NoNetwork ||
            errorType == ErrorType_TimeOut) {
            [self cancelAllRequest];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:NOTIFICATION_CONECTION_ERROR
             object:nil
             userInfo:@{USER_INFO_ERROR_TYPE:[NSNumber numberWithUnsignedInteger:errorType]}];
            
        }
        
        if(errorMessage.length == 0)
            errorMessage = SERVER_ERROR_MSG;
        
        failure(errorType, errorMessage, responseObject);
    }
}

- (void)setTokenHeaderWithValue:(NSString *)token {
    NSLog(@"Connection Manager => token : %@", token);
    [self.sessionManager.requestSerializer setValue:token forHTTPHeaderField:kHeaderTokenKey];
}

- (void)cancelAllRequest {
    NSArray *allTask = [self.sessionManager tasks];
    if ([allTask count] > 0) {
        for (NSURLSessionDataTask *task in allTask) {
            [task cancel];
        }
    }
}

- (void)login:(NSString *)username password:(NSString *)password andSuccess:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSDictionary *parameter = @{@"username": username, @"password" : password};
    
    NSString* url = linkService(kLogin);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)logout:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @""};
    
    NSString* url = linkService(kLogout);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)getTeachingCourseList:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @""};
    
    NSString* url = linkService(kTeachingCourseList);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)getStudyingCourseList:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @""};
    
    NSString* url = linkService(kStudyingCourseList);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)getOpeningCourseByTeacher:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSString* userId = [[UserManager userCenter] getCurrentUser].userId;
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"teacher_id": userId,
                                @"isMobile":@1
                                };
    
    NSString* url = linkService(kOpeningCourseListByTeacher);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)getStudentCourseWithAttendance:(NSString *)attendanceId success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"attendance_id": attendanceId
                                };
    
    NSString* url = linkService(kRetrieveStudent);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)syncAttendanceChecklistWithStudentId:(NSString *)studenId
                                attendanceId:(NSString *)attendanceId
                              attendanceType:(NSString *)attendanceType
                                     success:(ConnectionComplete)success
                                  andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"student_id":studenId,
                                @"attendance_id": attendanceId,
                                @"attendance_type":attendanceType
                                };
    
    NSString* url = linkService(kAttendanceChecklist);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)submitDelegateCodeWithCode:(NSString *)code success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"code": code
                                };
    
    NSString* url = linkService(kCheckDelegateCode);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)getDelegateCode:(CourseModel*)course success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"class_id":course.classId,
                                @"course_id":course.courseId
                                };
    
    NSString* url = linkService(kGetDelegateCode);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)createAttendanceCourse:(CourseModel *)course success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"class_id":course.classId,
                                @"course_id":course.courseId
                                };
    
    NSString* url = linkService(kCreateAttendance);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)finishAttendanceCourseWithId:(NSString *)attendance success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"attendance_id":attendance
                                };
    
    NSString* url = linkService(kFinishAttendance);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)cancelAttendanceCourseWithId:(NSString *)attendance success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"attendance_id":attendance
                                };
    
    NSString* url = linkService(kCancelAttendance);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)changePasswordWithCurrentPassword:(NSString *)current newPassword:(NSString *)newPassword success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"current_password":current,
                                @"confirm_password":newPassword,
                                @"new_password":newPassword
                                };
    
    NSString* url = linkService(kChangePassword);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (NSString*)getQRCodeText:(NSString *)attendanceId {
    
    NSString* url = [NSString stringWithFormat:linkService(kGenerateQRCode),attendanceId];
    
    NSLog(@"url : %@" ,url);
    
    return url;
    
}

- (void)checkAttendanceByQRCodeWithURL:(NSString*)url success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @""
                                };
    NSLog(@"url : %@" ,url);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
    
}

- (void)requestForgetPasswordWithEmail:(NSString *)email success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    
//    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSString* url = linkService(kForgotPassword);
    
    NSDictionary *parameter = @{@"email": email};
    NSLog(@"url : %@" ,url);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
    
}

- (void)sendAbsenceRequestWithReason:(NSString *)reson
                           startDate:(NSString *)startDate
                             endDate:(NSString *)endDate
                             success:(ConnectionComplete)success
                          andFailure:(ConnectionFailure)failure {
    NSString* url = linkService(kSendAbsenceRequest);
    
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"reason" : reson,
                                @"start_date" : startDate,
                                @"end_date" :endDate
                                };
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@",parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)sendFeedbackRequestWithTitle:(NSString *)title
                             content:(NSString *)content
                         isAnonymous:(BOOL)isAnonymous
                             success:(ConnectionComplete)success
                          andFailure:(ConnectionFailure)failure {
    
    NSString* url = linkService(kSendFeedbackRequest);
    
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    
    [self.sessionManager.requestSerializer setValue:token forHTTPHeaderField:@"x-access-token"];
    
    NSDictionary *parameter = @{
                                @"category" : @1 ,
//                                @"token": token ? token : @"",
                                @"title" : title,
                                @"content" : content,
                                @"to_id" : @"0"
                                };
    
    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
    
    NSInteger userRole = [[[UserManager userCenter] getCurrentUser].role_id integerValue];
    
    [newDict addEntriesFromDictionary:parameter];
    if(userRole == STUDENT){
        if(isAnonymous)
            [newDict setObject:@"true" forKey:@"isAnonymous"];
        else
             [newDict setObject:@"false" forKey:@"isAnonymous"];
    }
    
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@",newDict);
    
    [self.sessionManager POST:url
                   parameters:newDict
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)checkQuizCodeWithCode:(NSString *)code success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"code": code
                                };
    
    NSString* url = linkService(kCheckQuizCode);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)getQuizListFromId:(NSString *)quizId success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"quiz_id": quizId
                                };
    
    NSString* url = linkService(kGetQuizList);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)submitQuizListWithId:(NSString *)quizId
                     student:(NSString *)studentId
                questionList:(NSArray *)questionList
                     success:(ConnectionComplete)success
                  andFailure:(ConnectionFailure)failure {
    
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"student_id": studentId
                                };
    
    NSDictionary *quizParam = @{@"id":quizId ,
                                @"questions":[QuestionModel arrayOfDictionariesFromModels:questionList]
                                };
    
    [parameter setValue:quizParam forKey:@"quiz"];
    
    NSString* url = linkService(kSubmitQuizList);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
    
}

- (void)getPublishQuiz:(NSString *)quizCode success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"quiz_code": quizCode
                                };
    
    NSString* url = linkService(kGetPublishQuiz);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)getQuizListFromId:(NSString *)courseId
                  classId:(NSString *)classId
                  success:(ConnectionComplete)success
               andFailure:(ConnectionFailure)failure {
    
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"course_id" : courseId,
                                @"class_id" : classId
                                };
    
    NSString* url = linkService(kGetQuizList);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
    
}

- (void)startQuizWithId:(NSString *)quizCode success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"quiz_code" : quizCode
                                };
    
    NSString* url = linkService(kStartQuiz);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

//- (void)getDisplayQuizWithSuccess:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
//   
//    NSString* token = [[UserManager userCenter] getCurrentUserToken];
//    NSDictionary *parameter = @{@"token": token ? token : @"",
//                                @"quiz_id" : quizId
//                                };
//    
//    NSString* url = linkService(kStartQuiz);
//    NSLog(@"url : %@" ,url);
//    NSLog(@"parameter : %@" , parameter);
//    
//    [self.sessionManager POST:url
//                   parameters:parameter
//                     progress:nil
//                      success:
//     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         [self handleResponseData:responseObject andSuccess:success];
//     }
//                      failure:
//     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         [self handleResponseError:error andFailure:failure];
//     }];
//    
//}

- (void)getStudentDetailWithId:(NSString *)studentId success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @""
                                };
    
    NSString* url = [NSString stringWithFormat:linkService(kGetStudentDetail),studentId];
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager GET:url
                   parameters:parameter
                     progress:nil
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)uploadFaceForStudent:(NSString *)personId faceId:(NSString *)faceId faceImage:(NSString *)faceUrl success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
    NSString* token = [[UserManager userCenter] getCurrentUserToken];
    NSDictionary *parameter = @{@"token": token ? token : @"",
                                @"person_id" :personId,
                                @"face_id" : faceId,
                                @"face_image" : faceUrl
                                };
    
    NSString* url = linkService(kUploadStudentFace);
    NSLog(@"url : %@" ,url);
    NSLog(@"parameter : %@" , parameter);
    
    [self.sessionManager POST:url
                  parameters:parameter
                    progress:nil
                     success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                     failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

- (void)uploadImageToAPI:(NSData *)imageData success:(ConnectionComplete)success andFailure:(ConnectionFailure)failure {
//    NSString* data = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
//    NSURLComponents* urlComponents = [[NSURLComponents alloc] initWithString:kUploadFaceImage];
//    NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"type" value:@"base64"];
//    NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"image" value:data];
//    urlComponents.queryItems = @[item1,item2];
//
//    NSURL* url = urlComponents.URL;
//
//    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request setValue:[@"Client-ID " stringByAppendingString:@"8037a5266e3e44d"] forHTTPHeaderField:@"Authorization"];
//    request.HTTPMethod = @"POST";
//
//    NSURLSession* session = [NSURLSession sharedSession];
//    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        if(response)
//             [self handleResponseData:response andSuccess:success];
//        else
//             [self handleResponseError:error andFailure:failure];
//
//    }];
//
//    [task resume];
    
    UserModel* user = [[UserManager userCenter] getCurrentUser];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [sessionManager.requestSerializer setValue:[@"Client-ID " stringByAppendingString:@"8037a5266e3e44d"] forHTTPHeaderField:@"Authorization"];
    
     NSString* data = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary* parameters = @{@"type":@"base64" ,
                                 @"image":data
                                 };
    
    [sessionManager POST:kUploadFaceImage
                   parameters:parameters
    constructingBodyWithBlock:
     ^(id<AFMultipartFormData>  _Nonnull formData) {
         NSData *data = imageData;
         
         [formData appendPartWithFileData:data
                                     name:user.userId
                                 fileName:[NSString stringWithFormat:@"%@.jpg",user.userId]
                                 mimeType:@"image/jpeg"];
     }
                     progress:
     ^(NSProgress * _Nonnull uploadProgress) {
        
     }
                      success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self handleResponseData:responseObject andSuccess:success];
     }
                      failure:
     ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleResponseError:error andFailure:failure];
     }];
}

@end
