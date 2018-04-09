//
//  SocketManager.h
//  AttendanceSystem
//
//  Created by TamTran on 4/7/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import <Foundation/Foundation.h>

@import SocketIO;

@interface SocketManagerIO : NSObject

+ (instancetype)socketManagerIO;

- (void)connectSocket;
- (void)disconnectSocket;


- (SocketIOClient*)getSocketClient;
@end
