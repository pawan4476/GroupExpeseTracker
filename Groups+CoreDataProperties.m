//
//  Groups+CoreDataProperties.m
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 4/6/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Groups+CoreDataProperties.h"

@implementation Groups (CoreDataProperties)

+ (NSFetchRequest<Groups *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Groups"];
}

@dynamic groupName;
@dynamic participants;

@end
