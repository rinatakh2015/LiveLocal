//
//  DBManager.m
//  GPA
//
//  Created by jianming gang on 9/4/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import "DBManager.h"
#import "NSDateFormatter+Custom.h"
#import "NSDate+Custom.h"
#import "NSObject+Parsing.h"
#import "NSObject+SBJson.h"
#import "NSDataAdditions.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;

static NSString* YFDatabaseTableAssignments = @"assignments";
static NSString* YFDatabaseTableTopics = @"topics";
static NSString* YFDatabaseTableTakenQuizes = @"takenquizes";
static NSString* YFDatabaseTableUserEvents = @"userevents";
static NSString* YFDatabaseTableDownloadedFiles = @"downloadedfiles";

@implementation DBManager
+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    databaseFileName = @"sxtl.db";
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: databaseFileName]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        if (![self copyDatabaseIntoDocumentsDirectory]) {
            isSuccess = NO;
        }
    }
    return isSuccess;
}

-(BOOL)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = databasePath;
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseFileName];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            return NO;
        }
        
        [self createTables];
    }
    return YES;
}

-(BOOL)createTables
{
    NSString* createAssignmentsSQL = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@ (userid INTEGER, identifier VARCHAR, title TEXT, description TEXT, featured_image TEXT, thumbnail TEXT, assigned_date TEXT, completion_date TEXT, order_by INTEGER)", YFDatabaseTableAssignments];
    NSString* createTopicsSQL = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@ (assignment_id VARCHAR, data TEXT)", YFDatabaseTableTopics];
    NSString* createTakenQuizesSQL = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY ASC, userid INTEGER, assignment_id VARCHAR, quiz TEXT, score REAL, taken_date VARCHAR)", YFDatabaseTableTakenQuizes];
    NSString* createUserEventsSQL = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY ASC, userid INTEGER, event_type VARCHAR, event_content TEXT)", YFDatabaseTableUserEvents];
    
    //Download video and image
    NSString* createDownloadedVideos = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(file_id TEXT, path TEXT, downloaded_date VARCHAR, category VARCHAR)", YFDatabaseTableDownloadedFiles];
    
    NSArray* createSQls = @[createAssignmentsSQL, createTopicsSQL, createTakenQuizesSQL, createUserEventsSQL, createDownloadedVideos];

    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement = nil;
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {

        
        for (NSString* sql in createSQls) {
            const char *create_stmt = [sql UTF8String];
            sqlite3_prepare_v2(database, create_stmt,-1, &statement, NULL);
            const char* error_msg = sqlite3_errmsg(database);
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_close(database);
                const char* error_msg = sqlite3_errmsg(database);
                return NO;
            }
            
            sqlite3_reset(statement);

        }
        
        sqlite3_finalize(statement);
        sqlite3_close(database);
        return YES;
    }
    
    return NO;
}
///***************** Save Assignment **********/
//- (BOOL) saveAssignment:(Assignment*) assignment UserId:(long)userId
//{
//    const char *dbpath = [databasePath UTF8String];
//    
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString* deleteSQL = [NSString stringWithFormat:@"delete from %@ where identifier='%@' AND userid=%ld", YFDatabaseTableAssignments, assignment.identifier, userId];
//        const char *delete_stmt = [deleteSQL UTF8String];
//        
//        sqlite3_stmt *statement = nil;
//        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(statement);
//            sqlite3_close(database);
//            return NO;
//        }
//        sqlite3_reset(statement);
//        sqlite3_finalize(statement);
//        
//        NSDate* date = [[NSDateFormatter commonDateFormatter] dateFromString:assignment.assigned_date];
//        long order_by = [date timeIntervalSinceNow];
//        NSString* insertSQL = [NSString stringWithFormat:@"insert into %@(userid, identifier, title, description, featured_image, thumbnail, assigned_date, completion_date, order_by) values(%ld, '%@', '%@', '%@', '%@', '%@', '%@', '%@',%ld)", YFDatabaseTableAssignments , userId, assignment.identifier, assignment.title ? assignment.title : @"", assignment.description ? assignment.description : @"", assignment.featured_image ? assignment.featured_image : @"", assignment.thumbnail ? assignment.thumbnail : @"", assignment.assigned_date ? assignment.assigned_date : @"", assignment.completion_date ? assignment.completion_date : @"", order_by];
//        
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_stmt *insert_statement = nil;
//        sqlite3_prepare_v2(database, insert_stmt,-1, &insert_statement, NULL);
//        if (sqlite3_step(insert_statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(insert_statement);
//            sqlite3_close(database);
//            return NO;
//        }
//        sqlite3_reset(insert_statement);
//        sqlite3_finalize(insert_statement);
//        sqlite3_close(database);
//        
//        return YES;
//    }
//    return NO;
//}
//
///********************* Read Assignments List ****************************/
//- (NSMutableArray*) readAssignmentsListWithSearchPhrase:(NSString*)searchPhrase Count:(int)count Page:(long)page UserId:(long)userId;
//{
//    if (!searchPhrase) {
//        searchPhrase = @"";
//    }
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        long start = page * count;
//
//        NSString *querySQL = [NSString stringWithFormat: @"select identifier, title, description, featured_image, thumbnail, assigned_date, completion_date from %@ where userid=%ld AND title like '%%%@%%' AND description like '%%%@%%' order by order_by DESC limit %ld, %d", YFDatabaseTableAssignments, userId, searchPhrase, searchPhrase, start, count];
//        const char *query_stmt = [querySQL UTF8String];
//        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//        
//        sqlite3_stmt *statement = nil;
//        if (sqlite3_prepare_v2(database,
//                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
//        {
//            
//            while (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                NSString* identifier = [[NSString alloc] initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 0)];
//
//                NSString* title = [[NSString alloc] initWithUTF8String:
//                                        (const char *) sqlite3_column_text(statement, 1)];
//                
//                NSString* description = [[NSString alloc] initWithUTF8String:
//                                        (const char *) sqlite3_column_text(statement, 2)];
//                
//                NSString* featured_image = [[NSString alloc] initWithUTF8String:
//                                        (const char *) sqlite3_column_text(statement, 3)];
//                
//                NSString* thumbnail = [[NSString alloc] initWithUTF8String:
//                                        (const char *) sqlite3_column_text(statement, 4)];
//                
//                NSString* assigned_date = [[NSString alloc] initWithUTF8String:
//                                        (const char *) sqlite3_column_text(statement, 5)];
//                
//                NSString* completion_date = [[NSString alloc] initWithUTF8String:
//                                        (const char *) sqlite3_column_text(statement, 6)];
//                
//                Assignment* assignment = [[Assignment alloc] initWithIdentifier:identifier Title:title Description:description FeaturedImage:featured_image Thumbnail:thumbnail AssignedDate:assigned_date CompletionDate:completion_date];
//                
//                [resultArray addObject:assignment];
//
//            }
//
//            sqlite3_finalize(statement);
//            sqlite3_close(database);
//            
//            return resultArray;
//        }
//        else{
//            sqlite3_close(database);
//        }
//    }
//    return nil;
//}
//
///***************** Save Topic **********/
//- (BOOL) saveAssignmentDetailWithAssignment:(Assignment*)assignment Map: (NSMutableDictionary*) map
//{
//    NSMutableDictionary* newMap = [[NSMutableDictionary alloc] init];
//    NSMutableArray* newTopicArray = [[NSMutableArray alloc] init ];
//    NSMutableArray* newQuizArray = [ [NSMutableArray alloc] init ];
//
//    for (Topic* topic in [map objectForKey:@"topic"]) {
//        [newTopicArray addObject:[topic convertToDictionary]];
//    }
//    
//    for(Quiz* quiz in [map objectForKey:@"quiz"])
//    {
//        [newQuizArray addObject:[quiz convertToDictionary]];
//    }
//    
//    [newMap setObject:newTopicArray forKey:@"topic"];
//    [newMap setObject:newQuizArray forKey:@"quiz"];
//    
//    NSError* error;
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newMap options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *json = [jsonData base64Encoding];
//    
//    if (!json) {
//        return NO;
//    }
//    
//    const char *dbpath = [databasePath UTF8String];
//    
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString* deleteSQL = [NSString stringWithFormat:@"delete from %@ where assignment_id='%@'", YFDatabaseTableTopics, assignment.identifier];
//        
//        const char *delete_stmt = [deleteSQL UTF8String];
//        
//        sqlite3_stmt *statement = nil;
//        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
//         const char* error_msg = sqlite3_errmsg(database);
//        
//        if (sqlite3_step(statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(statement);
//            sqlite3_close(database);
//            const char* error_msg = sqlite3_errmsg(database);
//            return NO;
//        }
//        sqlite3_reset(statement);
//        sqlite3_finalize(statement);
//        
//        NSString* insertSQL = [NSString stringWithFormat:@"insert into %@(assignment_id, data) values('%@','%@')",  YFDatabaseTableTopics, assignment.identifier, json];
//        
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_stmt *insert_statement = nil;
//        sqlite3_prepare_v2(database, insert_stmt,-1, &insert_statement, NULL);
//         error_msg = sqlite3_errmsg(database);
//        if (sqlite3_step(insert_statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(insert_statement);
//            sqlite3_close(database);
//            return NO;
//        }
//        sqlite3_reset(insert_statement);
//        sqlite3_finalize(insert_statement);
//        sqlite3_close(database);
//        
//        return YES;
//    }
//    return NO;
//}
//
///********************* Read Topic List ****************************/
//- (NSDictionary*) readAssignmentDetailWithAssignmentId:(NSString*)assignment_id
//{
//    if (!assignment_id) {
//        return nil;
//    }
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *querySQL = [NSString stringWithFormat: @"select data from %@ where assignment_id='%@'", YFDatabaseTableTopics, assignment_id];
//        const char *query_stmt = [querySQL UTF8String];
//        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//        sqlite3_stmt *statement = nil;
//        if (sqlite3_prepare_v2(database,
//                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
//        {
//
//            if (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                NSString* jsonData = [[NSString alloc] initWithUTF8String:
//                                        (const char *) sqlite3_column_text(statement, 0)];
//                
//                NSData* data = [[NSData alloc] initWithBase64EncodedString:jsonData];
//                
//                jsonData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                
//                
//                NSDictionary* assignmentDetailDic = [jsonData JSONValue];
//                NSArray* topicArray = [assignmentDetailDic objectForKey:@"topic"];
//                NSArray* quizArray = [assignmentDetailDic objectForKey:@"quiz"];
//                
//                NSMutableArray* topicObjectArray = [[NSMutableArray alloc] init];
//                NSMutableArray* quizObjectArray = [[NSMutableArray alloc] init];
//                
//                for (NSDictionary* topicDic in topicArray) {
//                    Topic* topic = [[Topic alloc] initWithDic: topicDic];
//                    [topicObjectArray addObject:topic];
//                }
//                
//                for (NSDictionary* quizDic in quizArray) {
//                    Quiz* quiz = [[Quiz alloc] initWithDic: quizDic];
//                    [quizObjectArray addObject:quiz];
//                }
//                
//                NSComparisonResult (^sortTopics)(NSDictionary*,NSDictionary* ) = ^(NSDictionary* obj1, NSDictionary* obj2) {
//                    
//                    int sequence1 = [[obj1 valueForKey:@"sequence"] intValue];
//                    int sequence2 = [[obj2 valueForKey:@"sequence"] intValue];
//                    
//                    if (sequence1 > sequence2) {
//                        return (NSComparisonResult)NSOrderedDescending;
//                    }
//                    if (sequence1 < sequence2) {
//                        return (NSComparisonResult)NSOrderedAscending;
//                    }
//                    return (NSComparisonResult)NSOrderedSame;
//                };
//                
//                topicObjectArray = [topicObjectArray sortedArrayUsingComparator:sortTopics];
//                
//                NSMutableDictionary* resultMap = [[NSMutableDictionary alloc] init];
//                [resultMap setObject:topicObjectArray forKey:@"topic"];
//                [resultMap setObject:quizObjectArray forKey:@"quiz"];
//
//                sqlite3_finalize(statement);
//                sqlite3_close(database);
//                
//                return resultMap;
//  
//                
//            }
//            
//            sqlite3_finalize(statement);
//            sqlite3_close(database);
//            
//            return nil;
//        }
//        else{
//         const char* error_msg = sqlite3_errmsg(database);                    
//            sqlite3_close(database);
//        }
//    }
//    return nil;
//}
//
//
///***************** Save Taken Json Quiz Result**********/
//- (BOOL) saveTakenJsonQuizResultWithUserId:(long)userid AssignmentId:(NSString*)assignment_id Quiz:(NSString*)quiz Score:(float)score
//{
//    const char *dbpath = [databasePath UTF8String];
//    
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString* deleteSQL = [NSString stringWithFormat:@"delete from %@ where userid=%ld AND assignment_id='%@'", YFDatabaseTableTakenQuizes, userid, assignment_id];
//        const char *delete_stmt = [deleteSQL UTF8String];
//        sqlite3_stmt *statement = nil;
//        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(statement);
//            sqlite3_close(database);
//            return NO;
//        }
//        sqlite3_reset(statement);
//        sqlite3_finalize(statement);
//        
//        NSDate* date = [[NSDate alloc] init];
//        NSString* dateString = [[NSDateFormatter commonDateFormatter] stringFromDate:date];
//        
//        
//        NSData* quizData = [quiz dataUsingEncoding:NSUTF8StringEncoding];
//        NSString *quizEncrypted = [quizData base64Encoding];
//        
//        NSString* insertSQL = [NSString stringWithFormat:@"insert into %@(userid, assignment_id, quiz, score, taken_date) values(%ld,'%@','%@',%f, '%@')",YFDatabaseTableTakenQuizes, userid, assignment_id, quizEncrypted, score, dateString];
//        
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        const char* error_msg = sqlite3_errmsg(database);
//        if (sqlite3_step(statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(statement);
//            sqlite3_close(database);
//            return NO;
//        }
//        sqlite3_reset(statement);
//        sqlite3_finalize(statement);
//        
//        sqlite3_close(database);
//        
//        return YES;
//    }
//    return NO;
//}
//
///********************* Read Quiz List ****************************/
//- (NSMutableArray*) readTakenJsonQuizResultWithUserId:(long)userid
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *querySQL = [NSString stringWithFormat: @"select id, assignment_id, quiz, score, taken_date from %@ where userid=%ld", YFDatabaseTableTakenQuizes, userid];
//        const char *query_stmt = [querySQL UTF8String];
//        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//        sqlite3_stmt *statement = nil;
//        if (sqlite3_prepare_v2(database,
//                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
//        {
//            
//            while (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                long identifier = sqlite3_column_int(statement, 0);
//                NSString* assignment_id = [[NSString alloc] initWithUTF8String:
//                                        (const char *) sqlite3_column_text(statement, 1)];
//                
//                NSString* quiz = [[NSString alloc] initWithUTF8String:
//                                           (const char *) sqlite3_column_text(statement, 2)];
//                NSData* quizData = [[NSData alloc] initWithBase64EncodedString:quiz];
//                quiz = [[NSString alloc] initWithData:quizData encoding:NSUTF8StringEncoding];
//                
//                float score =  sqlite3_column_double(statement, 3);
//
//                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//                NSString* params = [NSString stringWithFormat:@"?user_id=%ld&topic_id=%@&score=%f&question_result=%@", userid, assignment_id, score, quiz];
//                
//                [dic setObject:[NSNumber numberWithLong:identifier] forKey:@"id"];
//                [dic setObject:assignment_id forKey:@"assignment_id"];
//                [dic setObject:params forKey:@"data"];
//                
//                [resultArray addObject:dic];
//                
//            }
//            
//            sqlite3_finalize(statement);
//            sqlite3_close(database);
//            
//            return resultArray;
//        }
//        else{
//            sqlite3_close(database);
//        }
//    }
//    return nil;
//}
//
///*****************Remove Quiz Taken with Id **************/
//-(BOOL) removeTakenQuizWithId:(long)identifier
//{
//    const char *dbpath = [databasePath UTF8String];
//    
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString* deleteSQL = [NSString stringWithFormat:@"delete from %@ where id=%ld", YFDatabaseTableTakenQuizes,identifier];
//        const char *delete_stmt = [deleteSQL UTF8String];
//        sqlite3_stmt *statement = nil;
//        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(statement);
//            sqlite3_close(database);
//            return NO;
//        }
//        sqlite3_reset(statement);
//        sqlite3_finalize(statement);
//        
//        sqlite3_close(database);
//        
//        return YES;
//    }
//    return NO;
//}
///***************** Save Offline User Event**********/
//- (BOOL) saveOfflineUserEvent:(long)userid EventType:(NSString*)event_type EventContent:(NSString*)event_content
//{
//    const char *dbpath = [databasePath UTF8String];
//    
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        
//        
//        NSString* insertSQL = [NSString stringWithFormat:@"insert into %@(userid, event_type, event_content) values(%ld,'%@','%@')",YFDatabaseTableUserEvents, userid, event_type, event_content];
//        
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_stmt *statement = nil;
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(statement);
//            sqlite3_close(database);
//            return NO;
//        }
//        sqlite3_reset(statement);
//        sqlite3_finalize(statement);
//        
//        sqlite3_close(database);
//        
//        return YES;
//    }
//    return NO;
//}
//
///********************* Read Offline User Event List ****************************/
//- (NSMutableArray*) readOfflineUserEventsWithUserId:(long)userid
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *querySQL = [NSString stringWithFormat: @"select event_type, event_content from %@ where userid=%ld order by id", YFDatabaseTableUserEvents, userid];
//        const char *query_stmt = [querySQL UTF8String];
//        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//        sqlite3_stmt *statement = nil;
//        if (sqlite3_prepare_v2(database,
//                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
//        {
//            
//            while (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                NSString* event_type = [[NSString alloc] initWithUTF8String:
//                                           (const char *) sqlite3_column_text(statement, 0)];
//                
//                NSString* event_content = [[NSString alloc] initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 1)];
//                
//                NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//                [dic setObject:event_type forKey:@"event_type"];
//                [dic setObject:event_content forKey:@"event_content"];
//                
//                [resultArray addObject:dic];
//                
//            }
//            
//            sqlite3_finalize(statement);
//            sqlite3_close(database);
//            
//            return resultArray;
//        }
//        else{
//            sqlite3_close(database);
//        }
//    }
//    return nil;
//}
//
//
///********************Remove Offline User Event*******************/
//-(BOOL) removeOfflineUserEventsWithId:(long)identifier
//{
//    const char *dbpath = [databasePath UTF8String];
//    
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString* deleteSQL = [NSString stringWithFormat:@"delete from %@ where userid=%ld", YFDatabaseTableUserEvents,identifier];
//        const char *delete_stmt = [deleteSQL UTF8String];
//        sqlite3_stmt *statement = nil;
//        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(statement);
//            sqlite3_close(database);
//            return NO;
//        }
//        sqlite3_reset(statement);
//        sqlite3_finalize(statement);
//        
//        sqlite3_close(database);
//        
//        return YES;
//    }
//    return NO;
//}
///***************** Save Downloaded File**********/
//- (BOOL) saveDownloadedFileWithId:(NSString*)file_id Path:(NSString*)path Type:(int)type
//{
//    const char *dbpath = [databasePath UTF8String];
//    NSString* category = nil;
//
//    if (type == 0 )
//        category = @"image";
//    else if(type == 1)
//        category = @"video";
//    else
//        return NO;
//    
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        
//        NSString* deleteSQL = [NSString stringWithFormat:@"delete from %@ where file_id='%@'", YFDatabaseTableDownloadedFiles, file_id];
//        const char *delete_stmt = [deleteSQL UTF8String];
//        sqlite3_stmt *statement = nil;
//        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(statement);
//            sqlite3_close(database);
//            return NO;
//        }
//        sqlite3_reset(statement);
//        sqlite3_finalize(statement);
//        
//        NSDate* date = [[NSDate alloc] init];
//        NSString* dateString = [[NSDateFormatter commonDateFormatter] stringFromDate:date];
//        
//        NSString* insertSQL = [NSString stringWithFormat:@"insert into %@(file_id, path, category, downloaded_date) values('%@','%@', '%@', '%@')",YFDatabaseTableDownloadedFiles, file_id, path, category,  dateString];
//        
//        
//        sqlite3_stmt *insert_statement = nil;
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &insert_statement, NULL);
//        const char*  error_msg = sqlite3_errmsg(database);
//        
//        if (sqlite3_step(insert_statement) != SQLITE_DONE)
//        {
//            
//            sqlite3_close(database);
//            return NO;
//        }
//        sqlite3_reset(insert_statement);
//        sqlite3_finalize(insert_statement);
//        
//        sqlite3_close(database);
//        
//        return YES;
//    }
//    return NO;
//}
//
///********************* Read Video Path ****************************/
//- (NSString*) readFilePathWithId:(NSString*)file_id
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *querySQL = [NSString stringWithFormat: @"select path, downloaded_date from %@ where file_id='%@'", YFDatabaseTableDownloadedFiles, file_id];
//        const char *query_stmt = [querySQL UTF8String];
//
//        sqlite3_stmt *statement = nil;
//        if (sqlite3_prepare_v2(database,
//                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
//        {
//            
//            if (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                NSString* path = [[NSString alloc] initWithUTF8String:
//                                        (const char *) sqlite3_column_text(statement, 0)];
//                
//                sqlite3_finalize(statement);
//                sqlite3_close(database);
//                
//                return path;
//                
//            }
//            
//            sqlite3_finalize(statement);
//            sqlite3_close(database);
//            
//            return nil;
//        }
//        else{
//            sqlite3_close(database);
//        }
//    }
//    return nil;
//}
//
///********************* Remove Video Path ****************************/
//- (void) removeFilePathWithId:(NSString*)file_id
//{
//    const char *dbpath = [databasePath UTF8String];
//    NSString* savedFileName = [self readFilePathWithId:file_id];
//    if (savedFileName) {
//        NSString *docsDir;
//        NSArray *dirPaths;
//        // Get the documents directory
//        dirPaths = NSSearchPathForDirectoriesInDomains
//        (NSDocumentDirectory, NSUserDomainMask, YES);
//        docsDir = dirPaths[0];
//        NSString* filePath = [docsDir stringByAppendingPathComponent:savedFileName];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//            NSError* error;
//            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//            if (error) {
//                NSLog(@"Can not delete video file from cash: %@", [error localizedDescription]);
//            }
//        }
//    }
//
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        
//        NSString* deleteSQL = [NSString stringWithFormat:@"delete from %@ where file_id='%@'", YFDatabaseTableDownloadedFiles, file_id];
//        const char *delete_stmt = [deleteSQL UTF8String];
//        sqlite3_stmt *delete_statement = nil;
//        sqlite3_prepare_v2(database, delete_stmt,-1, &delete_statement, NULL);
//        const char* error_msg = sqlite3_errmsg(database);
//        if (sqlite3_step(delete_statement) != SQLITE_DONE)
//        {
//            sqlite3_reset(delete_statement);
//            sqlite3_close(database);
//            return ;
//        }
//
//        sqlite3_finalize(delete_statement);
//        sqlite3_close(database);
//        
//        sqlite3_close(database);
//    }
//}
///********************* Clear Database ****************************/
//- (BOOL)clearDatabase
//{
//    NSString* deleteAssignmentsSQL = [NSString stringWithFormat: @"DELETE FROM %@", YFDatabaseTableAssignments];
//    NSString* deleteTopicsSQL = [NSString stringWithFormat: @"DELETE FROM %@", YFDatabaseTableTopics];
//    NSString* deleteTakenQuizesSQL = [NSString stringWithFormat: @"DELETE FROM %@", YFDatabaseTableTakenQuizes];
//    NSString* deleteUserEventsSQL = [NSString stringWithFormat: @"DELETE FROM %@", YFDatabaseTableUserEvents];
//    NSString* deleteDownloadedVideos = [NSString stringWithFormat: @"DELETE FROM %@", YFDatabaseTableDownloadedFiles];
//    
//    NSArray* createSQls = @[deleteAssignmentsSQL, deleteTopicsSQL, deleteTakenQuizesSQL, deleteUserEventsSQL, deleteDownloadedVideos];
//    const char *dbpath = [databasePath UTF8String];
//    
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        
//        for(NSString* createSQL in createSQls)
//        {
//            const char *create_stmt = [createSQL UTF8String];
//            sqlite3_stmt *statement = nil;
//            sqlite3_prepare_v2(database, create_stmt,-1, &statement, NULL);
//            if (sqlite3_step(statement) != SQLITE_DONE)
//            {
//                sqlite3_reset(statement);
//                sqlite3_close(database);
//                return NO;
//            }
//            sqlite3_reset(statement);
//        }
//        
//        sqlite3_close(database);
//        return YES;
//    }
//    
//    return NO;
//}
@end
