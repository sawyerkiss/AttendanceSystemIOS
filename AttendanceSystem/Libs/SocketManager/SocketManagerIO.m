//
//  SocketManager.m
//  AttendanceSystem
//
//  Created by TamTran on 4/7/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "SocketManagerIO.h"



@interface SocketManagerIO()

 @property (nonatomic) SocketManager *manage;
@property (nonatomic) SocketIOClient *socket;
@end

@implementation SocketManagerIO

+ (instancetype)socketManagerIO {
    static SocketManagerIO *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SocketManagerIO alloc] init];
        [manager initClient];
    });
    return manager;
}

- (void)initClient {
    NSString* host = HOST;
    NSURL* url = [[NSURL alloc] initWithString:host];
    NSString* strToken = [[UserManager userCenter] getCurrentUserToken];
    self.manage = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES,@"forcePolling": @YES,@"connectParams": @{@"Authorization":strToken}}];
    self.socket = self.manage.defaultSocket;
}

- (void)connectSocket {
    if(self.socket)
        [self.socket connect];
}

- (void)disconnectSocket {
    if(self.socket)
        [self.socket disconnect];
    }

- (SocketIOClient*)getSocketClient {
    [self initClient];
    return self.socket;
}
@end
