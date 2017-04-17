//
//  DetailsBalanceViewController.h
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 4/3/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsBalanceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;


@end
