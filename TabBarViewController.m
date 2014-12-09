//
//  TabBarViewController.m
//  Qulture
//
//  Created by Rick Williams on 17/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import "TabBarViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *index = [[appDelegate shareDict] objectForKey:@"TabIndex"];
    
    if(index!=nil){
        [self setSelectedIndex: index.intValue ];
        [[appDelegate shareDict] removeObjectForKey:@"TabIndex"];
    }
    
    
}

@end
