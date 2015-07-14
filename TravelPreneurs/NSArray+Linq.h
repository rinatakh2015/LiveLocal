#import <Foundation/Foundation.h>

typedef BOOL (^Predicate)(id);


@interface NSArray (Linq)
- (id)first:(Predicate)condition;

- (id)firstOrNil;

- (id)firstOrNil:(Predicate)condition;

- (id)secondOrNil;

- (id)lastOrNil;

- (NSArray *)map:(id (^)(id))projection;

- (NSArray *)mapLossy:(id (^)(id))projection;

- (NSArray *)mapWithIndex:(id (^)(id, NSUInteger))projection;

- (NSDictionary *)groupBy:(id (^)(id))projection;

- (void)each:(void (^)(id))action;

- (NSArray *)where:(Predicate)condition;

- (NSSet *)toSet;

- (BOOL)any:(Predicate)condition;

- (BOOL)isEmpty;

- (NSArray *)reverse;

- (NSArray *)distinct;

- (NSArray *)skip:(NSUInteger)count;

- (NSArray *)concatObject:(id)item;

- (NSArray *)exceptObject:(id)item;

- (NSArray *)except:(NSArray *)itemsToRemove;

@end