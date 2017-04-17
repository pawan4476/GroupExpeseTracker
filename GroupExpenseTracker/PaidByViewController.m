//
//  PaidByViewController.m
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/27/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import "PaidByViewController.h"
#import "AppDelegate.h"
#import "PaidByTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "AddExpensesViewController.h"
@interface PaidByViewController ()

@end

@implementation PaidByViewController{
    
   
    NSMutableDictionary *dic;
    NSMutableArray *spendingMoneyFor, *resultsArray1 ,*participents;
    NSMutableString *tempExplanationString, *tempAmountString;
    int checkMark;
    NSNumberFormatter *numberFormatter;
    NSMutableArray *participentsNames;
    NSArray *expensesList, *resultsArray;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.decideFunctionality == 1) {
        
        spendingMoneyFor = [[NSMutableArray alloc]init];
        tempExplanationString = [[NSMutableString alloc]init];
        tempAmountString = [[NSMutableString alloc]init];
        participentsNames = [[NSMutableArray alloc]init];
        self.navigationItem.title = [NSString stringWithFormat:@"Paid By %@", self.string];
        
    }
    else if (self.decideFunctionality == 0){
        
        self.navigationItem.title = [NSString stringWithFormat:@"Paid By %@", self.string];
        
        [self.myTableView reloadData];
        
    }
    [self.saveButtonOutlet setEnabled:NO];
    
    numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundUp];
    
    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
  
//    [self fetchParticipantData];
//    [self fetchParticipent];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.decideFunctionality == 0) {
        
        
//        tempExplanationString = self.participentObject.explanation.mutableCopy;
//        tempAmountString = [[NSString stringWithFormat:@"%f", self.participentObject.amount] mutableCopy];
//        self.explanationString = tempExplanationString;
//        self.amount=[tempAmountString floatValue];
//        [self.saveButtonOutlet setEnabled:YES];
        NSLog(@"participents %@", participentsNames);
        [self.myTableView reloadData];
//        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"checkMark"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    else if (self.decideFunctionality == 1){
        
         [self fetchParticipantData:1];
        
    }
   
    
//    [self fetchParticipent];
    
}

-(NSManagedObjectContext *)getContext{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    return context;
    
}

-(void)fetchParticipantData:(int)status {
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Groups"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupName == %@", self.groupString];
    [request setPredicate:predicate];
    self.results = [[NSArray alloc]initWithArray:[[self getContext] executeFetchRequest:request error:nil]];
    if (self.results.count > 0) {
        self.groupObject = [self.results objectAtIndex:0];
    }
    else{
        
        self.groupObject = [NSEntityDescription insertNewObjectForEntityForName:@"Groups" inManagedObjectContext:[self getContext]];
        self.groupObject.groupName = self.groupString;
        [self.groupObject addParticipantsObject:self.participentObject];
        
    }
    for (int i = 0; i < [self.groupObject.participants count]; i++) {
        
        dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[[self.groupObject.participants objectAtIndex:i] valueForKey:@"names"] forKey:@"names"];
        [dic setObject:[NSNumber numberWithBool:status] forKey:@"checkMark"];
        [participentsNames addObject:dic];
    }
    
    [self saveData];
    [self.myTableView reloadData];
    
}

-(void)fetchParticipent{
    
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Participant"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == %@", self.groupString];
    [request setPredicate:predicate];
    NSArray *array = [[NSArray alloc]initWithArray:[context executeFetchRequest:request error:nil]];
    NSLog(@"Array is: %@", array);
    
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
    
    if (self.decideFunctionality == 0) {
        
        return 2;
        
    }
    
    else{
        
    return 3;
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
        
    }
    else if (section == 1){
        
        return participentsNames.count;
        
    }
    else{
        
        return 1;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        PaidByTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paidCell"];
        if (self.decideFunctionality == 0) {
            
            cell.explanationTextField.text = self.participentObject.explanation;
            cell.amountTextField.text = [NSString stringWithFormat:@"%f", self.participentObject.amount];
            
        }
        else{
            
        }

        return cell;
        
    }
    else if (indexPath.section == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nameCell"];
            
        }
        if ([[[participentsNames objectAtIndex:indexPath.row] objectForKey:@"checkMark"] integerValue] == 1) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [spendingMoneyFor addObject:[[participentsNames objectAtIndex:indexPath.row] valueForKey:@"names"]];
            
        }
        else if ([[[participentsNames objectAtIndex:indexPath.row] objectForKey:@"checkMark"] integerValue] == 0){
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }

//        Participant *object = [self.groupObject.participants objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[participentsNames objectAtIndex:indexPath.row] objectForKey:@"names"]];
        return cell;
        
    }
    else if (indexPath.section == 2){
        
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell"];
        [cell.deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        
    }
    else if (indexPath.section == 1){
        
        if ([[[participentsNames objectAtIndex:indexPath.row] objectForKey:@"checkMark"] integerValue] == 1) {
            
            [[participentsNames objectAtIndex:indexPath.row] setObject:@"0" forKey:@"checkMark"];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//            [spendingMoneyFor removeObject:[self.groupObject.participants objectAtIndex:indexPath.row]];
            
        }
        else{
            
            [[participentsNames objectAtIndex:indexPath.row] setObject:@"1" forKey:@"checkMark"];
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//            [spendingMoneyFor addObject:[self.groupObject.participants objectAtIndex:indexPath.row]];
            
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 139;
        
    }
   else if (indexPath.section == 1) {
        
        return 40.0;
        
    }
   else{
       
       return 45;
       
   }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return @"Paid for Whom?";
        
    }
    return nil;
    
}

-(void)delete{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

-(void)receivePayerInfo:(NSString *)paidBy :(int)i{
    
    self.string = [[NSString alloc]init];
    self.string = paidBy;
    self.decideFunctionality = i;
    
}

-(void)receiveExpenseDetailsDoneByPerson:(Participant *)personInfo :(int)i{
    
    self.string = personInfo.payerName;
    self.decideFunctionality = i;
    participentsNames = [[NSMutableArray alloc]init];
    tempExplanationString = [[NSMutableString alloc]init];
    tempAmountString = [[NSMutableString alloc]init];
    participents = [[NSMutableArray alloc]init];
    tempExplanationString = personInfo.explanation.mutableCopy;
    tempAmountString = [[NSString stringWithFormat:@"%f", personInfo.amount] mutableCopy];
    self.explanationString = tempExplanationString;
    self.amount = tempAmountString.floatValue;
    self.participentObject = personInfo;
    
    
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Participant"];
    resultsArray = [[context executeFetchRequest:request error:nil] mutableCopy];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"explanation == %@", personInfo.explanation];
    [request setPredicate:predicate];
    [self fetchParticipantData:0];
    participents = [[resultsArray filteredArrayUsingPredicate:predicate] mutableCopy];
//    NSFetchRequest *namesRequest = [[NSFetchRequest alloc]initWithEntityName:@"Groups"];
//    NSPredicate *namesPredicate = [NSPredicate predicateWithFormat:@"groupName == %@", self.groupString];
//    [namesRequest setPredicate:namesPredicate];
//    NSArray *namesArray = [context executeFetchRequest:namesRequest error:nil];
//    if (namesArray > 0) {
//        
//        self.groupObject = [namesArray objectAtIndex:0];
//        
//    }

    for (int i =0; i < participents.count; i++) {
//        for (int j = 0; j < self.groupObject.participants.count; j++) {
        
        Participant *expParticipent = [participents objectAtIndex:i];
//        Participant *nameParticipent = [self.groupObject.participants objectAtIndex:i];
        if ([personInfo.explanation isEqualToString:expParticipent.explanation]) {
            
            if ([[[participents objectAtIndex:i] valueForKey:@"payerName"] isEqualToString:expParticipent.payerName]) {
                
                int indexOfParticipent = (int)[[participentsNames valueForKey:@"names"] indexOfObject:expParticipent.payerName];
                [[participentsNames objectAtIndex:indexOfParticipent] setObject:[NSNumber numberWithBool:1] forKey:@"checkMark"];
                NSLog(@"Object at index:%@", [participentsNames objectAtIndex:indexOfParticipent]);
            }
            else{
                
                int indexOfParticipent = (int)[[participentsNames valueForKey:@"names"] indexOfObject:expParticipent.payerName];
                [[participentsNames objectAtIndex:indexOfParticipent] setObject:[NSNumber numberWithBool:0] forKey:@"checkMark"];
                
            }
        }
        else{
            
        }
//    }
    }
    NSLog(@"All participant names:%@", participentsNames);
    
}
- (IBAction)saveButton:(id)sender {
    
    if (self.decideFunctionality == 1) {
        
        [self saveDetails];
        
    }
    else if (self.decideFunctionality == 0){
        
        [self updateDetails];
        
    }
//    NSLog(@"The explanation string is:%@, amount is: %f", self.explanationString, self.amount);
//    float total;
//    total = self.amount/spendingMoneyFor.count;
//    NSLog(@"Total is:%f", total);
//    
//    if (self.i == 0) {
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"checkMark"] isEqualToString:@"1"]) {
//        
//        self.participentObject.payerName = self.string;
//        self.participentObject.payerName = self.string;
//        self.participentObject.amount = self.amount;
//        self.participentObject.explanation = self.explanationString;
//        self.participentObject.date = [NSDate date];
//        self.participentObject.group = self.groupString;
//        self.participentObject.totalamount = total;
//        [self saveData];
//            
//        }
//        else{
//            
//            self.participentObject.payerName = self.string;
//            self.participentObject.payerName = self.string;
//            self.participentObject.amount = self.amount;
//            self.participentObject.explanation = self.explanationString;
//            self.participentObject.date = [NSDate date];
//            self.participentObject.group = self.groupString;
//            self.participentObject.totalamount = 0;
//            [self saveData];
//        }
//        
//    }
//    
//    else if (self.i == 1){
//
//    NSManagedObjectContext *context = [self getContext];
//    Participant *object = [NSEntityDescription insertNewObjectForEntityForName:@"Participant" inManagedObjectContext:context];
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"checkMark"] isEqualToString:@"1"]) {
//            
//    object.payerName = self.string;
//    object.amount = self.amount;
//    object.explanation = self.explanationString;
//    object.date = [NSDate date];
//    object.group = self.groupString;
//    object.totalamount = total;
//              [self saveData];
//            
//        }
//        else{
//            
//            object.payerName = self.string;
//            object.amount = self.amount;
//            object.explanation = self.explanationString;
//            object.date = [NSDate date];
//            object.group = self.groupString;
//            object.totalamount = 0;
//              [self saveData];
//            
//        }
//    
////    self.groupObject.groupName = self.groupString;
////    [self.groupObject addParticipantsObject:self.participentObject];
//  
//        
//    }
    
    [self.navigationController popViewControllerAnimated:YES];

    
}

-(void)saveDetails{
    
    float totalAmount = 0;
    int numberOfPersons = 0;
    if (self.explanationString != nil && self.amount != 0) {
        
        for (NSManagedObject *obj in participentsNames) {
            
            if ([obj valueForKey:@"checkMark"] == [NSNumber numberWithBool:1]) {
                
                numberOfPersons += 1;
                
            }
        }
        totalAmount = self.amount/numberOfPersons;
        
    for (int i = 0; i < [participentsNames count]; i++) {
        
        if ([[[participentsNames objectAtIndex:i] valueForKey:@"names"] isEqualToString:self.string] && [[participentsNames objectAtIndex:i]valueForKey:@"checkMark"]== [NSNumber numberWithBool:1]) {
            
            NSManagedObjectContext *context = [self getContext];
            Participant *object = [NSEntityDescription insertNewObjectForEntityForName:@"Participant" inManagedObjectContext:context];
            
                object.payerName = self.string;
                object.amount = self.amount;
                object.explanation = self.explanationString;
                object.date = [NSDate date];
                object.group = self.groupString;
                object.totalamount = totalAmount;
//            object.names = [[participentsNames objectAtIndex:i] valueForKey:@"names"];
                [context save:nil];
            
            }
        
        else if ([[participentsNames objectAtIndex:i] valueForKey:@"names"] && [[participentsNames objectAtIndex:i] valueForKey:@"checkMark"] == [NSNumber numberWithBool:1]){
            
            NSManagedObjectContext *context = [self getContext];
            Participant *object = [NSEntityDescription insertNewObjectForEntityForName:@"Participant" inManagedObjectContext:context];
            
            object.payerName = [[participentsNames objectAtIndex:i] valueForKey:@"names"];
            object.explanation = self.explanationString;
            object.date = [NSDate date];
            object.group = self.groupString;
            object.totalamount = totalAmount;
//            object.names = [[participentsNames objectAtIndex:i] valueForKey:@"names"];
            [context save:nil];
            
        }
        
        else if ([[[participentsNames objectAtIndex:i] valueForKey:@"names"] isEqualToString:self.string] && [[[participentsNames objectAtIndex:i] valueForKey:@"checkMark"] boolValue] == NO){
            
            NSManagedObjectContext *context = [self getContext];
            Participant *object = [NSEntityDescription insertNewObjectForEntityForName:@"Participant" inManagedObjectContext:context];
            
            object.payerName = self.string;
            object.amount = self.amount;
            object.explanation = self.explanationString;
            object.date = [NSDate date];
            object.group = self.groupString;
            object.totalamount = 0;
//            object.names = [[participentsNames objectAtIndex:i] valueForKey:@"names"];
            [context save:nil];

        }
       
        else{
            
            NSLog(@"Some action required");
            
        }
    }
        [self gotoAddExpenseViewController];
    }
    
}

-(void)updateDetails{
    
    resultsArray1 = [[NSMutableArray alloc]init];
    int numberOfPersons = 0;
    float totalAmount;
    if (self.explanationString != nil && self.amount != 0) {
        
        for (NSManagedObject *obj in participentsNames) {
            
            if ([[obj valueForKey:@"checkMark"] boolValue] == YES) {
                
                numberOfPersons += 1;
                
            }
            
        }
        totalAmount = self.amount/numberOfPersons;
        NSManagedObjectContext *context = [self getContext];
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Participant"];
        expensesList = [context executeFetchRequest:request error:nil];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"explanation == %@", self.participentObject.explanation];
        [request setPredicate:predicate];
        resultsArray1 = [[expensesList filteredArrayUsingPredicate:predicate] mutableCopy];
        for (int i = 0; i < [participentsNames count]; i++) {
            
            if ([[[participentsNames objectAtIndex:i] valueForKey:@"names"] isEqualToString:self.string] && [[participentsNames objectAtIndex:i] valueForKey:@"checkMark"] == [NSNumber numberWithBool:1]) {
                
                NSManagedObject *expObj = [resultsArray1 objectAtIndex:i];
                [expObj setValue:self.string forKey:@"payerName"];
                [expObj setValue:self.explanationString forKey:@"explanation"];
                [expObj setValue:[NSNumber numberWithFloat:self.amount] forKey:@"amount"];
                [expObj setValue:[NSDate date] forKey:@"date"];
                [expObj setValue:[NSNumber numberWithFloat:totalAmount] forKey:@"totalamount"];
                [context save:nil];
                
            }
            else if ([[participentsNames objectAtIndex:i] valueForKey:@"names"] && [[participentsNames objectAtIndex:i] valueForKey:@"checkMark"] == [NSNumber numberWithBool:1]){
                
                NSManagedObject *expObj = [resultsArray1 objectAtIndex:i];
                [expObj setValue:[[participentsNames objectAtIndex:i] valueForKey:@"names"] forKey:@"payerName"];
                [expObj setValue:self.explanationString forKey:@"explanation"];
                [expObj setValue:nil forKey:@"amount"];
                [expObj setValue:[NSDate date] forKey:@"date"];
                [expObj setValue:[NSNumber numberWithFloat:totalAmount] forKey:@"totalamount"];
                [context save:nil];
            }
            else if ([[[participentsNames objectAtIndex:i] valueForKey:@"names"] isEqualToString:self.string] && [[[participentsNames objectAtIndex:i] valueForKey:@"checkMark"] boolValue] == NO){
                
                NSManagedObject *expObj = [resultsArray1 objectAtIndex:i];
                [expObj setValue:self.string forKey:@"payerName"];
                [expObj setValue:self.explanationString forKey:@"explanation"];
                [expObj setValue:[NSNumber numberWithFloat:self.amount] forKey:@"amount"];
                [expObj setValue:[NSDate date] forKey:@"date"];
                [expObj setValue:[NSNumber numberWithFloat:0] forKey:@"totalamount"];
                [context save:nil];
            }
//            else if ([[participentsNames objectAtIndex:i] valueForKey:@"names"] && [[[participentsNames objectAtIndex:i] valueForKey:@"checkMark"] boolValue] == NO){
//                
//                NSManagedObject *expObj = [resultsArray1 objectAtIndex:i];
//                [context deleteObject:expObj];
//                [self saveData];
//                
//            }
            else if ([[participentsNames objectAtIndex:i] valueForKey:@"names"] && [[[participentsNames objectAtIndex:i] valueForKey:@"checkMark"] boolValue] == YES){
                
                NSManagedObjectContext *expContext = [self getContext];
                Participant *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Participant" inManagedObjectContext:expContext];
                obj.payerName = [[participentsNames objectAtIndex:i] valueForKey:@"names"];
                obj.explanation = self.explanationString;
                obj.date = [NSDate date];
                obj.totalamount = totalAmount;
                [expContext save:nil];
                
            }
        }
        [self gotoAddExpenseViewController];
    }
    
}

-(void)gotoAddExpenseViewController{
    
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        
        
        if ([viewController isKindOfClass:[AddExpensesViewController class]] ) {
            
            AddExpensesViewController *addExpenseViewController = (AddExpensesViewController*)viewController;
            [self.navigationController popToViewController:addExpenseViewController animated:YES];
            
        }
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:(PaidByTableViewCell *)[[textField superview] superview]];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0 && textField.tag == 100) {
            
            const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
            int isBackSpace = strcmp(_char, "\b");
            if (isBackSpace == -8) {
                
                [tempExplanationString replaceCharactersInRange:range withString:string];
                
            }
            [tempExplanationString appendString:string];
            self.explanationString = tempExplanationString;
            
        }
        else if (indexPath.row == 0 && textField.tag == 101){
            
            const char *_char = [string cStringUsingEncoding:NSUTF8StringEncoding];
            int isBackSpace = strcmp(_char, "\b");
            if (isBackSpace == -8) {
            
                [tempAmountString replaceCharactersInRange:range withString:string];
            
            }
            [tempAmountString appendString:string];
            self.amount = [tempAmountString floatValue];
            
        }
        
    }
    
    if (![self.explanationString isEqualToString:@""] && self.amount > 0) {
    
        [textField addTarget:self action:@selector(validateTextFields) forControlEvents:UIControlEventEditingChanged];
        
    }
    return YES;
}

-(void)validateTextFields{
    
    if (![self.explanationString isEqualToString:@""] && self.amount > 0) {
        
        [self.saveButtonOutlet setEnabled:YES];
        
    }
    else{
        
        [self.saveButtonOutlet setEnabled:NO];
        
    }
}
@end
