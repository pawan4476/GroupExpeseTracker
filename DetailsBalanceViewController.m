//
//  DetailsBalanceViewController.m
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 4/3/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import "DetailsBalanceViewController.h"
#import "AddPerticipentsViewController.h"
#import "TotalTableViewCell.h"
#import "AppDelegate.h"

@interface DetailsBalanceViewController ()

@end

@implementation DetailsBalanceViewController{
    
    NSMutableArray *resultsArray, *individualArray;
    AppDelegate *appDelegateString;
    float totalAmount, individualAmount;
    NSNumberFormatter *numberFormatter;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegateString = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.navigationItem.title = appDelegateString.string;
    individualArray = [[NSMutableArray alloc]init];
    numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundUp];
//    [self totalAmount];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self totalAmount];
    
}

-(NSManagedObjectContext *)getContext{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    return context;
    
}

-(NSArray *)fetchData{
    
    NSManagedObjectContext *context = [self getContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Participant"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == %@", appDelegateString.string];
    [request setPredicate:predicate];
    resultsArray = [[NSMutableArray alloc]initWithArray:[context executeFetchRequest:request error:nil]];
    return resultsArray;
    
}

-(void)totalAmount{
    
    NSArray *results;
    results = [self fetchData];
    totalAmount = 0;
    individualAmount = 0;
    for (Participant *exp in results) {
        
        totalAmount += exp.amount;
        
    }
    for (Participant *indicidualExp in results) {
        if (indicidualExp.amount != 0) {
            
//            individualAmount += indicidualExp.amount;
            [individualArray addObject:indicidualExp];
            
        }
    }
    [self.myTableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
        
    }
    else if (section == 1){
        
        return 1;
        
    }
    else if (section == 2){
        
        return 1;
        
    }
    
        return 0;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return nil;
        
    }
    else if (section == 1){
        
        return @"Should Pay";
        
    }
    else if(section == 2){
        
        return @"Should be Paid";
        
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        TotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"balanceCell"];
        cell.totalBalLabel.text = [NSString stringWithFormat:@"Rs.%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalAmount]]];
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"balanceCell1"];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"balanceCell1"];
            
        }
        cell.textLabel.text = @"Helloo";
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"balanceCell1"];
        cell.textLabel.text = @"Bye";
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 80;
    }
    else if (indexPath.section == 1){
        
        return 50;
        
    }
    else if (indexPath.section == 2){
        
        return 50;
        
    }
    return 0;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"addParticipants"]) {
        
        AddPerticipentsViewController *vc = [segue destinationViewController];
        vc.string = appDelegateString.string;

    }
}

@end
