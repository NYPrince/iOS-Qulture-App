//
//  QueerViewController.m
//  Qulture
//
//  Created by Rick Williams on 17/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import "QueerViewController.h"
#import "DiscoverViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface QueerViewController ()

@end

@implementation QueerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setTitle:[[appDelegate shareDict] objectForKey:@"DiscIndex"]];
    [self readData];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DiscoverCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //UIImageView *img = (UIImageView *)[cell viewWithTag:100];
    UILabel *usr = (UILabel*)[cell viewWithTag:101];
    UITextView *desc = (UITextView*)[cell viewWithTag:102];
    UILabel *tdesc = (UILabel*)[cell viewWithTag:103];
    
    NSArray *array = [self.data objectAtIndex:indexPath.row];
    
    [usr setText:array[0]];
    [desc setText:array[1]];
    [tdesc setText: [self timeSincePublished: array[2]]];
    
    return cell;
}

- (IBAction)showPhotos:(id)sender {
    [self performSegueWithIdentifier:@"Slides" sender:nil];

}

- (IBAction)addPost {
    //[self performSegueWithIdentifier:@"Caption" sender:nil];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Post" message:@"Please enter a post" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"Entered: %@ %ld",[[alertView textFieldAtIndex:0] text], (long)buttonIndex);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(buttonIndex==1){
        PFObject *bigObject = [PFObject objectWithClassName:@"Channel"];
        bigObject[@"user"] = [[appDelegate shareDict] objectForKey:@"ScreenName"];
        bigObject[@"channel_name"] = [self title];
        bigObject[@"post"] = [[alertView textFieldAtIndex:0] text];
        [bigObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self readData];
        }];
        
    }
    
    [[appDelegate shareDict]
     
     
     setObject:[[alertView textFieldAtIndex:0] text]  forKey:@"ShareCaption"];
    
}

- (void)readData{
   
    NSMutableArray *mdata = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Channel"];
    [query whereKey:@"channel_name" equalTo:[self title]];
    [query whereKeyDoesNotExist:@"image_file"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu data.", (unsigned long)objects.count);
            // Do something with the found objects
            
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSArray *data = [NSArray arrayWithObjects:
                                 [object objectForKey:@"user"],
                                 [object objectForKey:@"post"],
                                 [object updatedAt],
                                 nil];
                
                [mdata addObject:data];
            }
            [self setData:mdata];
            [self.tableV reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(NSString *)timeSincePublished:(NSDate *)publicationDate
{
    double ti = [publicationDate timeIntervalSinceNow];
    
    ti = ti * -1;
    if (ti < 1) {
        return @"1 sec";
    } else if (ti < 60) {
        return @"1 min";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d min(s)", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hr(s)", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d day(s)", diff];
    } else if (ti < 31556926) {
        int diff = round(ti / 60 / 60 / 24 / 30);
        return [NSString stringWithFormat:@"%d month(s)", diff];
    } else {
        int diff = round(ti / 60 / 60 / 24 / 30 / 12);
        return [NSString stringWithFormat:@"%d year(s)", diff];
    }
}

@end
