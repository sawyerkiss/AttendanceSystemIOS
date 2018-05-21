//
//  DBManager.m
//  AttendanceSystem
//
//  Created by TrungTruc on 2/21/18.
//  Copyright © 2018 TrungTruc. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>


static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
static DBManager *sharedInstance = nil;
static  NSString *DATABASE_NAME = @"QLDD.db";
static int DATABASE_VERSION = 1;
static NSString *COLUMN_ID  = @"id";

//user table
 static NSString *TABLE_USER = @"user";
 static NSString *COLUMN_USER_LAST_NAME = @"last_name";
 static NSString *COLUMN_USER_FIRST_NAME = @"first_name";
 static NSString *COLUMN_USER_EMAIL = @"email";
 static NSString *COLUMN_USER_PHONE = @"phone";
 static NSString *COLUMN_USER_ROLE = @"role_id";

// courses table
 static NSString *TABLE_COURSES = @"courses";
 static NSString *COLUMN_COURSE_CODE = @"code";
 static NSString *COLUMN_COURSE_NAME = @"name";
 static NSString *COLUMN_COURSE_CLASS_ID = @"class_id";
 static NSString *COLUMN_COURSE_CLASS_NAME = @"class_name";
 static NSString *COLUMN_COURSE_CLASS_HAS_COURSE_ID = @"class_has_course_id";
 static NSString *COLUMN_COURSE_TOTAL_STUD = @"total_stud";
 static NSString *COLUMN_COURSE_OPEN = @"open";
 static NSString *COLUMN_COURSE_ATTENDANCE_ID = @"attendance_id";
 static NSString *COLUMN_COURSE_SCHEDULE = @"schedule";
 static NSString *COLUMN_COURSE_OFFICE_HOUR = @"office_hour";
 static NSString *COLUMN_COURSE_NOTE = @"note";

//attendance detail table
 static NSString *TABLE_ATTENDANCE_DETAIL = @"attendance";
 static NSString *COLUMN_ATTENDANCE_STUDENT_ID = @"student_id";
 static NSString *COLUMN_ATTENDANCE_STUDENT_NAME = @"student_name";
 static NSString *COLUMN_ATTENDANCE_STUDENT_CODE = @"student_code";
 static NSString *COLUMN_ATTENDANCE_ATTENDANCE_ID = @"attendance_id";
 static NSString *COLUMN_ATTENDANCE_CLASS_HAS_COURSE_ID = @"class_has_course_id";
 static NSString *COLUMN_ATTENDANCE_STATUS = @"status";

//-----------------------------------------------------------------------
// TODO: tao moi moi xoa detail attendance de khi office dung cai dd cu~
// classes
 static NSString * TABLE_CLASSES  = @"classes";
 static NSString * COLUMN_CLASS_NAME  = @"class_name";
// students table
 static NSString * TABLE_STUDENTS = @"students";
 static NSString * COLUMN_STUDENTS_CODE = @"stud_id";
 static NSString * COLUMN_STUDENTS_CLASS_ID = @"class_id";
 static NSString * COLUMN_STUDENTS_LAST_NAME = @"last_name";
 static NSString * COLUMN_STUDENTS_FIRST_NAME = @"first_name";
// class_has_course
 static NSString * TABLE_CLASS_HAS_COURSE = @"class_has_course";
 static NSString * COLUMN_CLASS_HAS_COURSE_CLASS_ID = @"class_id";
 static NSString * COLUMN_CLASS_HAS_COURSE_COURSE_ID = @"course_id";
 static NSString * COLUMN_CLASS_HAS_COURSE_TOTAL_STUD = @"total_stud";
//sync table
 static NSString * TABLE_SYNC = @"sync";
 static NSString * COLUMN_SYNC_TASK_NAME = @"name";
 static NSString * COLUMN_SYNC_OBJECT_ID = @"object_id";
 static NSString * COLUMN_SYNC_ACTION = @"action";
 static NSString * COLUMN_SYNC_CREATED = @"created_at";

static  NSInteger matrix[] = {6,12,18,24,7,13,19,25,8,14,20,26,9,15,21,27,10,16,22,28,11,17,23,29};

@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

-(void)copyDatabaseIntoDocumentsDirectory;

@property (nonatomic, strong) NSMutableArray *arrResults;


-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end

@implementation DBManager


+(DBManager*)getSharedInstance {
    if (!sharedInstance) {
        sharedInstance = [[DBManager alloc] initWithDatabaseFilename:DATABASE_NAME];
        [sharedInstance createDB:DATABASE_NAME];
    }
    return sharedInstance;
}

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        // Set the documents directory path to the documentsDirectory property.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.databaseFilename = dbFilename;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
        
        [self createDB:dbFilename];

    }
    return self;
}

-(BOOL)createDB:(NSString *)dbFilename{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: dbFilename]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            char *errMsg;
//            const char *sql_stmt = "create table if not exists studentsDetail (regno integer primary key, name text, department text, year text)";
            
            NSString *CREATE_USER_TABLE = @"create table if not exists %@ ( %@ integer primary key, %@ integer, %@ string, %@ string, %@  string, %@ string)";
            
//            const char *sql_stmt = "create table "
//            + TABLE_USER + "(" + COLUMN_ID + " integer primary key, "
//            + COLUMN_USER_ROLE + " integer, "
//            + COLUMN_USER_EMAIL + " string, "
//            + COLUMN_USER_LAST_NAME + " string, "
//            + COLUMN_USER_FIRST_NAME + " string, "
//            + COLUMN_USER_PHONE + " string)";
            
            CREATE_USER_TABLE = [NSString stringWithFormat:
                                 CREATE_USER_TABLE,
                                 TABLE_USER,
                                 COLUMN_ID,
                                 COLUMN_USER_ROLE,
                                 COLUMN_USER_EMAIL,
                                 COLUMN_USER_LAST_NAME,
                                 COLUMN_USER_FIRST_NAME,
                                 COLUMN_USER_PHONE];
            
            const char *sql_create_user_table =  [CREATE_USER_TABLE UTF8String];
            
            
            NSString *CREATE_COURSE_TABLE = @"create table if not exists %@ ( %@ string, %@ string, %@ string, %@ string, %@  string, %@ string primary key, %@ string, %@ string, %@ string, %@ string, %@ string, %@ string)";
            
//            String CREATE_COURSE_TABLE = "create table "
//            + TABLE_COURSES + "(" + COLUMN_ID + " integer, "
//            + COLUMN_COURSE_CODE + " string, "
//            + COLUMN_COURSE_NAME + " string, "
//            + COLUMN_COURSE_CLASS_ID + " integer, "
//            + COLUMN_COURSE_CLASS_NAME + " string, "
//            + COLUMN_COURSE_CLASS_HAS_COURSE_ID + " integer primary key, "
//            + COLUMN_COURSE_TOTAL_STUD + " integer, "
//            + COLUMN_COURSE_OPEN + " integer, "
//            + COLUMN_COURSE_ATTENDANCE_ID + " integer,"
//            + COLUMN_COURSE_SCHEDULE + " string, "
//            + COLUMN_COURSE_OFFICE_HOUR + " string, "
//            + COLUMN_COURSE_NOTE + " string)";
            
            CREATE_COURSE_TABLE = [NSString stringWithFormat:
                                   CREATE_COURSE_TABLE,
                                   TABLE_COURSES,
                                   COLUMN_ID,
                                   COLUMN_COURSE_CODE,
                                   COLUMN_COURSE_NAME,
                                   COLUMN_COURSE_CLASS_ID,
                                   COLUMN_COURSE_CLASS_NAME,
                                   COLUMN_COURSE_CLASS_HAS_COURSE_ID,
                                   COLUMN_COURSE_TOTAL_STUD,
                                   COLUMN_COURSE_OPEN,
                                   COLUMN_COURSE_ATTENDANCE_ID,
                                   COLUMN_COURSE_SCHEDULE,
                                   COLUMN_COURSE_OFFICE_HOUR,
                                   COLUMN_COURSE_NOTE];
            
            const char *sql_create_course_table =  [CREATE_COURSE_TABLE UTF8String];
            
            NSString *CREATE_ATTENDANCE_TABLE = @"create table if not exists %@ ( %@ integer, %@ string, %@ integer, %@ integer, %@ integer, %@ integer, PRIMARY KEY( %@,%@))";
            
//            String CREATE_ATTENDANCE_TABLE = "create table "
//            + TABLE_ATTENDANCE_DETAIL + "("
//            + COLUMN_ATTENDANCE_STUDENT_ID + " integer, "
//            + COLUMN_ATTENDANCE_STUDENT_NAME + " string, "
//            + COLUMN_ATTENDANCE_STUDENT_CODE + " integer, "
//            + COLUMN_ATTENDANCE_ATTENDANCE_ID + " integer, "
//            + COLUMN_ATTENDANCE_CLASS_HAS_COURSE_ID + " integer, "
//            + COLUMN_ATTENDANCE_STATUS + " integer, "
//            + "PRIMARY KEY(" + COLUMN_ATTENDANCE_ATTENDANCE_ID + "," + COLUMN_ATTENDANCE_STUDENT_ID + "))";
            
            CREATE_ATTENDANCE_TABLE = [NSString stringWithFormat:
                                       CREATE_ATTENDANCE_TABLE,
                                       TABLE_ATTENDANCE_DETAIL,
                                       COLUMN_ATTENDANCE_STUDENT_ID,
                                       COLUMN_ATTENDANCE_STUDENT_NAME,
                                       COLUMN_ATTENDANCE_STUDENT_CODE,
                                       COLUMN_ATTENDANCE_ATTENDANCE_ID,
                                       COLUMN_ATTENDANCE_CLASS_HAS_COURSE_ID,
                                       COLUMN_ATTENDANCE_STATUS,
                                       COLUMN_ATTENDANCE_ATTENDANCE_ID,
                                       COLUMN_ATTENDANCE_STUDENT_ID];
            
            const char *sql_create_attendance_table =  [CREATE_ATTENDANCE_TABLE UTF8String];
            //--------------------------------------------------------------
            
            NSString *CREATE_SYNC_TABLE = @"create table if not exists %@ ( %@ integer primary key autoincrement, %@ string, %@ integer, %@ integer, %@ string)";
//            String CREATE_SYNC_TABLE = "create table "
//            + TABLE_SYNC + "(" + COLUMN_ID + " integer primary key autoincrement, "
//            + COLUMN_SYNC_TASK_NAME + " string, "
//            + COLUMN_SYNC_OBJECT_ID + " integer, "
//            + COLUMN_SYNC_ACTION + " integer, "
//            + COLUMN_SYNC_CREATED + "string)";
            
            CREATE_SYNC_TABLE = [NSString stringWithFormat:CREATE_SYNC_TABLE,
                                 TABLE_SYNC,
                                 COLUMN_ID,
                                 COLUMN_SYNC_TASK_NAME,
                                 COLUMN_SYNC_OBJECT_ID,
                                 COLUMN_SYNC_ACTION,
                                 COLUMN_SYNC_CREATED];
            
            const char *sql_create_sync_table =  [CREATE_SYNC_TABLE UTF8String];
            
            
            NSString *CREATE_CLASSES_TABLE = @"create table if not exists %@ ( %@ integer primary key , %@ string)";
//            String CREATE_CLASSES_TABLE = "create table "
//            + TABLE_CLASSES + "(" + COLUMN_ID + " integer primary key , "
//            + COLUMN_CLASS_NAME + " string)";
            CREATE_CLASSES_TABLE = [NSString stringWithFormat:CREATE_CLASSES_TABLE,
                                    TABLE_CLASSES,
                                    COLUMN_ID,
                                    COLUMN_CLASS_NAME];
            
            const char *sql_create_classes_table =  [CREATE_CLASSES_TABLE UTF8String];
            
            NSString *CREATE_STUDENT_TABLE = @"create table if not exists %@ ( %@ integer primary key , %@ integer, %@ integer, %@ string, %@ string)";
//            String CREATE_STUDENT_TABLE = "create table "
//            + TABLE_STUDENTS + "(" + COLUMN_ID + " integer primary key , "
//            + COLUMN_STUDENTS_CODE + " integer, "
//            + COLUMN_STUDENTS_CLASS_ID + " integer, "
//            + COLUMN_STUDENTS_LAST_NAME + " string, "
//            + COLUMN_STUDENTS_FIRST_NAME + " string)";
            CREATE_STUDENT_TABLE = [NSString stringWithFormat:CREATE_STUDENT_TABLE,
                                    TABLE_STUDENTS,
                                    COLUMN_ID,
                                    COLUMN_STUDENTS_CODE,
                                    COLUMN_STUDENTS_CLASS_ID,
                                    COLUMN_STUDENTS_LAST_NAME,
                                    COLUMN_STUDENTS_FIRST_NAME];
            
            const char *sql_create_student_table =  [CREATE_STUDENT_TABLE UTF8String];
            
             NSString *CREATE_CLASS_HAS_COURSE_TABLE = @"create table if not exists %@ ( %@ integer primary key , %@ integer, %@ integer, %@ integer)";
//            String CREATE_CLASS_HAS_COURSE_TABLE = "create table "
//            + TABLE_CLASS_HAS_COURSE + "(" + COLUMN_ID + " integer primary key, "
//            + COLUMN_CLASS_HAS_COURSE_CLASS_ID + " integer, "
//            + COLUMN_CLASS_HAS_COURSE_COURSE_ID + " integer, "
//            + COLUMN_CLASS_HAS_COURSE_TOTAL_STUD + "integer)";
            CREATE_CLASS_HAS_COURSE_TABLE = [NSString stringWithFormat:CREATE_CLASS_HAS_COURSE_TABLE,
                                             TABLE_CLASS_HAS_COURSE,
                                             COLUMN_ID,
                                             COLUMN_CLASS_HAS_COURSE_CLASS_ID,
                                             COLUMN_CLASS_HAS_COURSE_COURSE_ID,
                                             COLUMN_CLASS_HAS_COURSE_TOTAL_STUD];
            const char *sql_create_class_has_course_table =  [CREATE_CLASS_HAS_COURSE_TABLE UTF8String];
            
            if (sqlite3_exec(database, sql_create_user_table, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create %@ table",TABLE_USER);
            }
            
            if (sqlite3_exec(database, sql_create_course_table, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create %@ table",TABLE_COURSES);
            }
            
            if (sqlite3_exec(database, sql_create_attendance_table, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create %@ table",TABLE_ATTENDANCE_DETAIL);
            }
            
            if (sqlite3_exec(database, sql_create_sync_table, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create %@ table",TABLE_SYNC);
            }
            
            if (sqlite3_exec(database, sql_create_classes_table, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create %@ table",TABLE_CLASSES);
            }
            
            if (sqlite3_exec(database, sql_create_student_table, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create %@ table",TABLE_STUDENTS);
            }
            
            if (sqlite3_exec(database, sql_create_class_has_course_table, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create %@ table",TABLE_CLASS_HAS_COURSE);
            }
            
            sqlite3_close(database);
            return  isSuccess;
        } else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Create a sqlite object.
    sqlite3 *sqlite3Database;
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;
        
        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable){
                // In this case data must be loaded from the database.
                
                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow;
                
                // Loop through the results and add them to the results array row by row.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Go through all columns and fetch each column data.
                    for (int i=0; i<totalColumns; i++){
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).
                
                // Execute the query.
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}

-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)self.arrResults;
}

-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

-(void)insertNewCourse:(CourseModel *)course {
    NSString *query = [NSString stringWithFormat:@"insert into %@ values( '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@' , '%@', '%@' , '%@' , '%@')", TABLE_COURSES,
                       course.courseId,
                       course.code,
                       course.name,
                       course.classId,
                       course.class_name,
                       course.chcid,
                       course.total_stud,
                       @"0",
                       @"0",
                       course.schedules,
                       course.office_hour,
                       course.note];
    
    // Execute the query.
    [self executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.affectedRows);
        
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}

- (NSArray*)getAllCourse {
    NSString *query = [NSString stringWithFormat:@"select * from %@",TABLE_COURSES];
    NSArray* courseList = [self loadDataFromDB:query];
    return courseList;
}

@end
