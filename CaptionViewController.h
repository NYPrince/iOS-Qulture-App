//
//  CaptionViewController.h
//  Qulture
//
//  Created by Rick Williams on 23/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaptionViewController : UIViewController <UITextViewDelegate>
- (IBAction)close;
@property (weak, nonatomic) IBOutlet UITextView *txtCaption;

@end
