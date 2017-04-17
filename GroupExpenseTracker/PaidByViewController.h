//
//  PaidByViewController.h
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/27/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Groups+CoreDataProperties.h"
#import "Participant+CoreDataProperties.h"

@interface PaidByViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSString *string;
@property (strong, nonatomic) NSString *groupString;
@property (strong, nonatomic) NSString *explanationString;
@property (assign, nonatomic) float amount;
@property (assign, nonatomic) int decideFunctionality;
@property (strong, nonatomic) Groups *groupObject;
@property (strong, nonatomic) Participant *participentObject;
@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButtonOutlet;
- (IBAction)saveButton:(id)sender;

-(void)receivePayerInfo:(NSString *)paidBy :(int) i;
-(void)receiveExpenseDetailsDoneByPerson:(Participant *)personInfo :(int)i;
@end
