//
//  ViewController.h
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/23/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participant+CoreDataProperties.h"
#import "Groups+CoreDataProperties.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

- (IBAction)addGroupsButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *backgroundLabel;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) Participant *participantObject;

@end

