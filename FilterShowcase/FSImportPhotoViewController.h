//
//  ImportPhotoViewController.h
//  FilterShowcase
//
//  Created by seal on 3/14/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//


@interface FSImportPhotoViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController * imagePicker;
    UIPopoverController *accountBookPopSelectViewController;
    UIImage * stillImage;
}

@end
