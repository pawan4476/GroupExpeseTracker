//
//  ViewController.m
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/23/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import "ViewController.h"
#import "GroupsTableViewCell.h"
#import "AppDelegate.h"
#import "AddExpensesViewController.h"

@interface ViewController (){
    
    NSMutableArray *namesAray;
    NSIndexPath *path;
    AppDelegate *appDelegateString;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchData];
    [self.myTableView reloadData];
    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self backGround];
    appDelegateString = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
//    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self fetchData];
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    
//    [self backGround];
//    
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return namesAray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupsTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"cell"];
    Groups *object = [namesAray objectAtIndex:indexPath.row];
    cell.textLabel.text = object.groupName;
    return cell;
    
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSManagedObject *object = [namesAray objectAtIndex: indexPath.row];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Change the Group Name" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.text = [object valueForKey:@"groupName"];
            [textField addTarget:self action:@selector(alertTextDidChange:) forControlEvents:UIControlEventEditingChanged];
            
        }];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            NSManagedObjectContext *context = [self getContext];
            UITextField *groupName = [controller.textFields objectAtIndex:0];
            [object setValue:groupName.text forKey:@"groupName"];
            if (![context save:nil]) {
                
                NSLog(@"Data not saved");
                
            }
            else{
                
                NSLog(@"Data is saved");
                
            }
            [self fetchData];
            [self.myTableView reloadData];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        done.enabled = NO;
        [controller addAction:cancel];
        [controller addAction:done];
        [self presentViewController:controller animated:YES completion:nil];
        
    }];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSManagedObjectContext *context = [self getContext];
        [context deleteObject:[namesAray objectAtIndex:indexPath.row]];
        [namesAray removeObjectAtIndex:indexPath.row];
        [context save:nil];
        [self.myTableView reloadData];
        [self backGround];
        
    }];
    return @[deleteAction, editAction];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"group" sender:self];
    appDelegateString.string = [NSString stringWithFormat:@"%@", [[namesAray valueForKey:@"groupName"] objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(NSManagedObjectContext *)getContext{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    return context;
    
}

-(void)fetchData{
    
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Groups"];
    namesAray = [[NSMutableArray alloc]initWithArray:[context executeFetchRequest:request error:nil]];
    [self.myTableView reloadData];
    
}

- (IBAction)addGroupsButton:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Group Name" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"Group name";
        [textField addTarget:self action:@selector(alertTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        UITextField *groupNme = [alert.textFields objectAtIndex:0];
        NSManagedObjectContext *context = [self getContext];
        Groups *object = [NSEntityDescription insertNewObjectForEntityForName:@"Groups" inManagedObjectContext:context];
        object.groupName = groupNme.text;
//      [object setValue:groupNme.text forKey:@"groupName"];
//        [self.participantObject addGroupsObject:object];
        if (![context save:nil]) {
            
            NSLog(@"Data not saved");
            
        }
        else{
            
            NSLog(@"Data saved");
            
        }
        [self fetchData];
        [self.myTableView reloadData];
    }];
    done.enabled = NO;
     UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         
         [self dismissViewControllerAnimated:YES completion:nil];
         
     }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    path = [self.myTableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"group"]) {
        
//        AddExpensesViewController *vc = [segue destinationViewController];
        [self.navigationController setNavigationBarHidden:YES];
//        vc.titleString = [NSString stringWithFormat:@"%@", appDelegateString.string];
        
    }
    
}

-(void)alertTextDidChange:(UITextField *)sender{
    
    UIAlertController *controller = (UIAlertController *)self.presentedViewController;
    if (controller) {
        
        UITextField *text = controller.textFields.firstObject;
        UIAlertAction *done = controller.actions.lastObject;
        done.enabled = text.text.length > 2;
        
    }
    
}

-(void)backGround{
    
    if (namesAray == nil) {
        
        self.backgroundLabel.hidden = NO;
        self.myTableView.hidden = YES;
        
    }
    else{
        
        self.backgroundLabel.hidden = YES;
        self.myTableView.hidden = NO;
        
    }

}

@end
