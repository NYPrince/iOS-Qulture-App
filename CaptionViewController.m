//
//  CaptionViewController.m
//  Qulture
//
//  Created by Rick Williams on 23/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import "CaptionViewController.h"
#import "AppDelegate.h"

@interface CaptionViewController ()

@end

@implementation CaptionViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate shareDict]
     setObject:[[self txtCaption] text]  forKey:@"ShareCaption"];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


@end
