//
//  ImportPhotoViewController.h
//  FilterShowcase
//
//  Created by seal on 3/14/16.
//  Copyright © 2016 Cell Phone. All rights reserved.
//


@interface ImportPhotoViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController * imagePicker;
    UIPopoverController *accountBookPopSelectViewController;
    UIImage * stillImage;
}

@end
