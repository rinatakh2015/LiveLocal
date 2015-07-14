//
//  NSArray+Dubb.m
//  Dubb
//
//  Created by Stanislas Chevallier on 09/06/14.
//  Copyright (c) 2014 Dubb. All rights reserved.
//

#import "NSArray+Custom.h"

@implementation NSArray (Custom)

+ (BOOL)array:(NSArray*)array1 isEqualToArray:(NSArray*)array2 sortBlock:(NSComparisonResult (^)(id, id))sortBlock {
    if(array1 == nil && array2 == nil)
        return YES;
    if(array1 == nil || array2 == nil)
        return NO;
    
    if(sortBlock)
    {
        NSArray *sorted1 = [array1 sortedArrayUsingComparator:sortBlock];
        NSArray *sorted2 = [array2 sortedArrayUsingComparator:sortBlock];
        return [sorted1 isEqualToArray:sorted2];
    }
    
    return [array1 isEqualToArray:array2];
}

- (NSArray *)arrayWithNthFirstElements:(NSUInteger)limit {
    if(limit > 0 && [self count] > limit)
        return [self subarrayWithRange:NSMakeRange(0, limit)];
    return self;
}

- (NSArray *)arrayByRemovingObject:(id)object {
    NSMutableArray *mut = [self mutableCopy];
    [mut removeObject:object];
    return [mut copy];
}

@end

@implementation NSMutableArray (AddNil)

- (BOOL)addObjectEvenIfNil:(id)anObject {
    if(!anObject) return NO;
    [self addObject:anObject];
    return YES;
}

- (NSUInteger)addObjectsFromArrayEvenIfNil:(NSArray*)anArray {
    if(!anArray) return 0;
    
    for(id item in anArray)
        [self addObjectEvenIfNil:item];
    
    return [anArray count];
}

@end


