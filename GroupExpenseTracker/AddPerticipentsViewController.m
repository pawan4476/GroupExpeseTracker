//
//  AddPerticipentsViewController.m
//  GroupExpenseTracker
//
//  Created by Nagam Pawan on 3/23/17.
//  Copyright © 2017 Nagam Pawan. All rights reserved.
//

#import "AddPerticipentsViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>


@interface AddPerticipentsViewController ()<UITextFieldDelegate>



@end

@implementation AddPerticipentsViewController{
    
    UIToolbar *toolBar;
    NSMutableArray *results;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.string);
    [self.addPerticipentsTextField becomeFirstResponder];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.items = [NSArray arrayWithObjects:
                     [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:@selector(cancel)],
                     [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                     [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:nil action:@selector(done)], nil];
    [toolBar sizeToFit];
    self.addPerticipentsTextField.inputAccessoryView = toolBar;
    [self fetchParticipantData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)done{
    
    NSManagedObjectContext *context = [self getContext];
    self.participantObject = [NSEntityDescription insertNewObjectForEntityForName:@"Participant" inManagedObjectContext:context];
   self.participantObject.names = self.addPerticipentsTextField.text;
    [self.groupObject addParticipantsObject:self.participantObject];
    
    [self saveData];
    self.addPerticipentsTextField.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)fetchParticipantData {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Groups"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupName == %@", self.string];
    [request setPredicate:predicate];
    results = [[NSMutableArray alloc]initWithArray:[[self getContext] executeFetchRequest:request error:nil]];
    if (results.count > 0) {
        self.groupObject = [results objectAtIndex:0];
    }
    else{
        
        self.groupObject = [NSEntityDescription insertNewObjectForEntityForName:@"Groups" inManagedObjectContext:[self getContext]];
        self.groupObject.groupName = self.string;
        [self.groupObject addParticipantsObject:self.participantObject];
    }
    [self saveData];
}

-(void)saveData {
    if ([[self getContext] save:nil]) {
        
        NSLog(@"Data saved");
        
    }
    else{
        
        NSLog(@"Data not saved");
        
    }
}

-(void)cancel{
    
    [toolBar setHidden:YES];
    [self.addPerticipentsTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSManagedObjectContext *)getContext{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    return context;
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField) {
        
        [toolBar setHidden:NO];
        
    }
}

@end
