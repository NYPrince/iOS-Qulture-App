//
//  QueerViewController.h
//  Qulture
//
//  Created by Rick Williams on 17/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueerViewController : UIViewController
<UITableViewDataSource>

@property(nonatomic, retain) NSMutableArray *data;
- (IBAction)showPhotos:(id)sender;
- (IBAction)addPost;
@property (weak, nonatomic) IBOutlet UITableView *tableV;

@end
