//
//  FirstViewController.h
//  Qulture
//
//  Created by Rick Williams on 17/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

- (IBAction)segChanged:(UISegmentedControl *)sender;


@property (weak, nonatomic) IBOutlet UILabel *TextArea;

@property(nonatomic) IBOutlet UICollectionView *collectionView;


@property(nonatomic,retain) NSMutableArray *pfiles;
@property(nonatomic,retain) NSMutableArray *data;
@property(nonatomic,retain) NSMutableArray *all;


- (IBAction)logout;

@end
