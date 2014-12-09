//
//  ShareViewController.m
//  Qulture
//
//  Created by Rick Williams on 22/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import "ShareViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>


@interface ShareViewController ()

@end

BOOL busy;

@implementation ShareViewController

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
    [self setTags:[NSMutableArray arrayWithObjects:
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
                   nil]];
    
    [self setTag: [[self tags] objectAtIndex:0]];

	// Do any additional setup after loading the view.
    //[self.pic reloadAllComponents];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSString *filepath = [[appDelegate shareDict] objectForKey:@"SharePath"];
    //[self.photo setImage:  [UIImage imageWithContentsOfFile: filepath] ];
    [self.photo setImage: [[appDelegate shareDict] objectForKey:@"ShareImage"]];
    [[appDelegate shareDict]
     setObject:@" "  forKey:@"ShareCaption"];
    busy = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.tags count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
     }
    [tView setFont:[UIFont boldSystemFontOfSize:12]];
    [tView setText:[self.tags objectAtIndex:row]];
    return tView;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    [self setTag: [[self tags]objectAtIndex:row]];
}

- (IBAction)addCaption {
    //[self performSegueWithIdentifier:@"Caption" sender:nil];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Caption" message:@"Please enter a caption" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate shareDict]
     setObject:[[alertView textFieldAtIndex:0] text]  forKey:@"ShareCaption"];

}

-(UIImage*)imageWithImageOld:(UIImage*)image
             scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/*  I need to think on this
-(UIImage*)imageWithImage:(UIImage*)image
             scaledToSize:(CGSize)newSize;
{
    float whMax = MAX(newSize.width, newSize.height);
    CGSize imgSize = image.size;
    
    float scaleFactor = 0;
    if(imgSize.width<imgSize.height){
        scaleFactor = imgSize.width / whMax;
    }
    else scaleFactor = imgSize.width / whMax;
    
    CGSize scaledSize = newSize;
    scaledSize.width =
    
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
 */

-(UIImage*)scaleImg:(UIImage*)image

{
    CGSize newSize=[[UIScreen mainScreen] bounds].size ;
    
    float max = MAX(newSize.height, newSize.width);
    float min = MIN(image.size.height, image.size.width);
    
    float sf = min/max;
    
    CGSize sz = CGSizeMake(image.size.width/sf, image.size.height/sf);
    
    UIGraphicsBeginImageContext( sz );
    [image drawInRect:CGRectMake(0,0,sz.width,sz.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (IBAction)sharePicture {
    
    if(busy)return;
    
    busy = YES;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@.jpg",
                          [[appDelegate shareDict] objectForKey:@"ScreenName"],
                          [NSString stringWithFormat:@"%ld",unixTime]];
    
   // UIImage *scaledImage = [self imageWithImage:[[self photo] image] scaledToSize: [[UIScreen mainScreen] bounds].size ];
    
   // UIImage *scaledImage = [self scaleImage:[[self photo] image] toSize: [[UIScreen mainScreen] bounds].size ];
    
    UIImage *scaledImage =  [self scaleImg:self.photo.image];  // [[self photo] image];
    
    NSData *imageData = UIImageJPEGRepresentation(scaledImage, 0.75);
    
    PFFile *imageFile = [PFFile fileWithName:fileName data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            PFObject *bigObject = [PFObject objectWithClassName:@"Channel"];
            
            NSLog(@"user: %@, channel_name : %@, caption: %@",
                  [[appDelegate shareDict] objectForKey:@"ScreenName"],
                  [self tag],
                  [[appDelegate shareDict] objectForKey:@"ShareCaption"]);
            
            bigObject[@"user"] = [[appDelegate shareDict] objectForKey:@"ScreenName"];
            bigObject[@"channel_name"] = [self tag];
            bigObject[@"post"] = @"";
            bigObject[@"caption"] = [[appDelegate shareDict] objectForKey:@"ShareCaption"];
            bigObject[@"image_file"] = imageFile;
            [bigObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Information"
                                                                  message:@"File Saved"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                
                [message show];
                busy = NO;
            }];
        }
    }];
 
    
    
}
@end
