#import "GPUImage.h"
#import "FSSliderView.h"

@interface FSShowcaseFilterViewController : UIViewController <GPUImageVideoCameraDelegate,UITableViewDelegate,UITableViewDataSource,SRTEditorFilterSliderDelegate,FSParameterViewDelegate,FSPresetViewDelegate>
{
    GPUImageVideoCamera *videoCamera;
    GPUImagePicture *sourcePicture;
    GPUImageShowcaseFilterType filterType;
    GPUImageUIElement *uiElementInput;
    
    GPUImageFilterPipeline *pipeline;
    UIView *faceView;
    
    CIDetector *faceDetector;
    
    IBOutlet UISwitch *facesSwitch;
    IBOutlet UILabel *facesLabel;
    FSSliderView *sliderView;
    BOOL faceThinking;
    
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

@property(nonatomic,retain) NSMutableArray *checkedArray,*checkedIndexArray,*allCellArray;
@property(nonatomic,retain)UIImage * stillImage;
@property(nonatomic,assign) BOOL isStatic;

@property(nonatomic,retain) CIDetector*faceDetector;
// Initialization and teardown
- (id)initWithFilterType:(GPUImageShowcaseFilterType)newFilterType;
- (void)setupFilter;
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
// Filter adjustments
- (IBAction)updateFilterFromSliderwitFilter:(GPUImageOutput <GPUImageInput>*)filter filterStr:(NSString*)str sliderValue:(float)slidervalue;
- (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
                 andOrientation:(UIDeviceOrientation)curDeviceOrientation;
-(IBAction)facesSwitched:(id)sender;
@end
