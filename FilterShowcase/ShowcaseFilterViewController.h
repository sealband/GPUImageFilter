#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "FilterTypeDefination.h"
#import "SliderView.h"

@interface ShowcaseFilterViewController : UIViewController <GPUImageVideoCameraDelegate,UITableViewDelegate,UITableViewDataSource,SRTEditorFilterSliderDelegate>
{
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImagePicture *sourcePicture;
    GPUImageShowcaseFilterType filterType;
    GPUImageUIElement *uiElementInput;
    
    GPUImageFilterPipeline *pipeline;
    UIView *faceView;
    
    CIDetector *faceDetector;
    
    IBOutlet UISwitch *facesSwitch;
    IBOutlet UILabel *facesLabel;
    SliderView *sliderView;
    BOOL faceThinking;
    
    
    GPUImagePicture *staticPicture;
    BOOL isStatic;
    NSMutableArray *arrayTemp;
    NSMutableArray *filterArr;
    
    UITableView *horizontalTableView;
    UILabel *valueLabel;
    NSString *currentValue;
    
    
    
    NSMutableArray *arrFilterSource;

    CGRect frame ;
    UIImageView *sourceImageView;
}

@property(nonatomic,retain) NSMutableArray *checkedArray,*checkedIndexArray,*arrayTemp,*allCellArray;
@property(nonatomic,retain)UIImage * stillImage;
@property(nonatomic,assign) BOOL isStatic;

@property(nonatomic,retain) CIDetector*faceDetector;
// Initialization and teardown
- (id)initWithFilterType:(GPUImageShowcaseFilterType)newFilterType;
- (void)setupFilter;
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;
// Filter adjustments
- (IBAction)updateFilterFromSlider:(id)sender;
- (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
                 andOrientation:(UIDeviceOrientation)curDeviceOrientation;
-(IBAction)facesSwitched:(id)sender;
@end
