//
//  LessionInfo.m
//  AttendanceSystem
//
//  Created by TamTran on 5/19/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "LessionInfo.h"

@implementation LessionInfo


-(instancetype)init:(NSString *)code {
    
    self = [super init];
    
    if(self){
        self.code = code;
    }
    
    return self;
    
}

@end
