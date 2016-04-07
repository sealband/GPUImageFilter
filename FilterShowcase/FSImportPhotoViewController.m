//
//  ImportPhotoViewController.m
//  FilterShowcase
//
//  Created by seal on 3/14/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//

#import "FSImportPhotoViewController.h"
#import "FSShowcaseFilterViewController.h"

@interface FSImportPhotoViewController ()

@end

@implementation FSImportPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Import";
   
    CGRect frame = self.view.frame;
    UIButton *choosePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [choosePhotoBtn setImage:IMG(@"menu_camera") forState:UIControlStateNormal];
    [choosePhotoBtn addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
    choosePhotoBtn.frame = CGRectMake(frame.size.width/2-35, frame.size.height/2-20, 70, 36);
    [self.view addSubview:choosePhotoBtn];
    
    imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType sourceType;
    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = sourceType;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)choosePhoto
{
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showEditVC
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    FSShowcaseFilterViewController *filterViewController = [[FSShowcaseFilterViewController alloc] initWithFilterType:GPUIMAGE_SATURATION isStatic:YES stillImage:stillImage];
    [self.navigationController pushViewController:filterViewController animated:YES];
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *imageselect= [info valueForKey:UIImagePickerControllerOriginalImage];
    stillImage = imageselect ;
    
    
    [self showEditVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
