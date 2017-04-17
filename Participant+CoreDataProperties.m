//
//  Participant+CoreDataProperties.m
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 4/6/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Participant+CoreDataProperties.h"

@implementation Participant (CoreDataProperties)

+ (NSFetchRequest<Participant *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Participant"];
}

@dynamic amount;
@dynamic date;
@dynamic explanation;
@dynamic group;
@dynamic names;
@dynamic payerName;
@dynamic totalamount;

@end
