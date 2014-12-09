//
//  SecondViewController.h
//  Qulture
//
//  Created by Rick Williams on 17/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoViewController : UIViewController
<UICollectionViewDataSource, UICollectionViewDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, retain) NSString *documentsPath;

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property(nonatomic, retain) NSMutableOrderedSet  *sections;
@property(nonatomic, retain) NSMutableDictionary  *records;

@property(nonatomic, retain) NSIndexPath *selectedPath;

@property(nonatomic, strong) NSArray *assets;

@property(nonatomic, retain) ALAssetsLibrary *assetsLibrary;


- (IBAction)takePicture:(id)sender;

- (void)takePhoto;
- (void)sharePhoto;

@end
