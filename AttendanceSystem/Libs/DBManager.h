//
//  DBManager.h
//  AttendanceSystem
//
//  Created by TrungTruc on 2/21/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModel.h"

@interface DBManager : NSObject
{
    NSString *databasePath;
}

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

+(DBManager*)getSharedInstance;

-(void)insertNewCourse:(CourseModel*)course;
-(NSArray*)getAllCourse;

@end
