//
//  Participant+CoreDataProperties.h
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 4/6/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Participant+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Participant (CoreDataProperties)

+ (NSFetchRequest<Participant *> *)fetchRequest;

@property (nonatomic) float amount;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *explanation;
@property (nullable, nonatomic, copy) NSString *group;
@property (nullable, nonatomic, copy) NSString *names;
@property (nullable, nonatomic, copy) NSString *payerName;
@property (nonatomic) float totalamount;

@end

NS_ASSUME_NONNULL_END
