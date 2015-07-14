#import "NSArray+Linq.h"


typedef BOOL (^Predicate)(id);

@implementation NSArray (Linq)

- (id)first:(Predicate)condition {
    id result = nil;
    for (id item in self) {
        if (condition(item)) {
            result = item;
            break;
        }
    }
    return result;
}

-(id)firstOrNil {
    if ([self count] > 0){
        return [self objectAtIndex:0];
    }
    return nil;
}

-(id)firstOrNil:(Predicate)condition {
    for(id item in self){
        if(condition(item)){
            return item;
        }
    }
    return nil;
}

-(id)secondOrNil {
    if ([self count] > 1){
        return [self objectAtIndex:1];
    }
    return nil;
}

-(id)lastOrNil {
    if ([self count] > 0){
        return [self lastObject];
    }
    return nil;
}

- (NSArray *)map:(id (^)(id))projection {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id item in self) {
        [result addObject:projection(item)];
    }
    return result;
}

- (NSArray *)mapLossy:(id (^)(id))projection {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id item in self) {
        id newItem = projection(item);
        if(newItem)
            [result addObject:newItem];
    }
    return result;
}

- (NSArray *)mapWithIndex:(id (^)(id,NSUInteger))projection {
    __block NSUInteger index = 0;
    return [self map:^(id item){
        return projection(item, index++);
    }];
}

- (NSDictionary *)groupBy:(id (^)(id))keySelector {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for(id item in self){
        id key = keySelector(item);
        NSMutableArray *group = [dict objectForKey:key] ;
        if (group == nil){
            group = [NSMutableArray new];
            [dict setObject:group forKey:key];
        }
        [group addObject:item];
    }
    return dict;
}

- (void)each:(void (^)(id))action {
    for (id item in self) {
        action(item);
    }
}

- (NSArray *)where:(Predicate)condition {
    NSMutableArray * result = [NSMutableArray new];
    [self each:^(id item){
        if (condition(item)){
            [result addObject:item];
        }
    }];
    return result;
}

-(NSSet*)toSet {
    return [NSSet setWithArray:self];
}


- (BOOL)any:(Predicate)condition {
    for(id item in self){
        if (condition(item)){
            return YES;
        }
    }
    return NO;
}

- (BOOL)isEmpty {
    return [self count] <= 0;
}

- (NSArray *)reverse {
    NSMutableArray *result = [NSMutableArray new];
    for(id item in [self reverseObjectEnumerator]){
        [result addObject: item];
    }
    return result;
}

- (NSArray *)distinct {
    NSMutableDictionary *hashSet = [NSMutableDictionary new];
    for(id item in self){
        [hashSet setObject:item forKey:item];
    }
    return [hashSet allKeys];
}

-(NSArray *)skip:(NSUInteger)count {
    NSRange range;
    range.location = count;
    range.length = [self count] - count;
    return [self objectsAtIndexes: [NSIndexSet indexSetWithIndexesInRange:range]];
}

-(NSArray *)concatObject:(id)item {
    if([self indexOfObject:item] == NSNotFound){
        NSMutableArray *copy = [self mutableCopy];
        [copy addObject:item];
        return copy;
    }
    return self;
}

-(NSArray *)exceptObject:(id)item {
    if([self indexOfObject:item] != NSNotFound){
        NSMutableArray *copy = [self mutableCopy];
        [copy removeObject:item];
        return copy;
    }
    return self;
}

-(NSArray *)except:(NSArray *)itemsToRemove {
    return [self where:^(id item){
        return (BOOL)([itemsToRemove indexOfObject:item] == NSNotFound);
    }];
}


@end