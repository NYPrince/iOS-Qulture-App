//
//  FirstViewController.m
//  Qulture
//
//  Created by Rick Williams on 17/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self loadUserDetails];
    [[[self view] viewWithTag:200] setHidden:FALSE];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self readData];
    [self readPost];
    [self readAll];
    
 }


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [[self pfiles] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgview = (UIImageView*)[cell viewWithTag:101];
    
    PFFile *theImage = [self.pfiles objectAtIndex:[indexPath row]];
    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        [imgview setImage:[UIImage imageWithData:data]];
    }];
    
    
    return cell;
}

-(void) loadUserDetails
{
      
    NSString *url = [NSString stringWithFormat:
                     @"https://api.twitter.com/1.1/users/show.json?screen_name=%@",
                     [[PFTwitterUtils twitter] screenName]];
    
    NSURL *verify = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:NSJSONReadingMutableContainers error:nil];
                               
                               [[self userName] setText:[json objectForKey:@"name"]];
                               
                               NSString *pictUrl = [json objectForKey:@"profile_image_url_https"];
                               pictUrl = [pictUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
                               
                               NSMutableURLRequest *request = [NSMutableURLRequest
                                                               requestWithURL:[NSURL URLWithString:pictUrl]];
                               [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                                                      completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                          UIImage *image = [[UIImage alloc] initWithData:data];
                                                          [[self userImage] setImage:image];
                                                          
                                                      }];
                               
                           }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView tag]==200) return [[self all] count];
    else return [[self data] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    NSString *desc = nil;
    NSArray *ary = nil;
    
    if([tableView tag]==200){
     CellIdentifier = @"AllCell";
        ary = [[self all] objectAtIndex:indexPath.row];
        
        if([ary count]==1){
            desc = [ary objectAtIndex:0];
        }
        else{
             desc = [ary objectAtIndex:2];
        }
    }
    if([tableView tag]==201){
     CellIdentifier = @"PostCell";
        
        desc = [[self data] objectAtIndex:indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if([tableView tag]==201){
        [[cell imageView] setImage:[UIImage imageNamed:@"user"]];
        [[cell textLabel] setText: desc ];
        cell.textLabel.font  = [ UIFont fontWithName: @"Arial" size: 16.0 ];
    }
    
    if([tableView tag]==200){
        UIImageView *imgview = (UIImageView*)[cell viewWithTag:110];
        UITextView *txtview = (UITextView*)[cell viewWithTag:111];
        if([ary count]==3){
            
            //NSData *data = [[ary objectAtIndex:1] getData];
            //[imgview setImage:[UIImage imageWithData:data ]];
            
            PFFile *theImage = [ary objectAtIndex:1];
            [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                [imgview setImage:[UIImage imageWithData:data]];
            }];
            
            
            [txtview setText:desc];
        }
        else{
            [imgview setImage:[UIImage imageNamed:@"user"]];
            [txtview setText:desc];
        }
        
       // UIImageView *imgview = (UIImageView*)[cell viewWithTag:110];
        
       
    }
    
    return cell;
}


- (IBAction)segChanged:(UISegmentedControl *)sender {
    for(int i=0;i<2;i++){
        if([sender selectedSegmentIndex]==i)[[[self view] viewWithTag:200+i] setHidden:FALSE];
        else
            [[[self view] viewWithTag:200+i] setHidden:TRUE];
    }
}



- (void)readData{
    
    
    NSMutableArray *mdata = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Channel"];
    [query whereKey:@"user" equalTo: [[PFTwitterUtils twitter] screenName] ];
    [query whereKeyExists:@"image_file"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu data.", (unsigned long)objects.count);
            // Do something with the found objects
            
            for (PFObject *object in objects) {
                PFFile *file = [object objectForKey:@"image_file"];
               // NSLog(@"%@", object.objectId);
                [mdata addObject:file];
            }
            [self setPfiles:mdata];
            [[self collectionView] reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)readPost{
    
    NSMutableArray *mdata = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Channel"];
    [query whereKey:@"user" equalTo: [[PFTwitterUtils twitter] screenName] ];
    [query whereKeyDoesNotExist:@"image_file"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu data.", (unsigned long)objects.count);
            // Do something with the found objects
            
            for (PFObject *object in objects) {
                [mdata addObject:[object objectForKey:@"post"]];
            }
            [self setData:mdata];
            UITableView *tv = (UITableView*)[self.view viewWithTag:201];
            [tv reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)readAll{
    
    
    
    NSMutableArray *mdata = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Channel"];
    [query whereKey:@"user" equalTo: [[PFTwitterUtils twitter] screenName] ];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu data.", (unsigned long)objects.count);
            
            
            if(objects.count==0){
                [self.TextArea setHidden:NO];
            }
            else {
                [self.TextArea setHidden:YES];
            }

            
            
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSArray *ary = [NSArray arrayWithObjects:
                                [object objectForKey:@"post"],
                                [object objectForKey:@"image_file"],
                                [object objectForKey:@"caption"],
                                nil];
                [mdata addObject:ary];
            }
            [self setAll:mdata];
            UITableView *tv = (UITableView*)[self.view viewWithTag:200];
            [tv reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(IBAction)logout {
    [PFUser logOut];
    exit(0);
}


@end
