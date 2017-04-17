//
//  AddExpensesViewController.m
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/23/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import "AddExpensesViewController.h"
#import "AddExpensesTableViewCell.h"
#import "AddPerticipentsViewController.h"
#import "WhoPaidViewController.h"
#import "PaidByViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface AddExpensesViewController ()

@end

@implementation AddExpensesViewController{
    
    NSArray *expensesList, *results;
    NSMutableArray *expensesArray;
    AppDelegate *appDelegateString;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    expensesArray = [[NSMutableArray alloc]init];
    appDelegateString = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.navigation.title = [NSString stringWithFormat:@"Group is %@", appDelegateString.string];
    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    [self fetchParticipants];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    expensesArray = [[NSMutableArray alloc]init];
    [self fetchParticipants];
    [self fetchParticipantData];
    [self.myTableView reloadData];
    
}

-(NSManagedObjectContext *)getContext{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    return context;
    
}

-(void)fetchParticipants{
    
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Participant"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == %@", appDelegateString.string];
    [request setPredicate:predicate];
    expensesList = [context executeFetchRequest:request error:nil];
    for (Participant *object in expensesList) {
        if (object.amount != 0) {
            
            [expensesArray addObject:object];
            
        }
        NSLog(@"amount is %f", object.amount);
    }
    [self.myTableView reloadData];
    
}

-(void)fetchParticipantData {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Groups"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupName == %@", appDelegateString.string];
    [request setPredicate:predicate];
    results = [[NSArray alloc]initWithArray:[[self getContext] executeFetchRequest:request error:nil]];
    if (results.count > 0) {
        self.groupObject = [results objectAtIndex:0];
    }
    else{
        
        self.groupObject = [NSEntityDescription insertNewObjectForEntityForName:@"Groups" inManagedObjectContext:[self getContext]];
        self.groupObject.groupName = appDelegateString.string;
        [self.groupObject addParticipantsObject:self.participentObject];
    }
    [self saveData];
}


-(void)saveData{
    
    if ([[self getContext] save:nil]) {
        
        NSLog(@"Data is saved");
        
    }
    else{
        
        NSLog(@"Data not saved");
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return expensesArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddExpensesTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"cell1"] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd/MM/YYYY";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode:NSNumberFormatterRoundUp];
    Participant *object = [expensesArray objectAtIndex: indexPath.row];
    cell.explanationLabel.text = object.explanation;
    cell.amountLabel.text = [NSString stringWithFormat:@"%@ >", [formatter stringFromNumber:[NSNumber numberWithFloat:object.amount]]];
    cell.paidByLabel.text = [NSString stringWithFormat:@"Paid By %@", object.payerName];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:object.date]];
    return cell;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"+Expenses";
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"edit" sender:self];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = [self getContext];
        [context deleteObject:[expensesArray objectAtIndex:indexPath.row]];
        [expensesArray removeObjectAtIndex:indexPath.row];
        [context save:nil];
        [self.myTableView reloadData];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSIndexPath *path = [self.myTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"members"]) {
        AddPerticipentsViewController *vc = [segue destinationViewController];
        vc.string = appDelegateString.string;
        
      //  [self presentViewController:vc animated:YES completion:nil];
    }
    
    if ([segue.identifier isEqualToString:@"add"]) {
        WhoPaidViewController *wc = [segue destinationViewController];
        wc.string = appDelegateString.string;
        
    }
    
    if ([segue.identifier isEqualToString:@"edit"]) {
        
        PaidByViewController *vc = [segue destinationViewController];
        Participant *object = [expensesArray objectAtIndex:path.row];
        vc.participentObject = object;
        vc.groupString = appDelegateString.string;
//        vc.string = object.payerName;
//        vc.decideFunctionality = 0;
        [vc receiveExpenseDetailsDoneByPerson:object :0];
        
    }
}
- (IBAction)groupsButton:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)addParticipents:(id)sender {
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Access to Contacts" message:@"This app requires access to contacts" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    CNContactStore *store = [[CNContactStore alloc]init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            
            CNContactPickerViewController *controlPicker = [[CNContactPickerViewController alloc]init];
            controlPicker.delegate = self;
            [self presentViewController:controlPicker animated:YES completion:nil];
            
        }
    }];
}

-(void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    
    NSLog(@"Operation canceled");
    
}

-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
    NSManagedObjectContext *context = [self getContext];
    self.participentObject = [NSEntityDescription insertNewObjectForEntityForName:@"Participant" inManagedObjectContext:context];
    self.participentObject.names = [NSString stringWithFormat:@"%@%@", contact.givenName, contact.familyName];
    [self.groupObject addParticipantsObject:self.participentObject];
    [self saveData];

    NSLog(@"%@ %@ %@", contact.givenName, contact.familyName, contact.phoneNumbers);
    
}
@end
