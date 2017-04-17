//
//  AddExpensesTableViewCell.h
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/23/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExpensesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *explanationLabel;
@property (strong, nonatomic) IBOutlet UILabel *paidByLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;

@end
