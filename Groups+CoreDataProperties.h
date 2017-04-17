//
//  Groups+CoreDataProperties.h
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 4/6/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Groups+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Groups (CoreDataProperties)

+ (NSFetchRequest<Groups *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *groupName;
@property (nullable, nonatomic, retain) NSOrderedSet<Participant *> *participants;

@end

@interface Groups (CoreDataGeneratedAccessors)

- (void)insertObject:(Participant *)value inParticipantsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromParticipantsAtIndex:(NSUInteger)idx;
- (void)insertParticipants:(NSArray<Participant *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeParticipantsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInParticipantsAtIndex:(NSUInteger)idx withObject:(Participant *)value;
- (void)replaceParticipantsAtIndexes:(NSIndexSet *)indexes withParticipants:(NSArray<Participant *> *)values;
- (void)addParticipantsObject:(Participant *)value;
- (void)removeParticipantsObject:(Participant *)value;
- (void)addParticipants:(NSOrderedSet<Participant *> *)values;
- (void)removeParticipants:(NSOrderedSet<Participant *> *)values;

@end

NS_ASSUME_NONNULL_END
