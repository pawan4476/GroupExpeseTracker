//
//  WhoPaidViewController.h
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/24/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import "Participant+CoreDataProperties.h"
#import "Groups+CoreDataProperties.h"
@interface WhoPaidViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, CNContactPickerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) Participant *participentObject;
@property (strong, nonatomic) Groups *groupObject;
@property (strong, nonatomic) NSString *string;
@end
