#import "FSShowcaseFilterViewController.h"
#import <CoreImage/CoreImage.h>

@implementation FSShowcaseFilterViewController
@synthesize stillImage;
@synthesize isStatic;
;

#pragma mark -
#pragma mark Initialization and teardown

- (id)initWithFilterType:(GPUImageShowcaseFilterType)newFilterType isStatic:(BOOL)isStaticImage stillImage:(UIImage*)image;
{
    self = [super init];
    if (self)
    {
        filterType = newFilterType;
        isStatic = isStaticImage;
        stillImage = image;
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
@{@"name":@"Saturation",@"filter":@"GPUImageSaturationFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@0},
@{@"name":@"Contrast",@"filter":@"GPUImageContrastFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@4.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@1},
@{@"name":@"Brightness",@"filter":@"GPUImageBrightnessFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@1.0,@"min":@-1.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@2},
@{@"name":@"Levels",@"filter":@"GPUImageLevelsFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@3},
@{@"name":@"Exposure",@"filter":@"GPUImageExposureFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@4.0,@"min":@-4.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@4},
@{@"name":@"RGB",@"filter":@"GPUImageRGBFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@5},
@{@"name":@"Hue",@"filter":@"GPUImageHueFilter",@"value":@90.0,@"defaultvalue":@90.0,@"max":@360.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@6},
@{@"name":@"White balance",@"filter":@"GPUImageWhiteBalanceFilter",@"value":@5000.0,@"defaultvalue":@5000.0,@"max":@7500.0,@"min":@2500.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@7},
@{@"name":@"Monochrome",@"filter":@"GPUImageMonochromeFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@8},
@{@"name":@"False color",@"filter":@"GPUImageFalseColorFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@9},//无value值
@{@"name":@"Sharpen",@"filter":@"GPUImageSharpenFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@4.0,@"min":@-1.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@10},

//11-20
@{@"name":@"Unsharp mask",@"filter":@"GPUImageUnsharpMaskFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@5.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@11},
@{@"name":@"Transform (2-D)",@"filter":@"GPUImageTransformFilter",@"value":@2.0,@"defaultvalue":@2.0,@"max":@6.28,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@12},
@{@"name":@"Transform (3-D)",@"filter":@"GPUImageTransformFilter",@"value":@0.75,@"defaultvalue":@0.75,@"max":@6.28,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@13},
@{@"name":@"Crop",@"filter":@"GPUImageCropFilter",@"filter":@"",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.2,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@14},
@{@"name":@"Mask",@"filter":@"GPUImageMaskFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@15},//无value
@{@"name":@"Gamma",@"filter":@"GPUImageGammaFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@3.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@16},
@{@"name":@"Tone curve",@"filter":@"GPUImageToneCurveFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@17},
@{@"name":@"Highlights and shadows",@"filter":@"GPUImageHighlightShadowFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@18},
@{@"name":@"Haze/UV",@"filter":@"GPUImageHazeFilter",@"value":@0.2,@"defaultvalue":@0.2,@"max":@0.2,@"min":@-0.2,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@19},
@{@"name":@"Sepia tone",@"filter":@"GPUImageSepiaFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@20},
//21-30
@{@"name":@"Amatorka (Lookup)",@"filter":@"GPUImageAmatorkaFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@21},//无value值
@{@"name":@"Miss Etikate (Lookup)",@"filter":@"GPUImageMissEtikateFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@22},//无value值
@{@"name":@"Soft elegance (Lookup)",@"filter":@"GPUImageSoftEleganceFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@23},//无value值
@{@"name":@"Color invert",@"filter":@"GPUImageColorInvertFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@24},//无value值
@{@"name":@"Grayscale",@"filter":@"GPUImageGrayscaleFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@25},//无value值
@{@"name":@"Histogram",@"filter":@"GPUImageHistogramFilter",@"value":@16.0,@"defaultvalue":@16.0,@"max":@32.0,@"min":@4.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@26},
@{@"name":@"Histogram Equalization",@"filter":@"GPUImageHistogramEqualizationFilter",@"value":@16.0,@"defaultvalue":@16.0,@"max":@32.0,@"min":@4.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@27},
@{@"name":@"Average color",@"filter":@"GPUImageAverageColor",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@28},//无value值
@{@"name":@"Luminosity",@"filter":@"GPUImageLuminosity",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@29},//无value值
@{@"name":@"Threshold",@"filter":@"GPUImageLuminanceThresholdFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@30},//notsure//filternotsure

//31-40
@{@"name":@"Adaptive threshold",@"filter":@"GPUImageAdaptiveThresholdFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@20.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@31},
@{@"name":@"Avg. Lum. Threshold",@"filter":@"GPUImageAverageLuminanceThresholdFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@32},
@{@"name":@"Pixellate",@"filter":@"GPUImagePixellateFilter",@"value":@0.05,@"defaultvalue":@0.05,@"max":@0.3,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@33},
@{@"name":@"Polar pixellate",@"filter":@"GPUImagePolarPixellateFilter",@"value":@0.05,@"defaultvalue":@0.05,@"max":@0.1,@"min":@-0.1,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@34},
@{@"name":@"Pixellate (position)",@"filter":@"GPUImagePixellatePositionFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@0.5,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@35},
@{@"name":@"Polka dot",@"filter":@"GPUImagePolkaDotFilter",@"value":@0.05,@"defaultvalue":@0.05,@"max":@0.0,@"min":@0.3,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@36},
@{@"name":@"Halftone",@"filter":@"GPUImageHalftoneFilter",@"value":@0.01,@"defaultvalue":@0.01,@"max":@0.05,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@37},
@{@"name":@"Crosshatch",@"filter":@"GPUImageCrosshatchFilter",@"value":@0.03,@"defaultvalue":@0.03,@"max":@0.06,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@38},
@{@"name":@"Sobel edge detection",@"filter":@"GPUImageSobelEdgeDetectionFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@39},
@{@"name":@"Prewitt edge detection",@"filter":@"GPUImagePrewittEdgeDetectionFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@40},
//41-50
@{@"name":@"Canny edge detection",@"filter":@"GPUImageCannyEdgeDetectionFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@41},
@{@"name":@"Threshold edge detection",@"filter":@"GPUImageThresholdEdgeDetectionFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@42},
@{@"name":@"XY Derivative",@"filter":@"GPUImageXYDerivativeFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@43},// no value--------------------
@{@"name":@"Harris corner detection",@"filter":@"GPUImageHarrisCornerDetectionFilter",@"value":@0.20,@"defaultvalue":@0.20,@"max":@0.70,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@44},
@{@"name":@"Noble corner detection",@"filter":@"GPUImageNobleCornerDetectionFilter",@"value":@0.20,@"defaultvalue":@0.20,@"max":@0.70,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@45},
@{@"name":@"Shi-Tomasi feature detection",@"filter":@"GPUImageShiTomasiFeatureDetectionFilter",@"value":@0.20,@"defaultvalue":@0.20,@"max":@0.70,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@46},
@{@"name":@"Hough transform line detection",@"filter":@"GPUImageHoughTransformLineDetector",@"value":@0.6,@"defaultvalue":@0.6,@"max":@1.0,@"min":@0.2,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@47},
@{@"name":@"Image Buffer",@"filter":@"GPUImageBuffer",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@48},// no value--------------------
@{@"name":@"Low pass",@"filter":@"GPUImageLowPassFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@49},
@{@"name":@"High pass",@"filter":@"GPUImageHighPassFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@50},
//51-60
@{@"name":@"Motion detector",@"filter":@"GPUImageMotionDetector",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@51},
@{@"name":@"Sketch",@"filter":@"GPUImageSketchFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@52},
@{@"name":@"Threshold Sketch",@"filter":@"GPUImageThresholdSketchFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@53},
@{@"name":@"Toon",@"filter":@"GPUImageToonFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@54},// no value--------------------
@{@"name":@"Smooth toon",@"filter":@"GPUImageSmoothToonFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@6.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@55},
@{@"name":@"Tilt shift",@"filter":@"GPUImageTiltShiftFilter",@"value":@0.4,@"defaultvalue":@0.4,@"max":@0.6,@"min":@0.2,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@56},//norsure  COMPLEX
@{@"name":@"CGA Colorspace",@"filter":@"GPUImageCGAColorspaceFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@57},// no value--------------------
@{@"name":@"Posterize",@"filter":@"GPUImagePosterizeFilter",@"value":@10.0,@"defaultvalue":@10.0,@"max":@20.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@58},
@{@"name":@"3x3 Convolution",@"filter":@"GPUImage3x3ConvolutionFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@59},// no value-------------------- COMPLEX
@{@"name":@"Emboss",@"filter":@"GPUImageEmbossFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@5.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@60},
//61-70
@{@"name":@"Laplacian",@"filter":@"GPUImageLaplacianFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@61},// no value--------------------
@{@"name":@"Chroma Key (Green)",@"filter":@"GPUImageChromaKeyFilter",@"value":@0.4,@"defaultvalue":@0.4,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@62},//COMPLEX
@{@"name":@"Kuwahara",@"filter":@"GPUImageKuwaharaFilter",@"value":@3.0,@"defaultvalue":@3.0,@"max":@8.0,@"min":@3.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@63},
@{@"name":@"Kuwahara (Radius 3)",@"filter":@"GPUImageKuwaharaRadius3Filter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@64},// no value--------------------
@{@"name":@"Vignette",@"filter":@"GPUImageVignetteFilter",@"value":@0.75,@"defaultvalue":@0.75,@"max":@0.9,@"min":@0.5,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@65},//notsure
@{@"name":@"Gaussian blur",@"filter":@"GPUImageGaussianBlurFilter",@"value":@2.0,@"defaultvalue":@2.0,@"max":@24.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@66},
@{@"name":@"Gaussian selective blur",@"filter":@"GPUImageGaussianSelectiveBlurFilter",@"value":@(40.0/320.0),@"defaultvalue":@(40.0/320.0),@"max":@0.75,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@67},
@{@"name":@"Selective Blur",@"filter":@"GPUImageGaussianBlurPositionFilter",@"value":@(40.0/320.0),@"defaultvalue":@(40.0/320.0),@"max":@.75,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@68},//COMPLEX
@{@"name":@"Box blur",@"filter":@"GPUImageBoxBlurFilter",@"value":@2.0,@"defaultvalue":@2.0,@"max":@24.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@69},
@{@"name":@"Median",@"filter":@"GPUImageMedianFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@70},// no value--------------------
//71-80
@{@"name":@"Bilateral blur",@"filter":@"GPUImageBilateralFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@10.0,@"min":@0.0,@"sliderhidden":@"YES",@"hasValue":@"yes",@"filterTypeInt":@71},
@{@"name":@"Motion blur",@"filter":@"GPUImageMotionBlurFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@180.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@72},
@{@"name":@"Zoom blur",@"filter":@"GPUImageZoomBlurFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.5,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@73},
@{@"name":@"iOS 7 Blur",@"filter":@"GPUImageiOSBlurFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@74},// no value--------------------
@{@"name":@"Swirl",@"filter":@"GPUImageSwirlFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@75},
@{@"name":@"Bulge",@"filter":@"GPUImageBulgeDistortionFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@-1.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@76},
@{@"name":@"Pinch",@"filter":@"GPUImagePinchDistortionFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@2.0,@"min":@-2.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@77},
@{@"name":@"Sphere refraction",@"filter":@"GPUImageSphereRefractionFilter",@"value":@0.15,@"defaultvalue":@0.15,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@78},
@{@"name":@"Glass sphere",@"filter":@"GPUImageGlassSphereFilter",@"value":@0.15,@"defaultvalue":@0.15,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@79},
@{@"name":@"Stretch",@"filter":@"GPUImageStretchDistortionFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@80},// no value--------------------
//81-90
@{@"name":@"Dilation",@"filter":@"GPUImageRGBDilationFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@81},// COMPLEX
@{@"name":@"Erosion",@"filter":@"GPUImageRGBErosionFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@82},// COMPLEX
@{@"name":@"Opening",@"filter":@"GPUImageRGBOpeningFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@83},// COMPLEX
@{@"name":@"Closing",@"filter":@"GPUImageRGBClosingFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@84},// COMPLEX
@{@"name":@"Perlin noise",@"filter":@"GPUImagePerlinNoiseFilter",@"value":@8.0,@"defaultvalue":@8.0,@"max":@30.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@85},
@{@"name":@"Voronoi",@"filter":@"GPUImageVoronoiConsumerFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@86},// no value-------------------- COMPLEX
@{@"name":@"Mosaic",@"filter":@"GPUImageMosaicFilter",@"value":@0.025,@"defaultvalue":@0.025,@"max":@0.05,@"min":@0.002,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@87},//spcial
@{@"name":@"Local binary pattern",@"filter":@"GPUImageLocalBinaryPatternFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@5.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@88},
@{@"name":@"Dissolve blend",@"filter":@"GPUImageDissolveBlendFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@89},
@{@"name":@"Chroma Key (Green)",@"filter":@"GPUImageChromaKeyBlendFilter",@"value":@0.4,@"defaultvalue":@0.4,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@90},//COMPLEX
//91-100
@{@"name":@"Add Blend",@"filter":@"GPUImageAddBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@91},// no value-------------------- second
@{@"name":@"Divide Blend",@"filter":@"GPUImageDivideBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@92},// no value-------------------- second
@{@"name":@"Multiply Blend",@"filter":@"GPUImageMultiplyBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@93},// no value-------------------- second
@{@"name":@"Overlay Blend",@"filter":@"GPUImageOverlayBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@94},// no value-------------------- second
@{@"name":@"Lighten Blend",@"filter":@"GPUImageLightenBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@95},// no value-------------------- second
@{@"name":@"Darken Blend",@"filter":@"GPUImageDarkenBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@96},// no value-------------------- second
@{@"name":@"Color Burn Blend",@"filter":@"GPUImageColorBurnBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@0,@"min":@0,@"sliderhidden":@"YES",@"hasValue":@"NO",@"filterTypeInt":@97},// no value-------------------- second
@{@"name":@"Color dodge blend",@"filter":@"GPUImageColorDodgeBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@98},// no value-------------------- second
@{@"name":@"Linear burn blend",@"filter":@"GPUImageLinearBurnBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@99},// no value-------------------- second
@{@"name":@"Screen blend",@"filter":@"GPUImageScreenBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@100},// no value-------------------- second
//101-110
@{@"name":@"Difference blend",@"filter":@"GPUImageDifferenceBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@101},//wuvaluezhi
@{@"name":@"Subtract blend",@"filter":@"GPUImageSubtractBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@102},//wuvaluezhi
@{@"name":@"Exclusion blend",@"filter":@"GPUImageExclusionBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@103},//wuvaluezhi
@{@"name":@"Hard light blend",@"filter":@"GPUImageHardLightBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@104},//wuvaluezhi
@{@"name":@"Soft light blend",@"filter":@"GPUImageSoftLightBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@105},//wuvaluezhi
@{@"name":@"Color blend",@"filter":@"GPUImageColorBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@106},//wuvaluezhi
@{@"name":@"Hue blend",@"filter":@"GPUImageHueBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@107},//wuvaluezhi
@{@"name":@"Saturation blend",@"filter":@"GPUImageSaturationBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@108},//wuvaluezhi
@{@"name":@"Luminosity blend",@"filter":@"GPUImageLuminosityBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@109},//wuvaluezhi
@{@"name":@"Normal blend",@"filter":@"GPUImageNormalBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@110},//wuvaluezhi
//111-
@{@"name":@"Poisson blend",@"filter":@"GPUImagePoissonBlendFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@111}, //second
@{@"name":@"Opacity adjustment",@"filter":@"GPUImageOpacityFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes",@"filterTypeInt":@112},
@{@"name":@"Custom",@"filter":@"GPUImageFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@113},//wuvaluezhi
@{@"name":@"UI element",@"filter":@"GPUImageSepiaFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no",@"filterTypeInt":@114},//wuvaluezhi
]mutableCopy];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currStep = 0;
    
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
    
    toolContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, DEVICEH-167, DEVICEW, 167)];
    toolContentView.showsHorizontalScrollIndicator = NO;
    toolContentView.scrollEnabled = NO;
    [toolContentView setContentSize:CGSizeMake(DEVICEW*2, 167)];
    [self.view addSubview:toolContentView];
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 0;
        btn.frame = CGRectMake(0, 2, 70, 117);
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
        [btn setImage:IMG(@"edit_filter_more") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(presetBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [toolContentView addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMidY(btn.frame)+10, CGRectGetWidth(btn.frame), 15)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:10];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1];
        lab.text = @"预设";
        [toolContentView addSubview:lab];
    }

    horizontalTableView = [[UITableView alloc] init];
    horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    horizontalTableView.frame = CGRectMake(70, 0, DEVICEW-70, 117);
    horizontalTableView.delegate = self;
    horizontalTableView.dataSource = self;
    horizontalTableView.separatorStyle = UITableViewStylePlain;
    [toolContentView addSubview:horizontalTableView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICEW/2-100, toolContentView.frame.size.height-48, 200 , 44)];
    titleLabel.font = F(18);
    titleLabel.text = @"调整";
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = TITLECOLOR;
    [toolContentView addSubview:titleLabel];
    
    secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICEW+DEVICEW/2-100, toolContentView.frame.size.height-48, 200 , 44)];
    secondTitleLabel.font = F(18);
    secondTitleLabel.textColor = TITLECOLOR;
    secondTitleLabel.text = @"参数及保存";
    [secondTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [toolContentView addSubview:secondTitleLabel];
    
    UIButton *savebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    savebtn.frame = CGRectMake(DEVICEW+DEVICEW/2-60, toolContentView.frame.size.height-130, 60, 44);
    [savebtn setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    [savebtn setTitle:@"save" forState:UIControlStateNormal];
    [savebtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [toolContentView addSubview:savebtn];
    
    UIButton *parabtn = [UIButton buttonWithType:UIButtonTypeCustom];
    parabtn.frame = CGRectMake(DEVICEW+DEVICEW/2, toolContentView.frame.size.height-130, 60, 44);
    [parabtn setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    [parabtn setTitle:@"para" forState:UIControlStateNormal];
    [parabtn addTarget:self action:@selector(showParameterView) forControlEvents:UIControlEventTouchUpInside];
    [toolContentView addSubview:parabtn];
    
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
    
    [self.view addSubview:[CHLine lineWithFrame:CGRectMake(0, DEVICEH-50, DEVICEW, 0.5) color:LINECOLOR]];

    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEVICEW-50, DEVICEH-125, 50, 25)];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont systemFontOfSize:10];
    valueLabel.textColor = [UIColor whiteColor];
    [valueLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:valueLabel];
    
    sliderView = [[FSSliderView alloc] initWithFrame:CGRectMake(0, DEVICEH, DEVICEW, 167)];
    sliderView.delegate = self;
    [self.view addSubview:sliderView];
    
    currFilterDic = [[NSMutableDictionary alloc] init];
    filterArr = [[NSMutableArray alloc] init];
    presetFilterArr = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [videoCamera stopCameraCapture];
    
	[super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Step Action

- (void)nextDidClick:(id)sender
{
    if (currStep == 0)
    {
        currStep = 1;
        [toolContentView setContentOffset:CGPointMake(DEVICEW, 0) animated:YES];
        btnNext.hidden = YES;
    }
}

- (void)backDidClick:(id)sender
{
    if (currStep == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (currStep == 1)
    {
        currStep = 0;
        [toolContentView setContentOffset:CGPointMake(0, 0) animated:YES];
        btnNext.hidden = NO;
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom Action

- (void)presetBtnDidClick
{
    presetVC = [[FSPresetViewController alloc] init];
    presetVC.view.frame = CGRectMake(0, DEVICEH, DEVICEW, 167);
    NSArray *presetArr = [[NSUserDefaults standardUserDefaults] valueForKey:@"preset"];
    
    presetVC.arrFilterSource = presetArr;
    presetVC.delegate = self;
    [self.view addSubview:presetVC.view];

    [UIView animateWithDuration:0.2 animations:^{
        presetVC.view.frame = CGRectMake(0, DEVICEH-167, DEVICEW, 167);
    }];
}

- (void)showParameterView
{
    parameterView = [[FSParameterView alloc] initWithFrame:self.view.frame btnArray:filterArr];
    parameterView.delegate = self;
    [self.view addSubview:parameterView];
    parameterView.alpha = 0;
    parameterView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        parameterView.alpha = 1;
    }];
}

- (void)saveImage
{
    UIImageWriteToSavedPhotosAlbum(sourceImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
    }
    else
    {
        [self showSaveTips];
    }
}

- (void)showSaveTips
{
    CGFloat loadingOffsetY = DEVICEW/3*4/2-57.5;
    alertView = [[UIView alloc] initWithFrame:CGRectMake(DEVICEW/2-78.5, loadingOffsetY, 157, 115)];
    alertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    alertView.layer.cornerRadius = 10;
    alertView.clipsToBounds = YES;
    alertView.userInteractionEnabled = NO;
    [self.view addSubview:alertView];
    alertView.alpha = 0;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(26, 8, 106, 63)];
    img.image = IMG(@"complete_and_save");
    img.contentMode = UIViewContentModeCenter;
    [alertView addSubview:img];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(11, 73, 137, 21)];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = F(14);
    lab.text = @"已保存到手机相册";
    [alertView addSubview:lab];
    
    
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        alertView.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        alertView.alpha = 0;
    }];
}

#pragma mark -FSParameterViewDelegate
- (void)hideParameterView
{
    [UIView animateWithDuration:0.2 animations:^{
        parameterView.alpha = 0;
    } completion:^(BOOL finished) {
        parameterView.hidden = YES;
    }];

}

- (void)saveParametersWithName:(NSString *)str
{
    NSDictionary *dic = @{@"name":str,@"filter":sourceFilter};
    [presetFilterArr addObject:dic];

    [[NSUserDefaults standardUserDefaults ] setObject:presetFilterArr forKey:@"preset"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];

    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.frame = cell.frame;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
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
    
    [sliderView setDic:arrFilterSource[indexPath.row] tag:[indexPath row]];
    [UIView animateWithDuration:0.2 animations:^{
        sliderView.frame = CGRectMake(0, DEVICEH-167, DEVICEW, 167);
    } completion:^(BOOL finished) {
    }];
    
    [self setupFilter];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Preset Filter Delegate
- (void)adaptPresetFiltersWithArr:(NSMutableArray *)arr
{
    sourceFilter = [[NSMutableArray alloc] initWithArray:arr];
    
    for (NSDictionary *presetDic in sourceFilter) {
        NSString *classStr = [presetDic getValueForKey:@"name"];
        
        NSArray *tempArr = [NSArray arrayWithArray:arrFilterSource];
        for (NSDictionary *defaultDic in tempArr) {
            if ([classStr isEqualToString:[defaultDic getValueForKey:@"name"]]) {
                NSLog(@"%@",classStr);
                
                NSInteger index = [tempArr indexOfObject:defaultDic];
                
                NSMutableDictionary *d = [defaultDic mutableCopy];
                [d setValue:[presetDic getValueForKey:@"value"] forKey:@"value"];
                [arrFilterSource replaceObjectAtIndex:index withObject:d];
            }
        }
    }
    
    if ([sourceFilter count]!=0) {
        [currFilterDic setValue:sourceFilter forKey:@"filtertype"];
        [self updateFilterBlend];
    }
}

- (void)notAdaptPresetFilters
{
    sourceImageView.image = stillImage;
}

#pragma mark -
#pragma mark Filter adjustments

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

- (void)filterSliderTag:(NSInteger)tag senderValue:(float)senderValue
{
    
    if (tag < [arrFilterSource count]) {
        NSMutableArray *d = [[arrFilterSource objectAtIndex:tag] mutableCopy];
        [d setValue:@(senderValue) forKey:@"value"];
        [arrFilterSource replaceObjectAtIndex:tag withObject:d];
    }
    
    sourceFilter = [NSMutableArray new];
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

- (void)updateFilterFromSliderwitFilter:(GPUImageOutput <GPUImageInput>*)filter filterStr:(NSString*)str sliderValue:(float)slidervalue;
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


@end
