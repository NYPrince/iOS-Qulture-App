//
//  SlideViewController.m
//  Qulture
//
//  Created by Rick Williams on 23/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import "SlideViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>


@interface SlideViewController ()


@end

int iindex;

@implementation SlideViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNames:
     [NSArray arrayWithObjects:
      @"sample-1.jpg",
      @"sample-2.jpg",
      @"sample-3.jpg",
      @"sample-4.jpg",
      @"sample-5.jpg",
      nil]
     ];
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     
                                                     action:@selector(oneFingerSwipeLeft:)];
    
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      
                                                      action:@selector(oneFingerSwipeRight:)];
    
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //iindex = 0;
    //[[self imageV] setImage:[UIImage imageNamed: [[self names] objectAtIndex:0] ]];
    [self readData];
}



-(void)oneFingerSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
    if([[self pfiles]count]==0)return;
    
    if(++iindex >=  [[self pfiles] count]  ){iindex = [[self pfiles] count]-1.0;return;}
    
    PFFile *theImage = [self.pfiles objectAtIndex:iindex];
    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        [[self imageV] setImage:[UIImage imageWithData:data]];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [[self.imageV layer] addAnimation:animation forKey:nil];
        [[self captionV]setText:[self.pcaps objectAtIndex:iindex]];
    }];
    
}
- (void)oneFingerSwipeRight:(UISwipeGestureRecognizer *)recognizer {
    if([[self pfiles]count]==0)return;
    
    if(--iindex<0){iindex = 0; return;}
    
    PFFile *theImage = [self.pfiles objectAtIndex:iindex];
    [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
        [[self imageV] setImage:[UIImage imageWithData:data]];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.5];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [[self.imageV layer] addAnimation:animation forKey:nil];
        
        [[self captionV]setText:[self.pcaps objectAtIndex:iindex]];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close{

    [self dismissViewControllerAnimated:TRUE completion:nil];
}



- (void)readData{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setTitle:[[appDelegate shareDict] objectForKey:@"DiscIndex"]];
    
    NSString *channel_name = [[appDelegate shareDict] objectForKey:@"DiscIndex"];

    
    NSMutableArray *mdata = [[NSMutableArray alloc] init];
    NSMutableArray *mcaps = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Channel"];
    [query whereKey:@"channel_name" equalTo:channel_name];
    [query whereKeyExists:@"image_file"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu data.", (unsigned long)objects.count);
            // Do something with the found objects
            
            for (PFObject *object in objects) {
                [mcaps addObject:[object objectForKey:@"caption"]];
                PFFile *file = [object objectForKey:@"image_file"];
                NSLog(@"%@", object.objectId);
                [mdata addObject:file];
            }
            [self setPfiles:mdata];
            [self setPcaps:mcaps];
            if([[self pfiles]count]==0)return;
            iindex = 0;
            NSData *data = [[self.pfiles objectAtIndex:iindex] getData];
            [[self imageV] setImage:[UIImage imageWithData:data]];
            [[self captionV]setText:[self.pcaps objectAtIndex:iindex]];

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
