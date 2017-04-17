//
//  PaidByTableViewCell.h
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/27/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaidByTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *explanationTextField;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;

@end
