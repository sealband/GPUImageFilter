#import "ShowcaseAppDelegate.h"
#import "ShowcaseFilterListController.h"
#import "ImportPhotoViewController.h"

@implementation ShowcaseAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    importPhotofilterNavigationController = [[UINavigationController alloc] init];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:YES];

    importPhotoVC = [[ImportPhotoViewController alloc] initWithNibName:nil bundle:nil];
    [importPhotofilterNavigationController pushViewController:importPhotoVC animated:NO];
    [self.window setRootViewController:importPhotofilterNavigationController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
