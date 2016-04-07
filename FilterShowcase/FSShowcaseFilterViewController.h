#import "GPUImage.h"
#import "FSSliderView.h"

@interface FSShowcaseFilterViewController : UIViewController <GPUImageVideoCameraDelegate,UITableViewDelegate,UITableViewDataSource,SRTEditorFilterSliderDelegate,FSParameterViewDelegate,FSPresetViewDelegate>
{
    GPUImageVideoCamera *videoCamera;
    GPUImagePicture *sourcePicture;
    GPUImageShowcaseFilterType filterType;
    GPUImageUIElement *uiElementInput;
    
    GPUImageFilterPipeline *pipeline;
    
    FSSliderView *sliderView;
    
    FSPresetViewController *presetVC;
    
    GPUImagePicture *staticPicture;
    BOOL isStatic;
    NSMutableArray *filterArr;
    
    UITableView *horizontalTableView;
    UILabel *valueLabel;
    NSString *currentValue;
    
    UIScrollView *toolContentView;
    UIButton *btnNext;
    UIButton *btnPre;
    UILabel *titleLabel;
    UILabel *secondTitleLabel;

    
    NSMutableArray *arrFilterSource;
    NSMutableDictionary *currFilterDic;
    
    NSMutableArray *presetFilterArr;
    NSMutableArray *sourceFilter;

    UIImageView *sourceImageView;
    
    NSInteger currStep;
    UIView *alertView;
    
    FSParameterView *parameterView;
}

@property(nonatomic,retain)UIImage * stillImage;
@property(nonatomic,assign) BOOL isStatic;

// Initialization and teardown
- (id)initWithFilterType:(GPUImageShowcaseFilterType)newFilterType isStatic:(BOOL)isStaticImage stillImage:(UIImage*)image;
- (void)setupFilter;
// Filter adjustments
- (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
                 andOrientation:(UIDeviceOrientation)curDeviceOrientation;
@end
