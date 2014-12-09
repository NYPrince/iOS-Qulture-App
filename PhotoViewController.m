//
//  SecondViewController.m
//  Qulture
//
//  Created by Rick Williams on 17/03/14.
//  Copyright (c) 2014 Qulture. All rights reserved.
//

#import "PhotoViewController.h"
#import "AppDelegate.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    [self setDocumentsPath:[paths objectAtIndex:0]];
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(sharePhoto) ];
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:editBarButtonItem, saveBarButtonItem, nil];

    [self loadCameraRoll];

}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.selectedPath=Nil;
    [self.collectionView reloadData];
}


-(void)takePhoto{
    
    UIImagePickerController *ip = [[UIImagePickerController alloc] init];
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
        [ip setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [ip setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }
    [ip setAllowsEditing:TRUE];
    [ip setDelegate:self];
    [self presentViewController:ip animated:YES completion:nil];
}

-(void)sharePhoto{
    if([self selectedPath]!=nil){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSIndexPath *indexPath = [self selectedPath];
        
        NSString *section = [[self sections] objectAtIndex:indexPath.section];
        NSMutableArray *record = [[self records] objectForKey:section];
        
        NSURL *asseturl = [NSURL URLWithString:[record objectAtIndex:indexPath.row]];
        [[self assetsLibrary] assetForURL:asseturl resultBlock:^(ALAsset *myasset)
         {
             ALAssetRepresentation *rep = [myasset defaultRepresentation];
             UIImage *image = [UIImage imageWithCGImage:[rep fullScreenImage] ];
             [[appDelegate shareDict] setObject:image  forKey:@"ShareImage"];
             [self performSegueWithIdentifier:@"SharePhotoPush" sender:nil];
             
         } failureBlock:nil];
        
        
        NSString *file_name = [[NSString alloc] initWithFormat:@"%@.jpg", [record objectAtIndex:indexPath.row] ];
        
        NSString *filePath = [self.documentsPath stringByAppendingPathComponent:file_name];
        
        [[appDelegate shareDict]
        setObject:filePath  forKey:@"SharePath"];
        
        
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [[self.records objectForKey: [self.sections objectAtIndex:section]] count] ;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SharePhotoHeader" forIndexPath:indexPath];
       // NSString *title = [[NSString alloc]initWithFormat:@"June %i 2013", indexPath.section + 1];
        
        UILabel *desc = (UILabel*)[reusableview viewWithTag:100];
        [desc setText: [self.sections objectAtIndex:indexPath.section] ];
    }
    
    return reusableview;
}




- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"SharePhotoCell" forIndexPath:indexPath];
    UIImageView *imgview = (UIImageView*)[cell viewWithTag:101];
    
    NSString *section = [[self sections] objectAtIndex:indexPath.section];
    NSMutableArray *record = [[self records] objectForKey:section];
    
    NSString *file_name = [record objectAtIndex:indexPath.row];
    NSURL *asseturl = [NSURL URLWithString:file_name];
    [[self assetsLibrary] assetForURL:asseturl resultBlock:^(ALAsset *myasset)
     {
       [imgview setImage:  [UIImage imageWithCGImage:[myasset thumbnail] ]];
     } failureBlock:nil];
    UIImageView *img = (UIImageView *)[cell viewWithTag:102];
    
    if(self.selectedPath!=Nil
       && [self.selectedPath section]==[indexPath section]
       && [self.selectedPath row]==[indexPath row]
       )[img setHidden: FALSE];
    //if(indexPath==[self selectedPath])[img setHidden: FALSE];
    else [img setHidden: TRUE];
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *img = (UIImageView *)[cell viewWithTag:102];
    
    BOOL isHidden = img.hidden;
    
    for(UICollectionView *cell in collectionView.visibleCells){
        UIImageView *img = (UIImageView *)[cell viewWithTag:102];
        [img setHidden: TRUE];
    }

    if(isHidden){
        [img setHidden: FALSE];
        [self setSelectedPath:indexPath];
    }
    else{
        [img setHidden: TRUE];
        [self setSelectedPath:nil];
    }
        
    
    
    //UILabel *desc = (UILabel*)[reusableview viewWithTag:100];
    
    //[self performSegueWithIdentifier:@"SharePhotoPush" sender:nil];
}



- (IBAction)takePicture:(id)sender{
    
    
    UIImagePickerController *ip = [[UIImagePickerController alloc] init];
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
        [ip setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [ip setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }
    [ip setDelegate:self];
    [self presentViewController:ip animated:YES completion:nil];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
     UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"ddddddddddd");
    
    UIImageWriteToSavedPhotosAlbum(image,
                                   self, // send the message to 'self' when calling the callback
                                   @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), // the selector to tell the method to call on completion
                                   NULL);
    
   
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
    } else {
        [self setSelectedPath: [NSIndexPath indexPathForItem:0 inSection:0]];
        [self loadCameraRoll];
    }
}


-(void) loadCameraRoll
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [self setAssetsLibrary:library];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"dd MMM yyyy"];
    NSMutableOrderedSet  *section = [[NSMutableOrderedSet alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    __block int sec_count = 0;
    __block NSMutableArray *array;
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *needToStop) {
            
            if(result!=Nil){
                NSDate *date = [result valueForProperty:ALAssetPropertyDate];
                NSString *dateOnly = [dateFormater stringFromDate:date];
                [section addObject:dateOnly];
                if(sec_count<[section count]){
                    array = [[NSMutableArray alloc] init];
                    [dict setObject:array forKey:dateOnly];
                    sec_count++;
                }
                [array addObject: [[[result defaultRepresentation] url] absoluteString]  ];
                if(index==0){
                    [self setSections:section];
                    [self setRecords:dict];
                    [self.collectionView reloadData];
                    return ;
                }
            }
        }];
    }
                         failureBlock:^(NSError *error) {
                             NSLog(@"%@",error.description);
                         }];
    
}


-(void) loadCameraRoll2
{
    [self setAssetsLibrary:[[ALAssetsLibrary alloc] init]];

    NSMutableArray *marray = [[NSMutableArray alloc] init];

    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        NSInteger numberOfAssets = [group numberOfAssets];
        if(numberOfAssets>0){
            for (int i = 0; i <= numberOfAssets-1; i++) {
                [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:i] options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
                 {
                     if (result != nil) {
                         [marray addObject:result];
                     }
                 }];
            }
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd MMM yyyy"];
            
            NSMutableOrderedSet  *sections = [[NSMutableOrderedSet alloc] init];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            //for(int i=0;i<[marray count];i++){
            for(int i=(int)[marray count]-1;i>=0;i--){
                ALAsset *result = [marray objectAtIndex:i];
                NSDate* date = [result valueForProperty:ALAssetPropertyDate];
                ALAssetRepresentation *rep = [result defaultRepresentation];
                NSString *section = [dateFormat stringFromDate:date];
                NSLog(@"Filename: %@ Date: %@", [rep filename], section);
                [sections addObject:section];
                
                NSMutableArray *ary = [dict objectForKey:section];
                if(ary == nil){
                    ary = [[NSMutableArray alloc]init];
                    [dict setObject:ary forKey:section];
                }
                NSLog(@"URL: %@", [[rep url] absoluteString]);
                [ary addObject: [[rep url] absoluteString]];
            }
            
            [sections sortUsingComparator:(NSComparator)^(id obj1, id obj2){
                NSDate *d1 = [dateFormat dateFromString:obj1];
                NSDate *d2 = [dateFormat dateFromString:obj2];
                if ([d1 compare:d2] == NSOrderedDescending) {
                    return false;
                }
                else return  true;
            }];
            
            [self setSections:sections];
            [self setRecords:dict];
            
            NSLog(@"Total Files: %lu", (unsigned long)[marray count]);
            [self.collectionView reloadData];
            
            
        }
        
    } failureBlock:nil];
    
}


@end
