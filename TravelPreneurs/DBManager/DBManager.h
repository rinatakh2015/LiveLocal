//
//  DBManager.h
//  GPA
//
//  Created by cgh on 9/4/14.
//  Copyright (c) 2014 krish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
    NSString *databaseFileName;
}

+ (DBManager*)getSharedInstance;
- (BOOL)createDB;
- (BOOL)createTables;
/*- (BOOL) saveAssignment:(Assignment*) assignment UserId:(long)userId;
- (NSMutableArray*) readAssignmentsListWithSearchPhrase:(NSString*)searchPhrase Count:(int)count Page:(long)page UserId:(long)userId;
- (BOOL) saveAssignmentDetailWithAssignment:(Assignment*)assignment Map: (NSMutableDictionary*) map;
- (NSDictionary*) readAssignmentDetailWithAssignmentId:(NSString*)assignment_id;
- (BOOL) saveTakenJsonQuizResultWithUserId:(long)userid AssignmentId:(NSString*)assignment_id Quiz:(NSString*)quiz Score:(float)score;
- (NSMutableArray*) readTakenJsonQuizResultWithUserId:(long)userid;
- (BOOL) saveOfflineUserEvent:(long)userid EventType:(NSString*)event_type EventContent:(NSString*)event_content;
- (NSMutableArray*) readOfflineUserEventsWithUserId:(long)userid;
-(BOOL) removeOfflineUserEventsWithId:(long)identifier;
- (BOOL) saveDownloadedFileWithId:(NSString*)file_id Path:(NSString*)path Type:(int)type;
- (NSString*) readFilePathWithId:(NSString*)file_id;
- (void) removeFilePathWithId:(NSString*)file_id;
- (BOOL)clearDatabase;
-(BOOL) removeTakenQuizWithId:(long)identifier;
*/
@end
