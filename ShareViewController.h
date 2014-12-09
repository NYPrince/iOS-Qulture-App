//
//  ShareViewController.h
//  Qulture
//
//  Created by Rick Williams on 22/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>

- (IBAction)addCaption;

@property(nonatomic, strong) NSMutableArray *tags;

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property(nonatomic, weak) IBOutlet UIPickerView *pic;

@property(nonatomic, retain) NSString *tag;

- (IBAction)sharePicture;



@end
