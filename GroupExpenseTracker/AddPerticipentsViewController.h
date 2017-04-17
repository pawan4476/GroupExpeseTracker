//
//  AddPerticipentsViewController.h
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/23/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participant+CoreDataProperties.h"
#import "Groups+CoreDataProperties.h"

@interface AddPerticipentsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *addPerticipentsTextField;
@property (strong, nonatomic) Participant *participantObject;
@property (strong, nonatomic) Groups *groupObject;
@property (strong, nonatomic) NSString *string;

@end
