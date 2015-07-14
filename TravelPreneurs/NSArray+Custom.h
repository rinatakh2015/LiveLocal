//
//  NSArray+Dubb.h
//  Dubb
//
//  Created by Stanislas Chevallier on 09/06/14.
//  Copyright (c) 2014 Dubb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Custom)

+ (BOOL)array:(NSArray*)array1 isEqualToArray:(NSArray*)array2 sortBlock:(NSComparisonResult(^)(id obj1, id obj2))sortBlock;
- (NSArray *)arrayWithNthFirstElements:(NSUInteger)limit;
- (NSArray *)arrayByRemovingObject:(id)object;

@end

@interface NSMutableArray (AddNil)

- (BOOL)addObjectEvenIfNil:(id)anObject;
- (NSUInteger)addObjectsFromArrayEvenIfNil:(NSArray*)anArray;

@end

