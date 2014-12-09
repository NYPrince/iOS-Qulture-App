//
//  SlideViewController.h
//  Qulture
//
//  Created by Rick Williams on 23/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UITextView *captionV;
@property(nonatomic,retain) NSArray *names;

@property(nonatomic,retain) NSMutableArray *pfiles;
@property(nonatomic,retain) NSMutableArray *pcaps;

- (IBAction)close;

@end
