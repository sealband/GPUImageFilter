#import <UIKit/UIKit.h>

@interface ShowcaseFilterListController : UITableViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController * imagePicker;
    UIPopoverController *accountBookPopSelectViewController;
    UIImage * stillImage;
}

@end
