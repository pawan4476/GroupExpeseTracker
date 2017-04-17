//
//  WhoPaidViewController.m
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/24/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import "WhoPaidViewController.h"
#import "AppDelegate.h"
#import "WhoPaidTableViewCell.h"
#import "AddPerticipentsViewController.h"
#import "PaidByViewController.h"
@interface WhoPaidViewController ()
{
    
    NSArray *results;
    NSIndexPath *path;
    AppDelegate *appDelegateString;
    
}

@end

@implementation WhoPaidViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Who Paid?";
//    [self fetchResults];
    // Do any additional setup after loading the view.
    NSLog(@"%@", self.string);
    appDelegateString = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self fetchParticipantData];
    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self fetchParticipantData];
    
}
-(NSManagedObjectContext *)getContext{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    return context;
    
}


-(void)fetchParticipantData {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Groups"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupName == %@", appDelegateString.string];
    [request setPredicate:predicate];
    results = [[NSMutableArray alloc]initWithArray:[[self getContext] executeFetchRequest:request error:nil]];
    if (results.count > 0) {
        self.groupObject = [results objectAtIndex:0];
    }
    else{
        
        self.groupObject = [NSEntityDescription insertNewObjectForEntityForName:@"Groups" inManagedObjectContext:[self getContext]];
        self.groupObject.groupName = self.string;
        [self.groupObject addParticipantsObject:self.participentObject];
        
    }
    [self saveData];
    [self.myTableView reloadData];
    
}

-(void)saveData {
    if ([[self getContext] save:nil]) {
        
        NSLog(@"Data saved");
        
    }
    else{
        
        NSLog(@"Data not saved");
        
    }
}
    
    
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.groupObject.participants == 0) {
            
            return 1;
            
        }
        else{
            
    return self.groupObject.participants.count;
            
        }
        
    }
    else if(section == 1){
        
        return 1;
        
    }
    else{
        
        return 0;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *firstCellIdentifier = @"cell2";
    static NSString *lastCellIdentifier = @"cell3";
    
    if (indexPath.section == 0) {
        
        if (self.groupObject.participants == nil || self.groupObject.participants.count == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellIdentifier];
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCellIdentifier];
                
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%@", @"No Participents added yet"];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
            
        }
        else{
            
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellIdentifier];
    self.participentObject = [self.groupObject.participants objectAtIndex:indexPath.row];
    cell.textLabel.text = self.participentObject.names;
    return cell;
            
        }
    }
    
   else if (indexPath.section == 1) {
        
        WhoPaidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lastCellIdentifier];
       [cell.addPerticipents addTarget:self action:@selector(performSegue) forControlEvents:UIControlEventTouchUpInside];
       return cell;
       
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"paid" sender:self];
    
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            self.participentObject = [self.groupObject.participants objectAtIndex:indexPath.row];
            [[self getContext] deleteObject:self.participentObject];
            [self saveData];
            [self.groupObject removeParticipantsObject:self.participentObject];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        delete.backgroundColor = [UIColor redColor];
        return @[delete];
        
    }
    return nil;
    
}

-(void)performSegue{
    
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

//    [self performSegueWithIdentifier:@"add" sender:self];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"add"]) {
        
        AddPerticipentsViewController *vc = [segue destinationViewController];
        vc.string = self.string;
        
    }
    else if ([segue.identifier isEqualToString:@"paid"]){
        path = [self.myTableView indexPathForSelectedRow];
        PaidByViewController *vc = [segue destinationViewController];
        self.participentObject = [self.groupObject.participants objectAtIndex:path.row];
//        vc.string = [NSString stringWithFormat:@"%@", self.participentObject.names];
        vc.groupString = self.string;
//        vc.decideFunctionality = 1;
        [vc receivePayerInfo:[NSString stringWithFormat:@"%@", self.participentObject.names] :1];
        
    }
}

@end
