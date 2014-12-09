//
//  MainViewController.m
//  Qulture
//
//Created by Rick Williams on 17/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface MainViewController ()

@end


@implementation MainViewController

-(void) viewDidLoad{
    
    [super viewDidLoad];
    
    [[self view] setHidden:TRUE];
    
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
        } else {
            NSLog(@"User logged in with Twitter!");
        }
        [[self view] setHidden:FALSE];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[appDelegate shareDict]
         setObject:[[PFTwitterUtils twitter] screenName]    forKey:@"ScreenName"];
    }];

}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSDictionary *dict  = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"0",@"Profile",@"1",@"Discover",@"2",@"Photo", nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate shareDict]
     setObject:  [dict objectForKey:[segue identifier]] forKey:@"TabIndex"];
}

@end
