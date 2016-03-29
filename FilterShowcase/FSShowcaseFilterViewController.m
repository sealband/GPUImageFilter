#import "FSShowcaseFilterViewController.h"
#import <CoreImage/CoreImage.h>
#import "FSOutputTableViewController.h"


#define kCellWidth                                  140
#define kCellHeight                                 60
#define kArticleCellVerticalInnerPadding            3
#define kArticleCellHorizontalInnerPadding          6
#define kArticleTitleLabelPadding                   4
#define kRowVerticalPadding                         0
#define kRowHorizontalPadding                       0

@implementation FSShowcaseFilterViewController
@synthesize faceDetector,stillImage;
@synthesize isStatic;
;

#pragma mark -
#pragma mark Initialization and teardown

- (id)initWithFilterType:(GPUImageShowcaseFilterType)newFilterType;
{
    self = [super init];
    if (self)
    {
        filterType = newFilterType;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc;
{
    stillImage = nil;
}

- (void)resetFilterArray
{
    arrFilterSource =
    [@[
        //0-10
@{@"name":@"Saturation",@"filter":@"GPUImageSaturationFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Contrast",@"filter":@"GPUImageContrastFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@4.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Brightness",@"filter":@"GPUImageBrightnessFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@1.0,@"min":@-1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Levels",@"filter":@"GPUImageLevelsFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Exposure",@"filter":@"GPUImageExposureFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@4.0,@"min":@-4.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"RGB",@"filter":@"GPUImageRGBFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Hue",@"filter":@"GPUImageHueFilter",@"value":@90.0,@"defaultvalue":@90.0,@"max":@360.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"White balance",@"filter":@"GPUImageWhiteBalanceFilter",@"value":@5000.0,@"defaultvalue":@5000.0,@"max":@7500.0,@"min":@2500.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Monochrome",@"filter":@"GPUImageMonochromeFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"False color",@"filter":@"GPUImageFalseColorFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
@{@"name":@"Sharpen",@"filter":@"GPUImageSharpenFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@4.0,@"min":@-1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},

//11-20
@{@"name":@"Unsharp mask",@"filter":@"GPUImageUnsharpMaskFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@5.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Transform (2-D)",@"filter":@"GPUImageTransformFilter",@"value":@2.0,@"defaultvalue":@2.0,@"max":@6.28,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Transform (3-D)",@"filter":@"GPUImageTransformFilter",@"value":@0.75,@"defaultvalue":@0.75,@"max":@6.28,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Crop",@"filter":@"GPUImageCropFilter",@"filter":@"",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.2,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Mask",@"filter":@"GPUImageMaskFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value
@{@"name":@"Gamma",@"filter":@"GPUImageGammaFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@3.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Tone curve",@"filter":@"GPUImageToneCurveFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Highlights and shadows",@"filter":@"GPUImageHighlightShadowFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Haze/UV",@"filter":@"GPUImageHazeFilter",@"value":@0.2,@"defaultvalue":@0.2,@"max":@0.2,@"min":@-0.2,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Sepia tone",@"filter":@"GPUImageSepiaFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
//21-30
@{@"name":@"Amatorka (Lookup)",@"filter":@"GPUImageAmatorkaFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
@{@"name":@"Miss Etikate (Lookup)",@"filter":@"GPUImageMissEtikateFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
@{@"name":@"Soft elegance (Lookup)",@"filter":@"GPUImageSoftEleganceFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
@{@"name":@"Color invert",@"filter":@"GPUImageColorInvertFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
@{@"name":@"Grayscale",@"filter":@"GPUImageGrayscaleFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
@{@"name":@"Histogram",@"filter":@"GPUImageHistogramFilter",@"value":@16.0,@"defaultvalue":@16.0,@"max":@32.0,@"min":@4.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Histogram Equalization",@"filter":@"GPUImageHistogramEqualizationFilter",@"value":@16.0,@"defaultvalue":@16.0,@"max":@32.0,@"min":@4.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Average color",@"filter":@"GPUImageAverageColor",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
@{@"name":@"Luminosity",@"filter":@"GPUImageLuminosity",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
@{@"name":@"Threshold",@"filter":@"GPUImageLuminanceThresholdFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},//notsure//filternotsure

//31-40
@{@"name":@"Adaptive threshold",@"filter":@"GPUImageAdaptiveThresholdFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@20.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Avg. Lum. Threshold",@"filter":@"GPUImageAverageLuminanceThresholdFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Pixellate",@"filter":@"GPUImagePixellateFilter",@"value":@0.05,@"defaultvalue":@0.05,@"max":@0.3,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Polar pixellate",@"filter":@"GPUImagePolarPixellateFilter",@"value":@0.05,@"defaultvalue":@0.05,@"max":@0.1,@"min":@-0.1,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Pixellate (position)",@"filter":@"GPUImagePixellatePositionFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@0.5,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Polka dot",@"filter":@"GPUImagePolkaDotFilter",@"value":@0.05,@"defaultvalue":@0.05,@"max":@0.0,@"min":@0.3,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Halftone",@"filter":@"GPUImageHalftoneFilter",@"value":@0.01,@"defaultvalue":@0.01,@"max":@0.05,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Crosshatch",@"filter":@"GPUImageCrosshatchFilter",@"value":@0.03,@"defaultvalue":@0.03,@"max":@0.06,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Sobel edge detection",@"filter":@"GPUImageSobelEdgeDetectionFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Prewitt edge detection",@"filter":@"GPUImagePrewittEdgeDetectionFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
//41-50
@{@"name":@"Canny edge detection",@"filter":@"GPUImageCannyEdgeDetectionFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Threshold edge detection",@"filter":@"GPUImageThresholdEdgeDetectionFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"XY Derivative",@"filter":@"GPUImageXYDerivativeFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value--------------------
@{@"name":@"Harris corner detection",@"filter":@"GPUImageHarrisCornerDetectionFilter",@"value":@0.20,@"defaultvalue":@0.20,@"max":@0.70,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Noble corner detection",@"filter":@"GPUImageNobleCornerDetectionFilter",@"value":@0.20,@"defaultvalue":@0.20,@"max":@0.70,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Shi-Tomasi feature detection",@"filter":@"GPUImageShiTomasiFeatureDetectionFilter",@"value":@0.20,@"defaultvalue":@0.20,@"max":@0.70,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Hough transform line detection",@"filter":@"GPUImageHoughTransformLineDetector",@"value":@0.6,@"defaultvalue":@0.6,@"max":@1.0,@"min":@0.2,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Image Buffer",@"filter":@"GPUImageBuffer",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value--------------------
@{@"name":@"Low pass",@"filter":@"GPUImageLowPassFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"High pass",@"filter":@"GPUImageHighPassFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
//51-60
@{@"name":@"Motion detector",@"filter":@"GPUImageMotionDetector",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Sketch",@"filter":@"GPUImageSketchFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Threshold Sketch",@"filter":@"GPUImageThresholdSketchFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Toon",@"filter":@"GPUImageToonFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value--------------------
@{@"name":@"Smooth toon",@"filter":@"GPUImageSmoothToonFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@6.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Tilt shift",@"filter":@"GPUImageTiltShiftFilter",@"value":@0.4,@"defaultvalue":@0.4,@"max":@0.6,@"min":@0.2,@"sliderhidden":@"NO",@"hasValue":@"yes"},//norsure  COMPLEX
@{@"name":@"CGA Colorspace",@"filter":@"GPUImageCGAColorspaceFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value--------------------
@{@"name":@"Posterize",@"filter":@"GPUImagePosterizeFilter",@"value":@10.0,@"defaultvalue":@10.0,@"max":@20.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"3x3 Convolution",@"filter":@"GPUImage3x3ConvolutionFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value-------------------- COMPLEX
@{@"name":@"Emboss",@"filter":@"GPUImageEmbossFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@5.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
//61-70
@{@"name":@"Laplacian",@"filter":@"GPUImageLaplacianFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value--------------------
@{@"name":@"Chroma Key (Green)",@"filter":@"GPUImageChromaKeyFilter",@"value":@0.4,@"defaultvalue":@0.4,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},//COMPLEX
@{@"name":@"Kuwahara",@"filter":@"GPUImageKuwaharaFilter",@"value":@3.0,@"defaultvalue":@3.0,@"max":@8.0,@"min":@3.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Kuwahara (Radius 3)",@"filter":@"GPUImageKuwaharaRadius3Filter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value--------------------
@{@"name":@"Vignette",@"filter":@"GPUImageVignetteFilter",@"value":@0.75,@"defaultvalue":@0.75,@"max":@0.9,@"min":@0.5,@"sliderhidden":@"NO",@"hasValue":@"yes"},//notsure
@{@"name":@"Gaussian blur",@"filter":@"GPUImageGaussianBlurFilter",@"value":@2.0,@"defaultvalue":@2.0,@"max":@24.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Gaussian selective blur",@"filter":@"GPUImageGaussianSelectiveBlurFilter",@"value":@(40.0/320.0),@"defaultvalue":@(40.0/320.0),@"max":@0.75,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Selective Blur",@"filter":@"GPUImageGaussianBlurPositionFilter",@"value":@(40.0/320.0),@"defaultvalue":@(40.0/320.0),@"max":@.75,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},//COMPLEX
@{@"name":@"Box blur",@"filter":@"GPUImageBoxBlurFilter",@"value":@2.0,@"defaultvalue":@2.0,@"max":@24.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Median",@"filter":@"GPUImageMedianFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value--------------------
//71-80
@{@"name":@"Bilateral blur",@"filter":@"GPUImageBilateralFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@10.0,@"min":@0.0,@"sliderhidden":@"YES",@"hasValue":@"yes"},
@{@"name":@"Motion blur",@"filter":@"GPUImageMotionBlurFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@180.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Zoom blur",@"filter":@"GPUImageZoomBlurFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.5,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"iOS 7 Blur",@"filter":@"GPUImageiOSBlurFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value--------------------
@{@"name":@"Swirl",@"filter":@"GPUImageSwirlFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Bulge",@"filter":@"GPUImageBulgeDistortionFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@-1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Pinch",@"filter":@"GPUImagePinchDistortionFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@2.0,@"min":@-2.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Sphere refraction",@"filter":@"GPUImageSphereRefractionFilter",@"value":@0.15,@"defaultvalue":@0.15,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Glass sphere",@"filter":@"GPUImageGlassSphereFilter",@"value":@0.15,@"defaultvalue":@0.15,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Stretch",@"filter":@"GPUImageStretchDistortionFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value--------------------
//81-90
@{@"name":@"Dilation",@"filter":@"GPUImageRGBDilationFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// COMPLEX
@{@"name":@"Erosion",@"filter":@"GPUImageRGBErosionFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// COMPLEX
@{@"name":@"Opening",@"filter":@"GPUImageRGBOpeningFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// COMPLEX
@{@"name":@"Closing",@"filter":@"GPUImageRGBClosingFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// COMPLEX
@{@"name":@"Perlin noise",@"filter":@"GPUImagePerlinNoiseFilter",@"value":@8.0,@"defaultvalue":@8.0,@"max":@30.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Voronoi",@"filter":@"GPUImageVoronoiConsumerFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value-------------------- COMPLEX
@{@"name":@"Mosaic",@"filter":@"GPUImageMosaicFilter",@"value":@0.025,@"defaultvalue":@0.025,@"max":@0.05,@"min":@0.002,@"sliderhidden":@"NO",@"hasValue":@"yes"},//spcial
@{@"name":@"Local binary pattern",@"filter":@"GPUImageLocalBinaryPatternFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@5.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Dissolve blend",@"filter":@"GPUImageDissolveBlendFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Chroma Key (Green)",@"filter":@"GPUImageChromaKeyBlendFilter",@"value":@0.4,@"defaultvalue":@0.4,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},//COMPLEX
//91-100
@{@"name":@"Add Blend",@"filter":@"GPUImageAddBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value-------------------- second
@{@"name":@"Divide Blend",@"filter":@"GPUImageDivideBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value-------------------- second
@{@"name":@"Multiply Blend",@"filter":@"GPUImageMultiplyBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value-------------------- second
@{@"name":@"Overlay Blend",@"filter":@"GPUImageOverlayBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value-------------------- second
@{@"name":@"Lighten Blend",@"filter":@"GPUImageLightenBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value-------------------- second
@{@"name":@"Darken Blend",@"filter":@"GPUImageDarkenBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value-------------------- second
@{@"name":@"Color Burn Blend",@"filter":@"GPUImageColorBurnBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO"},// no value-------------------- second
@{@"name":@"Color dodge blend",@"filter":@"GPUImageColorDodgeBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},// no value-------------------- second
@{@"name":@"Linear burn blend",@"filter":@"GPUImageLinearBurnBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},// no value-------------------- second
@{@"name":@"Screen blend",@"filter":@"GPUImageScreenBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},// no value-------------------- second
//101-110
@{@"name":@"Difference blend",@"filter":@"GPUImageDifferenceBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
@{@"name":@"Subtract blend",@"filter":@"GPUImageSubtractBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
@{@"name":@"Exclusion blend",@"filter":@"GPUImageExclusionBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
@{@"name":@"Hard light blend",@"filter":@"GPUImageHardLightBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
@{@"name":@"Soft light blend",@"filter":@"GPUImageSoftLightBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
@{@"name":@"Color blend",@"filter":@"GPUImageColorBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
@{@"name":@"Hue blend",@"filter":@"GPUImageHueBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
@{@"name":@"Saturation blend",@"filter":@"GPUImageSaturationBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
@{@"name":@"Luminosity blend",@"filter":@"GPUImageLuminosityBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
@{@"name":@"Normal blend",@"filter":@"GPUImageNormalBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
//111-
@{@"name":@"Poisson blend",@"filter":@"GPUImagePoissonBlendFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"}, //second
@{@"name":@"Opacity adjustment",@"filter":@"GPUImageOpacityFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
@{@"name":@"Custom",@"filter":@"GPUImageFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
@{@"name":@"UI element",@"filter":@"GPUImageSepiaFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
]mutableCopy];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    [self resetFilterArray];
    
    sourceImageView = [[UIImageView alloc] init];
    CGRect sourceFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-167);
    sourceImageView.frame = sourceFrame;
    sourceImageView.backgroundColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1];
    sourceImageView.contentMode = UIViewContentModeScaleAspectFit;
    sourceImageView.image = stillImage;
    [self.view addSubview:sourceImageView];
    
    if ([GPUImageContext supportsFastTextureUpload])
    {
        NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
        self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
        faceThinking = NO;
    }
    
    toolContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, DEVICEH-167, DEVICEW, 167)];
    toolContentView.showsHorizontalScrollIndicator = NO;
    toolContentView.scrollEnabled = NO;
    [toolContentView setContentSize:CGSizeMake(DEVICEW*2, 167)];
    [self.view addSubview:toolContentView];

    horizontalTableView = [[UITableView alloc] init];
    horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    horizontalTableView.frame = CGRectMake(0, 0, DEVICEW, 117);
    horizontalTableView.delegate = self;
    horizontalTableView.dataSource = self;
    horizontalTableView.separatorStyle = UITableViewStylePlain;
    [toolContentView addSubview:horizontalTableView];
    
    UIButton *savebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savebtn.frame = CGRectMake(DEVICEW, toolContentView.frame.size.height-47, 60, 44);
    [savebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [savebtn setTitle:@"save" forState:UIControlStateNormal];
    [savebtn addTarget:self action:@selector(backDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolContentView addSubview:savebtn];
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, DEVICEH-47, 60, 44);
        [btn setImage:IMG(@"edit_btn_back") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btnPre = btn;
    }
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(DEVICEW-60, DEVICEH-47, 60, 44);
        [btn setImage:IMG(@"edit_btn_next") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nextDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btnNext = btn;
    }
    
    CHLine *line = [CHLine lineWithFrame:CGRectMake(0, DEVICEH-167, DEVICEW, 0.5) color:[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1]];
    [self.view addSubview:line];
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICEW-50, DEVICEH-125, 50, 25)];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont systemFontOfSize:10];
    valueLabel.textColor = [UIColor whiteColor];
    [valueLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:valueLabel];
    
    sliderView = [[FSSliderView alloc] initWithFrame:CGRectMake(0, DEVICEH, DEVICEW, 100)];
    sliderView.delegate = self;
    [self.view addSubview:sliderView];
    
//    [self setBackSel:@selector(back)];
//    [self setRight:@selector(outputFilterParemeters) image:@"edit_obj_menu_typesetting" highlight:nil];
//    [self setTitle:@"Default"];

    currFilterDic = [[NSMutableDictionary alloc] init];
    filterArr = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Note: I needed to stop camera capture before the view went off the screen in order to prevent a crash from the camera still sending frames
    [videoCamera stopCameraCapture];
    
	[super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Note: I needed to start camera capture after the view went on the screen, when a partially transition of navigation view controller stopped capturing via viewWilDisappear.
//    [videoCamera startCameraCapture];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)outputFilterParemeters
{
    FSOutputTableViewController *outputTableVC = [[FSOutputTableViewController alloc] initWithFilterArr:filterArr];
    [self.navigationController pushViewController:outputTableVC animated:YES];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrFilterSource count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];

    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 60, 70)];
    }
    cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.font = [UIFont systemFontOfSize:8];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld\n%@",index,[[arrFilterSource objectAtIndex:index] getValueForKey:@"name"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    filterType = (GPUImageShowcaseFilterType)indexPath.row;
    NSString *filterParameterStr;
    if (currentValue) {
        filterParameterStr = [NSString stringWithFormat:@"%@:%@",self.title,currentValue];
    } else
    {
        filterParameterStr = [NSString stringWithFormat:@"%@:%@",self.title,currentValue];
    }
    
    NSMutableArray *d = [[arrFilterSource objectAtIndex:indexPath.row] mutableCopy];
    NSString *filterStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    [d setValue:filterStr forKey:@"filterTypeInt"];
    [arrFilterSource replaceObjectAtIndex:indexPath.row withObject:d];
    
    [sliderView setDic:arrFilterSource[indexPath.row] tag:[indexPath row]];
    [UIView animateWithDuration:0.2 animations:^{
        sliderView.frame = CGRectMake(0, DEVICEH-100, DEVICEW, 100);
    } completion:^(BOOL finished) {
    }];
    
    [self setupFilter];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setupFilter;
{
    if (isStatic) {
        if (stillImage) {
            staticPicture = [[GPUImagePicture alloc] initWithImage:stillImage smoothlyScaleOutput:YES];
        } else
        {
            UIImage *inputImage = [UIImage imageNamed:@"sample1.jpg"];
            staticPicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
        }
    } else
    {
        videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    
    facesSwitch.hidden = YES;
    facesLabel.hidden = YES;
//    BOOL needsSecondImage = NO;
    
    NSInteger typeNumber = (NSInteger)filterType;
    
    NSDictionary *filterDic = [arrFilterSource objectAtIndex:typeNumber];
    self.title = [filterDic getValueForKey:@"name"];

    if (filterType == GPUIMAGE_FILECONFIG)
    {
        self.title = @"File Configuration";
        
        pipeline = [[GPUImageFilterPipeline alloc] initWithConfigurationFile:[[NSBundle mainBundle] URLForResource:@"SampleConfiguration" withExtension:@"plist"]
                                                                                               input:videoCamera output:(GPUImageView*)self.view];
    }
    else 
    {
        if (filterType != GPUIMAGE_VORONOI)
        {
//            [videoCamera addTarget:filter];
        }
        
        videoCamera.runBenchmark = YES;
    }

}

#pragma mark -
#pragma mark Filter adjustments

- (void)filterSliderTag:(NSInteger)tag senderValue:(float)senderValue
{
    
    if (tag < [arrFilterSource count]) {
        NSMutableArray *d = [[arrFilterSource objectAtIndex:tag] mutableCopy];
        [d setValue:@(senderValue) forKey:@"value"];
        [arrFilterSource replaceObjectAtIndex:tag withObject:d];
    }
    
    NSMutableArray *sourceFilter = [NSMutableArray new];
    for (NSDictionary *d in arrFilterSource) {
        if ([[d getValueForKey:@"value"] floatValue] != [[d getValueForKey:@"defaultvalue"] floatValue]) {
            [sourceFilter addObject:d];
        } else {
            sourceImageView.image = stillImage;
        }
    }
    
    if ([sourceFilter count]!=0) {
        [currFilterDic setValue:sourceFilter forKey:@"filtertype"];
        [self updateFilterBlend];
    }
}

- (void)updateFilterBlend
{
    [filterArr removeAllObjects];
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:stillImage];
    GPUImageOutput *filterOutput = nil;
    GPUImageOutput *lastfilter = nil;
    
    
    for (NSDictionary *dic in [currFilterDic getValueForKey:@"filtertype"]){
        //        GPUImageOutput *f = nil;
        
        GPUImageOutput <GPUImageInput>* filter = nil;
        
        Class filterClass = NSClassFromString([dic getValueForKey:@"filter"]);
        filter = [[filterClass alloc] init];
        
        
        NSString *filterTypeStr = [dic getValueForKey:@"filterTypeInt"];
        float sliderValue = [[dic getValueForKey:@"value"] floatValue];
        
        
        
        [self updateFilterFromSliderwitFilter:filter filterStr:filterTypeStr sliderValue:sliderValue];
        
        if (!filter) {
            continue;
        }
        
        if (!filterOutput) {
            filterOutput = filter;
        }
        if (lastfilter) {
            [lastfilter addTarget:filter];
            lastfilter = filter;
        }
        else
        {
            lastfilter = filter;
        }
    }
    
    [stillImageSource addTarget:(GPUImageOutput <GPUImageInput>*)filterOutput];
    [lastfilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    sourceImageView.image = [lastfilter imageFromCurrentFramebuffer];
    
    
    for (NSDictionary *filterDic in [currFilterDic getValueForKey:@"filtertype"]){
        NSString *filterParameterStr = [NSString stringWithFormat:@"%@:%@",[filterDic getValueForKey:@"name"],[filterDic getValueForKey:@"value"]];
        [filterArr addObject:filterParameterStr];
        
    }
}

- (IBAction)updateFilterFromSliderwitFilter:(GPUImageOutput <GPUImageInput>*)filter filterStr:(NSString*)str sliderValue:(float)slidervalue;
{
//    [videoCamera resetBenchmarkAverage];

    NSInteger type = [str integerValue];
    switch(type)
    {
        case GPUIMAGE_SEPIA: [(GPUImageSepiaFilter *)filter setIntensity:slidervalue]; break;
        case GPUIMAGE_PIXELLATE: [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:slidervalue]; break;
        case GPUIMAGE_POLARPIXELLATE: [(GPUImagePolarPixellateFilter *)filter setPixelSize:CGSizeMake(slidervalue, slidervalue)]; break;
        case GPUIMAGE_PIXELLATE_POSITION: [(GPUImagePixellatePositionFilter *)filter setRadius:slidervalue]; break;
        case GPUIMAGE_POLKADOT: [(GPUImagePolkaDotFilter *)filter setFractionalWidthOfAPixel:slidervalue]; break;
        case GPUIMAGE_HALFTONE: [(GPUImageHalftoneFilter *)filter setFractionalWidthOfAPixel:slidervalue]; break;
        case GPUIMAGE_SATURATION: [(GPUImageSaturationFilter *)filter setSaturation:slidervalue]; break;
        case GPUIMAGE_CONTRAST: [(GPUImageContrastFilter *)filter setContrast:slidervalue]; break;
        case GPUIMAGE_BRIGHTNESS: [(GPUImageBrightnessFilter *)filter setBrightness:slidervalue]; break;
        case GPUIMAGE_LEVELS: {
            float value = slidervalue;
            [(GPUImageLevelsFilter *)filter setRedMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
            [(GPUImageLevelsFilter *)filter setGreenMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
            [(GPUImageLevelsFilter *)filter setBlueMin:value gamma:1.0 max:1.0 minOut:0.0 maxOut:1.0];
        }; break;
        case GPUIMAGE_EXPOSURE: [(GPUImageExposureFilter *)filter setExposure:slidervalue]; break;
        case GPUIMAGE_MONOCHROME: [(GPUImageMonochromeFilter *)filter setIntensity:slidervalue]; break;
        case GPUIMAGE_RGB: [(GPUImageRGBFilter *)filter setGreen:slidervalue]; break;
        case GPUIMAGE_HUE: [(GPUImageHueFilter *)filter setHue:slidervalue]; break;
        case GPUIMAGE_WHITEBALANCE: [(GPUImageWhiteBalanceFilter *)filter setTemperature:slidervalue]; break;
        case GPUIMAGE_SHARPEN: [(GPUImageSharpenFilter *)filter setSharpness:slidervalue]; break;
        case GPUIMAGE_HISTOGRAM: [(GPUImageHistogramFilter *)filter setDownsamplingFactor:round(slidervalue)]; break;
        case GPUIMAGE_HISTOGRAM_EQUALIZATION: [(GPUImageHistogramEqualizationFilter *)filter setDownsamplingFactor:round(slidervalue)]; break;
        case GPUIMAGE_UNSHARPMASK: [(GPUImageUnsharpMaskFilter *)filter setIntensity:slidervalue]; break;
//        case GPUIMAGE_UNSHARPMASK: [(GPUImageUnsharpMaskFilter *)filter setBlurSize:slidervalue]; break;
        case GPUIMAGE_GAMMA: [(GPUImageGammaFilter *)filter setGamma:slidervalue]; break;
        case GPUIMAGE_CROSSHATCH: [(GPUImageCrosshatchFilter *)filter setCrossHatchSpacing:slidervalue]; break;
        case GPUIMAGE_POSTERIZE: [(GPUImagePosterizeFilter *)filter setColorLevels:round(slidervalue)]; break;
        case GPUIMAGE_HAZE: [(GPUImageHazeFilter *)filter setDistance:slidervalue]; break;
        case GPUIMAGE_SOBELEDGEDETECTION: [(GPUImageSobelEdgeDetectionFilter *)filter setEdgeStrength:slidervalue]; break;
        case GPUIMAGE_PREWITTEDGEDETECTION: [(GPUImagePrewittEdgeDetectionFilter *)filter setEdgeStrength:slidervalue]; break;
        case GPUIMAGE_SKETCH: [(GPUImageSketchFilter *)filter setEdgeStrength:slidervalue]; break;
        case GPUIMAGE_THRESHOLD: [(GPUImageLuminanceThresholdFilter *)filter setThreshold:slidervalue]; break;
        case GPUIMAGE_ADAPTIVETHRESHOLD: [(GPUImageAdaptiveThresholdFilter *)filter setBlurRadiusInPixels:slidervalue]; break;
        case GPUIMAGE_AVERAGELUMINANCETHRESHOLD: [(GPUImageAverageLuminanceThresholdFilter *)filter setThresholdMultiplier:slidervalue]; break;
        case GPUIMAGE_DISSOLVE: [(GPUImageDissolveBlendFilter *)filter setMix:slidervalue]; break;
        case GPUIMAGE_POISSONBLEND: [(GPUImagePoissonBlendFilter *)filter setMix:slidervalue]; break;
        case GPUIMAGE_LOWPASS: [(GPUImageLowPassFilter *)filter setFilterStrength:slidervalue]; break;
        case GPUIMAGE_HIGHPASS: [(GPUImageHighPassFilter *)filter setFilterStrength:slidervalue]; break;
        case GPUIMAGE_MOTIONDETECTOR: [(GPUImageMotionDetector *)filter setLowPassFilterStrength:slidervalue]; break;
        case GPUIMAGE_CHROMAKEY:
            [(GPUImageChromaKeyBlendFilter *)filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
            [(GPUImageChromaKeyBlendFilter *)filter setThresholdSensitivity:slidervalue]; break;
        case GPUIMAGE_CHROMAKEYNONBLEND:
            [(GPUImageChromaKeyFilter *)filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
            [(GPUImageChromaKeyFilter *)filter setThresholdSensitivity:slidervalue]; break;
        case GPUIMAGE_KUWAHARA: [(GPUImageKuwaharaFilter *)filter setRadius:round(slidervalue)]; break;
        case GPUIMAGE_SWIRL: [(GPUImageSwirlFilter *)filter setAngle:slidervalue]; break;
        case GPUIMAGE_EMBOSS: [(GPUImageEmbossFilter *)filter setIntensity:slidervalue]; break;
        case GPUIMAGE_CANNYEDGEDETECTION: [(GPUImageCannyEdgeDetectionFilter *)filter setBlurTexelSpacingMultiplier:slidervalue]; break;
//        case GPUIMAGE_CANNYEDGEDETECTION: [(GPUImageCannyEdgeDetectionFilter *)filter setLowerThreshold:slidervalue]; break;
        case GPUIMAGE_HARRISCORNERDETECTION: [(GPUImageHarrisCornerDetectionFilter *)filter setThreshold:slidervalue]; break;
        case GPUIMAGE_NOBLECORNERDETECTION: [(GPUImageNobleCornerDetectionFilter *)filter setThreshold:slidervalue]; break;
        case GPUIMAGE_SHITOMASIFEATUREDETECTION: [(GPUImageShiTomasiFeatureDetectionFilter *)filter setThreshold:slidervalue]; break;
        case GPUIMAGE_HOUGHTRANSFORMLINEDETECTOR: [(GPUImageHoughTransformLineDetector *)filter setLineDetectionThreshold:slidervalue]; break;
//        case GPUIMAGE_HARRISCORNERDETECTION: [(GPUImageHarrisCornerDetectionFilter *)filter setSensitivity:slidervalue]; break;
        case GPUIMAGE_THRESHOLDEDGEDETECTION: [(GPUImageThresholdEdgeDetectionFilter *)filter setThreshold:slidervalue]; break;
        case GPUIMAGE_SMOOTHTOON: [(GPUImageSmoothToonFilter *)filter setBlurRadiusInPixels:slidervalue]; break;
        case GPUIMAGE_THRESHOLDSKETCH: [(GPUImageThresholdSketchFilter *)filter setThreshold:slidervalue]; break;
//        case GPUIMAGE_BULGE: [(GPUImageBulgeDistortionFilter *)filter setRadius:slidervalue]; break;
        case GPUIMAGE_BULGE: [(GPUImageBulgeDistortionFilter *)filter setScale:slidervalue]; break;
        case GPUIMAGE_SPHEREREFRACTION: [(GPUImageSphereRefractionFilter *)filter setRadius:slidervalue]; break;
        case GPUIMAGE_GLASSSPHERE: [(GPUImageGlassSphereFilter *)filter setRadius:slidervalue]; break;
        case GPUIMAGE_TONECURVE: [(GPUImageToneCurveFilter *)filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, slidervalue)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]]; break;
        case GPUIMAGE_HIGHLIGHTSHADOW: [(GPUImageHighlightShadowFilter *)filter setHighlights:slidervalue]; break;
        case GPUIMAGE_PINCH: [(GPUImagePinchDistortionFilter *)filter setScale:slidervalue]; break;
        case GPUIMAGE_PERLINNOISE:  [(GPUImagePerlinNoiseFilter *)filter setScale:slidervalue]; break;
        case GPUIMAGE_MOSAIC:  [(GPUImageMosaicFilter *)filter setDisplayTileSize:CGSizeMake(slidervalue, slidervalue)]; break;
        case GPUIMAGE_VIGNETTE: [(GPUImageVignetteFilter *)filter setVignetteEnd:slidervalue]; break;
        case GPUIMAGE_BOXBLUR: [(GPUImageBoxBlurFilter *)filter setBlurRadiusInPixels:slidervalue]; break;
        case GPUIMAGE_GAUSSIAN: [(GPUImageGaussianBlurFilter *)filter setBlurRadiusInPixels:slidervalue]; break;
//        case GPUIMAGE_GAUSSIAN: [(GPUImageGaussianBlurFilter *)filter setBlurPasses:round(slidervalue)]; break;
//        case GPUIMAGE_BILATERAL: [(GPUImageBilateralFilter *)filter setBlurSize:slidervalue]; break;
        case GPUIMAGE_BILATERAL: [(GPUImageBilateralFilter *)filter setDistanceNormalizationFactor:slidervalue]; break;
        case GPUIMAGE_MOTIONBLUR: [(GPUImageMotionBlurFilter *)filter setBlurAngle:slidervalue]; break;
        case GPUIMAGE_ZOOMBLUR: [(GPUImageZoomBlurFilter *)filter setBlurSize:slidervalue]; break;
        case GPUIMAGE_OPACITY:  [(GPUImageOpacityFilter *)filter setOpacity:slidervalue]; break;
        case GPUIMAGE_GAUSSIAN_SELECTIVE: [(GPUImageGaussianSelectiveBlurFilter *)filter setExcludeCircleRadius:slidervalue]; break;
        case GPUIMAGE_GAUSSIAN_POSITION:
            [(GPUImageGaussianBlurPositionFilter*)filter setBlurRadius:40.0/320.0];
            [(GPUImageGaussianBlurPositionFilter *)filter setBlurRadius:slidervalue]; break;
        case GPUIMAGE_FILTERGROUP: [(GPUImagePixellateFilter *)[(GPUImageFilterGroup *)filter filterAtIndex:1] setFractionalWidthOfAPixel:slidervalue]; break;
        case GPUIMAGE_CROP: [(GPUImageCropFilter *)filter setCropRegion:CGRectMake(0.0, 0.0, 1.0, slidervalue)]; break;
        case GPUIMAGE_TRANSFORM: [(GPUImageTransformFilter *)filter setAffineTransform:CGAffineTransformMakeRotation(slidervalue)]; break;
        case GPUIMAGE_TRANSFORM3D:
        {
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, slidervalue, 0.0, 1.0, 0.0);

            [(GPUImageTransformFilter *)filter setTransform3D:perspectiveTransform];            
        }; break;
        case GPUIMAGE_TILTSHIFT:
        {
            CGFloat midpoint = slidervalue;
            [(GPUImageTiltShiftFilter *)filter setTopFocusLevel:midpoint - 0.1];
            [(GPUImageTiltShiftFilter *)filter setBottomFocusLevel:midpoint + 0.1];
        }; break;
        case GPUIMAGE_LOCALBINARYPATTERN:
        {
            CGFloat multiplier = slidervalue;
            [(GPUImageLocalBinaryPatternFilter *)filter setTexelWidth:(multiplier / self.view.bounds.size.width)];
            [(GPUImageLocalBinaryPatternFilter *)filter setTexelHeight:(multiplier / self.view.bounds.size.height)];
        }; break;
        default: break;
    }
}

#pragma mark - Face Detection Delegate Callback
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    if (!faceThinking) {
        CFAllocatorRef allocator = CFAllocatorGetDefault();
        CMSampleBufferRef sbufCopyOut;
        CMSampleBufferCreateCopy(allocator,sampleBuffer,&sbufCopyOut);
        [self performSelectorInBackground:@selector(grepFacesForSampleBuffer:) withObject:CFBridgingRelease(sbufCopyOut)];
    }
}

- (void)grepFacesForSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    faceThinking = TRUE;
    NSLog(@"Faces thinking");
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
	CIImage *convertedImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    
	if (attachments)
		CFRelease(attachments);
	NSDictionary *imageOptions = nil;
	UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
	int exifOrientation;
	
    /* kCGImagePropertyOrientation values
     The intended display orientation of the image. If present, this key is a CFNumber value with the same value as defined
     by the TIFF and EXIF specifications -- see enumeration of integer constants.
     The value specified where the origin (0,0) of the image is located. If not present, a value of 1 is assumed.
     
     used when calling featuresInImage: options: The value for this key is an integer NSNumber from 1..8 as found in kCGImagePropertyOrientation.
     If present, the detection will be done based on that orientation but the coordinates in the returned features will still be based on those of the image. */
    
	enum {
		PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
		PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
		PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
		PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
		PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
		PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
		PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
	};
	BOOL isUsingFrontFacingCamera = FALSE;
    AVCaptureDevicePosition currentCameraPosition = [videoCamera cameraPosition];
    
    if (currentCameraPosition != AVCaptureDevicePositionBack)
    {
        isUsingFrontFacingCamera = TRUE;
    }
    
	switch (curDeviceOrientation) {
		case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
			exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
			break;
		case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
			if (isUsingFrontFacingCamera)
				exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			else
				exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			break;
		case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
			if (isUsingFrontFacingCamera)
				exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			else
				exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			break;
		case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
		default:
			exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
			break;
	}
    
	imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:exifOrientation] forKey:CIDetectorImageOrientation];

    NSLog(@"Face Detector %@", [self.faceDetector description]);
    NSLog(@"converted Image %@", [convertedImage description]);
    NSArray *features = [self.faceDetector featuresInImage:convertedImage options:imageOptions];    
    
    // get the clean aperture
    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
    // that represents image data valid for display.
    CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
    CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false /*originIsTopLeft == false*/);
    
    [self GPUVCWillOutputFeatures:features forClap:clap andOrientation:curDeviceOrientation];
    faceThinking = FALSE;
    
}

- (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
                 andOrientation:(UIDeviceOrientation)curDeviceOrientation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Did receive array");
    
        CGRect previewBox = self.view.frame;
	
        if (featureArray == nil && faceView) {
            [faceView removeFromSuperview];
            faceView = nil;
        }
    
        for ( CIFaceFeature *faceFeature in featureArray) {
            
            // find the correct position for the square layer within the previewLayer
            // the feature box originates in the bottom left of the video frame.
            // (Bottom right if mirroring is turned on)
            NSLog(@"%@", NSStringFromCGRect([faceFeature bounds]));
            
            //Update face bounds for iOS Coordinate System
            CGRect faceRect = [faceFeature bounds];
            
            // flip preview width and height
            CGFloat temp = faceRect.size.width;
            faceRect.size.width = faceRect.size.height;
            faceRect.size.height = temp;
            temp = faceRect.origin.x;
            faceRect.origin.x = faceRect.origin.y;
            faceRect.origin.y = temp;
            // scale coordinates so they fit in the preview box, which may be scaled
            CGFloat widthScaleBy = previewBox.size.width / clap.size.height;
            CGFloat heightScaleBy = previewBox.size.height / clap.size.width;
            faceRect.size.width *= widthScaleBy;
            faceRect.size.height *= heightScaleBy;
            faceRect.origin.x *= widthScaleBy;
            faceRect.origin.y *= heightScaleBy;
            
            faceRect = CGRectOffset(faceRect, previewBox.origin.x, previewBox.origin.y);
            
            if (faceView) {
                [faceView removeFromSuperview];
                faceView =  nil;
            }
            
            // create a UIView using the bounds of the face
            faceView = [[UIView alloc] initWithFrame:faceRect];
            
            // add a border around the newly created UIView
            faceView.layer.borderWidth = 1;
            faceView.layer.borderColor = [[UIColor redColor] CGColor];
            
            // add the new view to create a box around the face
            [self.view addSubview:faceView];
            
        }
    });
    
}

-(IBAction)facesSwitched:(UISwitch*)sender{
    if (![sender isOn]) {
        [videoCamera setDelegate:nil];
        if (faceView) {
            [faceView removeFromSuperview];
            faceView = nil;
        }
    }else{
        [videoCamera setDelegate:self];

    }
}


@end
