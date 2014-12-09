//
//  ThirdViewController.m
//  StoryBoardSample
//
//  Created by Rick Williams on 13/03/14.
//  Copyright (c) 2014 Aditya Narayan. All rights reserved.
//

#import "DiscoverViewController.h"
#import "AppDelegate.h"

@interface DiscoverViewController ()

@end

static NSString *selData;

@implementation DiscoverViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setData:
     [NSMutableArray arrayWithObjects:
      @"# Community",
      @"# Spirituality",
      @"# Family",
      @"# Health",
      @"# Representation",
      @"# Lounge",
      @"# Scholarship",
      @"# Politics",
      @"# Art/self expression",
      @"# Solidarity",
      nil]
     ];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self data] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [[cell textLabel] setText: [[self data] objectAtIndex:[indexPath row]] ];
    cell.textLabel.font  = [ UIFont fontWithName: @"Arial" size: 16.0 ];
    
    [[cell imageView] setImage:[UIImage imageNamed:@"channel_icon"]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.imageView.userInteractionEnabled = YES;
    cell.imageView.tag = indexPath.row;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
    tapped.numberOfTapsRequired = 1;
    [cell.imageView addGestureRecognizer:tapped];
    
    return cell;
}

-(void)myFunction :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %ld", (long)gesture.view.tag);

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate shareDict]
     setObject:  [[self data] objectAtIndex:gesture.view.tag] forKey:@"DiscIndex"];
    
    
    [self performSegueWithIdentifier:@"DirectSlides" sender:nil];

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate shareDict]
     setObject:  [[self data] objectAtIndex:[indexPath row]] forKey:@"DiscIndex"];
    
    [self performSegueWithIdentifier:@"QueerPush" sender:nil];
}


+ (NSString*)selectedData{
    return selData;
}

@end
