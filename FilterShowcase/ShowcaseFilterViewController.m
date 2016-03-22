#import "ShowcaseFilterViewController.h"
#import <CoreImage/CoreImage.h>
#import "OutputTableViewController.h"
#import "NSDictionary+GetValue.h"



#define kCellWidth                                  140
#define kCellHeight                                 60
#define kArticleCellVerticalInnerPadding            3
#define kArticleCellHorizontalInnerPadding          6
#define kArticleTitleLabelPadding                   4
#define kRowVerticalPadding                         0
#define kRowHorizontalPadding                       0

@implementation ShowcaseFilterViewController
@synthesize faceDetector,stillImage;
@synthesize isStatic;
;

#pragma mark -
#pragma mark Initialization and teardown

- (id)initWithFilterType:(GPUImageShowcaseFilterType)newFilterType;
{
    self = [super initWithNibName:@"ShowcaseFilterViewController" bundle:nil];
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
         @{@"name":@"Unsharp mask",@"filter":@"GPUImageUnsharpMaskFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@5.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Gamma",@"filter":@"GPUImageGammaFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@3.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Tone curve",@"filter":@"GPUImageToneCurveFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Highlights and shadows",@"filter":@"GPUImageHighlightShadowFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Haze/UV",@"filter":@"GPUImageHazeFilter",@"value":@0.2,@"defaultvalue":@0.2,@"max":@0.2,@"min":@-0.2,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Chroma key",@"filter":@"",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"NO",@"hasValue":@"yes"},//notsure//filternotsure
         @{@"name":@"Histogram",@"filter":@"GPUImageHistogramFilter",@"value":@16.0,@"defaultvalue":@16.0,@"max":@32.0,@"min":@4.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Histogram Equalization",@"filter":@"GPUImageHistogramEqualizationFilter",@"value":@16.0,@"defaultvalue":@16.0,@"max":@32.0,@"min":@4.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Average color",@"filter":@"GPUImageAverageColor",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
         @{@"name":@"Luminosity",@"filter":@"GPUImageLuminosity",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
         @{@"name":@"Threshold",@"filter":@"",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"NO",@"hasValue":@"yes"},//notsure//filternotsure
         @{@"name":@"Adaptive threshold",@"filter":@"GPUImageAdaptiveThresholdFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@20.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Average luminance threshold",@"filter":@"GPUImageLuminanceThresholdFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"NO",@"hasValue":@"yes"},//notsure
         @{@"name":@"Crop",@"filter":@"GPUImageCropFilter",@"filter":@"",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.2,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Transform (2-D)",@"filter":@"GPUImageTransformFilter",@"value":@2.0,@"defaultvalue":@2.0,@"max":@6.28,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Transform (3-D)",@"filter":@"GPUImageTransformFilter",@"value":@0.75,@"defaultvalue":@0.75,@"max":@6.28,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Mask",@"filter":@"GPUImageMaskFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value
         @{@"name":@"Color invert",@"filter":@"GPUImageColorInvertFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
         @{@"name":@"Grayscale",@"filter":@"GPUImageGrayscaleFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
         @{@"name":@"Sepia tone",@"filter":@"GPUImageSepiaFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Miss Etikate (Lookup)",@"filter":@"GPUImageMissEtikateFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
         @{@"name":@"Soft elegance (Lookup)",@"filter":@"GPUImageSoftEleganceFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
         @{@"name":@"Amatorka (Lookup)",@"filter":@"GPUImageAmatorkaFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value值
         @{@"name":@"Pixellate",@"filter":@"GPUImagePixellateFilter",@"value":@0.05,@"defaultvalue":@0.05,@"max":@0.3,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Polar pixellate",@"filter":@"GPUImagePolarPixellateFilter",@"value":@0.05,@"defaultvalue":@0.05,@"max":@0.1,@"min":@-0.1,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Pixellate (position)",@"filter":@"GPUImagePixellatePositionFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@0.5,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Polka dot",@"filter":@"GPUImagePolkaDotFilter",@"value":@0.05,@"defaultvalue":@0.05,@"max":@0.0,@"min":@0.3,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Halftone",@"filter":@"GPUImageHalftoneFilter",@"value":@0.01,@"defaultvalue":@0.01,@"max":@0.05,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Crosshatch",@"filter":@"GPUImageCrosshatchFilter",@"value":@0.03,@"defaultvalue":@0.03,@"max":@0.06,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Sobel edge detection",@"filter":@"GPUImageSobelEdgeDetectionFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Prewitt edge detection",@"filter":@"GPUImagePrewittEdgeDetectionFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Canny edge detection",@"filter":@"GPUImageCannyEdgeDetectionFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Threshold edge detection",@"filter":@"GPUImageThresholdEdgeDetectionFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"XY derivative",@"filter":@"GPUImageXYDerivativeFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//无value
         @{@"name":@"Harris corner detection",@"filter":@"GPUImageHarrisCornerDetectionFilter",@"value":@0.20,@"defaultvalue":@0.20,@"max":@0.70,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Noble corner detection",@"filter":@"GPUImageNobleCornerDetectionFilter",@"value":@0.20,@"defaultvalue":@0.20,@"max":@0.70,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Shi-Tomasi feature detection",@"filter":@"GPUImageShiTomasiFeatureDetectionFilter",@"value":@0.20,@"defaultvalue":@0.20,@"max":@0.70,@"min":@0.01,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Hough transform line detection",@"filter":@"GPUImageHoughTransformLineDetector",@"value":@0.6,@"defaultvalue":@0.6,@"max":@1.0,@"min":@0.2,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Image buffer",@"filter":@"GPUImageBuffer",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Motion detector",@"filter":@"GPUImageMotionDetector",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Low pass",@"filter":@"GPUImageLowPassFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"High pass",@"filter":@"GPUImageHighPassFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Sketch",@"filter":@"GPUImageSketchFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Threshold Sketch",@"filter":@"GPUImageThresholdSketchFilter",@"value":@0.25,@"defaultvalue":@0.25,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Toon",@"filter":@"GPUImageToonFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Smooth toon",@"filter":@"GPUImageSmoothToonFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@6.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Tilt shift",@"filter":@"GPUImageTiltShiftFilter",@"value":@0.4,@"defaultvalue":@0.4,@"max":@0.6,@"min":@0.2,@"sliderhidden":@"NO",@"hasValue":@"yes"},//norsure
         @{@"name":@"CGA colorspace",@"filter":@"GPUImageCGAColorspaceFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"3x3 convolution",@"filter":@"GPUImage3x3ConvolutionFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Emboss",@"filter":@"GPUImageEmbossFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@5.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Laplacian",@"filter":@"GPUImageLaplacianFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Posterize",@"filter":@"GPUImagePosterizeFilter",@"value":@10.0,@"defaultvalue":@10.0,@"max":@20.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Swirl",@"filter":@"GPUImageSwirlFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Bulge",@"filter":@"GPUImageBulgeDistortionFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@-1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Sphere refraction",@"filter":@"GPUImageSphereRefractionFilter",@"value":@0.15,@"defaultvalue":@0.15,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Glass sphere",@"filter":@"GPUImageGlassSphereFilter",@"value":@0.15,@"defaultvalue":@0.15,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Pinch",@"filter":@"GPUImagePinchDistortionFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@2.0,@"min":@-2.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Stretch",@"filter":@"GPUImageStretchDistortionFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Dilation",@"filter":@"GPUImageRGBDilationFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Erosion",@"filter":@"GPUImageRGBErosionFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Opening",@"filter":@"GPUImageRGBOpeningFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Closing",@"filter":@"GPUImageRGBClosingFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Perlin noise",@"filter":@"GPUImagePerlinNoiseFilter",@"value":@8.0,@"defaultvalue":@8.0,@"max":@30.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Voronoi",@"filter":@"GPUImageVoronoiConsumerFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi special
         @{@"name":@"Mosaic",@"filter":@"GPUImageMosaicFilter",@"value":@0.025,@"defaultvalue":@0.025,@"max":@0.05,@"min":@0.002,@"sliderhidden":@"NO",@"hasValue":@"yes"},//spcial
         @{@"name":@"Local binary pattern",@"filter":@"GPUImageLocalBinaryPatternFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@5.0,@"min":@1.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Chroma key blend (green)",@"filter":@"",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"NO",@"hasValue":@"yes"},//notsue//filternotsure
         @{@"name":@"Dissolve blend",@"filter":@"GPUImageDissolveBlendFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Screen blend",@"filter":@"GPUImageScreenBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Color burn blend",@"filter":@"GPUImageColorBurnBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Color dodge blend",@"filter":@"GPUImageColorDodgeBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Linear burn blend",@"filter":@"GPUImageLinearBurnBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Add blend",@"filter":@"GPUImageAddBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Divide blend",@"filter":@"GPUImageDivideBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Multiply blend",@"filter":@"GPUImageMultiplyBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Overlay blend",@"filter":@"GPUImageOverlayBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Lighten blend",@"filter":@"GPUImageLightenBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Darken blend",@"filter":@"GPUImageDarkenBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Exclusion blend",@"filter":@"GPUImageExclusionBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Difference blend",@"filter":@"GPUImageDifferenceBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Subtract blend",@"filter":@"GPUImageSubtractBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Hard light blend",@"filter":@"GPUImageHardLightBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Soft light blend",@"filter":@"GPUImageSoftLightBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Color blend",@"filter":@"GPUImageColorBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Hue blend",@"filter":@"GPUImageHueBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Saturation blend",@"filter":@"GPUImageSaturationBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Luminosity blend",@"filter":@"GPUImageLuminosityBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Normal blend",@"filter":@"GPUImageNormalBlendFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Poisson blend",@"filter":@"GPUImagePoissonBlendFilter",@"value":@0.5,@"defaultvalue":@0.5,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Opacity adjustment",@"filter":@"GPUImageOpacityFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@1.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
        @{@"name":@"Kuwahara",@"filter":@"GPUImageKuwaharaFilter",@"value":@3.0,@"defaultvalue":@3.0,@"max":@8.0,@"min":@3.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Kuwahara (fixed radius)",@"filter":@"",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"NO",@"hasValue":@"yes"},//notsure//filternotsure
         @{@"name":@"Vignette",@"filter":@"GPUImageVignetteFilter",@"value":@0.75,@"defaultvalue":@0.75,@"max":@0.9,@"min":@0.5,@"sliderhidden":@"NO",@"hasValue":@"yes"},//notsure
         @{@"name":@"Gaussian blur",@"filter":@"GPUImageGaussianBlurFilter",@"value":@2.0,@"defaultvalue":@2.0,@"max":@24.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Median (3x3)",@"filter":@"GPUImageMedianFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Bilateral blur",@"filter":@"GPUImageBilateralFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@10.0,@"min":@0.0,@"sliderhidden":@"YES",@"hasValue":@"yes"},
         @{@"name":@"Motion blur",@"filter":@"GPUImageMotionBlurFilter",@"value":@0.0,@"defaultvalue":@0.0,@"max":@180.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Zoom blur",@"filter":@"GPUImageZoomBlurFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.5,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Box blur",@"filter":@"GPUImageBoxBlurFilter",@"value":@2.0,@"defaultvalue":@2.0,@"max":@24.0,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Gaussian selective blur",@"filter":@"GPUImageGaussianSelectiveBlurFilter",@"value":@(40.0/320.0),@"defaultvalue":@(40.0/320.0),@"max":@0.75,@"min":@0.0,@"sliderhidden":@"NO",@"hasValue":@"yes"},
         @{@"name":@"Gaussian (centered)",@"filter":@"",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"NO",@"hasValue":@"yes"},//notsure//filternotsure
         @{@"name":@"iOS 7 blur",@"filter":@"GPUImageiOSBlurFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"UI element",@"filter":@"GPUImageSepiaFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Custom",@"filter":@"GPUImageFilter",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"YES",@"hasValue":@"no"},//wuvaluezhi
         @{@"name":@"Filter Chain",@"filter":@"",@"value":@0,@"defaultvalue":@0,@"max":@1,@"min":@-1,@"sliderhidden":@"NO",@"hasValue":@"yes"},//notsure//filternotsure
         @{@"name":@"Filter Group",@"filter":@"",@"value":@0.05,@"defaultvalue":@0.05,@"max":@0.3,@"min":@0.0,@"sliderhidden":@"YES",@"hasValue":@"yes"},//filternotsure
         @{@"name":@"Face Detection",@"filter":@"GPUImageSaturationFilter",@"value":@1.0,@"defaultvalue":@1.0,@"max":@2.0,@"min":@0.0,@"sliderhidden":@"YES",@"hasValue":@"yes"},//notsure
         ]mutableCopy
       ];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resetFilterArray];
    
    sourceImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    sourceImageView.image = stillImage;
    [self.view addSubview:sourceImageView];
    
    if ([GPUImageContext supportsFastTextureUpload])
    {
        NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
        self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
        faceThinking = NO;
    }
    
    frame =  [[UIScreen mainScreen] bounds];
    horizontalTableView = [[UITableView alloc] init];
    horizontalTableView.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    horizontalTableView.frame = CGRectMake(0, frame.size.height-80, 320, 100);
    horizontalTableView.delegate = self;
    horizontalTableView.dataSource = self;
    [self.view addSubview:horizontalTableView];
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-50, frame.size.height-125, 50, 25)];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont systemFontOfSize:10];
    valueLabel.textColor = [UIColor whiteColor];
    [valueLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:valueLabel];
    
    sliderView = [[SliderView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 100)];
    sliderView.delegate = self;
    [self.view addSubview:sliderView];
    
    UIButton *outPutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [outPutBtn setTitle:@"pamaters" forState:UIControlStateNormal];
    [outPutBtn addTarget:self action:@selector(outputFilterParemeters) forControlEvents:UIControlEventTouchUpInside];
    outPutBtn.frame = CGRectMake(0, 0, 70, 36);
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:outPutBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    currFilterDic = [[NSMutableDictionary alloc] init];
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

- (void)outputFilterParemeters
{
    NSString *filterParameterStr;
    if (currentValue) {
        filterParameterStr = [NSString stringWithFormat:@"%@:%@",self.title,currentValue];
    } else
    {
        filterParameterStr = [NSString stringWithFormat:@"%@:%@",self.title,currentValue];
    }
    [filterArr addObject:filterParameterStr];
    
    
    
    OutputTableViewController *outputTableVC = [[OutputTableViewController alloc] initWithFilterArr:filterArr];
    [self.navigationController pushViewController:outputTableVC animated:YES];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return GPUIMAGE_NUMFILTERS;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];

    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(kArticleCellHorizontalInnerPadding, 0, kCellWidth, kCellHeight)];
    }
    cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    cell.textLabel.font = [UIFont systemFontOfSize:8];
    cell.textLabel.numberOfLines = 0;
    NSLog(@"%@",[arrFilterSource objectAtIndex:index]);
    cell.textLabel.text = [[arrFilterSource objectAtIndex:index] getValueForKey:@"name"];
    
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
//        currentValue = [NSString stringWithFormat:@"%.2f",self.filterSettingsSlider.value];
        filterParameterStr = [NSString stringWithFormat:@"%@:%@",self.title,currentValue];
    }
    [filterArr addObject:filterParameterStr];
    
    
    NSMutableArray *d = [[arrFilterSource objectAtIndex:indexPath.row] mutableCopy];
    NSString *filterStr = [NSString stringWithFormat:@"%ld",indexPath.row];
    [d setValue:filterStr forKey:@"filterTypeInt"];
    [arrFilterSource replaceObjectAtIndex:indexPath.row withObject:d];

    
    
    
    [sliderView setDic:arrFilterSource[indexPath.row] tag:[indexPath row]];
    [UIView animateWithDuration:0.1 animations:^{
        sliderView.frame = CGRectMake(0, frame.size.height-100, frame.size.width, 100);
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
    BOOL needsSecondImage = NO;
    
    NSInteger typeNumber = (NSInteger)filterType;
    
    NSDictionary *filterDic = [arrFilterSource objectAtIndex:typeNumber];
    self.title = [filterDic getValueForKey:@"name"];
    
    

//    switch (filterType)
//    {
//        case GPUIMAGE_SEPIA:
//        {
//            self.title = @"Sepia Tone";
//            
//            filter = [[GPUImageSepiaFilter alloc] init];
//        }; break;
//        case GPUIMAGE_PIXELLATE:
//        {
//            self.title = @"Pixellate";
//            
//            filter = [[GPUImagePixellateFilter alloc] init];
//        }; break;
//        case GPUIMAGE_POLARPIXELLATE:
//        {
//            self.title = @"Polar Pixellate";
//            
//            filter = [[GPUImagePolarPixellateFilter alloc] init];
//        }; break;
//        case GPUIMAGE_PIXELLATE_POSITION:
//        {
//            self.title = @"Pixellate (position)";
//            
//            filter = [[GPUImagePixellatePositionFilter alloc] init];
//        }; break;
//        case GPUIMAGE_POLKADOT:
//        {
//            self.title = @"Polka Dot";
//            
//            filter = [[GPUImagePolkaDotFilter alloc] init];
//        }; break;
//        case GPUIMAGE_HALFTONE:
//        {
//            self.title = @"Halftone";
//            
//            filter = [[GPUImageHalftoneFilter alloc] init];
//        }; break;
//        case GPUIMAGE_CROSSHATCH:
//        {
//            self.title = @"Crosshatch";
//            
//            filter = [[GPUImageCrosshatchFilter alloc] init];
//        }; break;
//        case GPUIMAGE_COLORINVERT:
//        {
//            self.title = @"Color Invert";
//            
//            filter = [[GPUImageColorInvertFilter alloc] init];
//        }; break;
//        case GPUIMAGE_GRAYSCALE:
//        {
//            self.title = @"Grayscale";
//            
//            filter = [[GPUImageGrayscaleFilter alloc] init];
//        }; break;
//        case GPUIMAGE_MONOCHROME:
//        {
//            self.title = @"Monochrome";
//            
//            filter = [[GPUImageMonochromeFilter alloc] init];
//            [(GPUImageMonochromeFilter *)filter setColor:(GPUVector4){0.0f, 0.0f, 1.0f, 1.f}];
//        }; break;
//        case GPUIMAGE_FALSECOLOR:
//        {
//            self.title = @"False Color";
//            
//            filter = [[GPUImageFalseColorFilter alloc] init];
//		}; break;
//        case GPUIMAGE_SOFTELEGANCE:
//        {
//            self.title = @"Soft Elegance (Lookup)";
//            
//            filter = [[GPUImageSoftEleganceFilter alloc] init];
//        }; break;
//        case GPUIMAGE_MISSETIKATE:
//        {
//            self.title = @"Miss Etikate (Lookup)";
//            
//            filter = [[GPUImageMissEtikateFilter alloc] init];
//        }; break;
//        case GPUIMAGE_AMATORKA:
//        {
//            self.title = @"Amatorka (Lookup)";
//            
//            filter = [[GPUImageAmatorkaFilter alloc] init];
//        }; break;
//
//        case GPUIMAGE_SATURATION:
//        {
//            self.title = @"Saturation";
//            
//            filter = [[GPUImageSaturationFilter alloc] init];
//        }; break;
//        case GPUIMAGE_CONTRAST:
//        {
//            self.title = @"Contrast";
//            
//            filter = [[GPUImageContrastFilter alloc] init];
//        }; break;
//        case GPUIMAGE_BRIGHTNESS:
//        {
//            self.title = @"Brightness";
//            
//            filter = [[GPUImageBrightnessFilter alloc] init];
//        }; break;
//        case GPUIMAGE_LEVELS:
//        {
//            self.title = @"Levels";
//            
//            filter = [[GPUImageLevelsFilter alloc] init];
//        }; break;
//        case GPUIMAGE_RGB:
//        {
//            self.title = @"RGB";
//            
//            filter = [[GPUImageRGBFilter alloc] init];
//        }; break;
//        case GPUIMAGE_HUE:
//        {
//            self.title = @"Hue";
//            
//            filter = [[GPUImageHueFilter alloc] init];
//        }; break;
//        case GPUIMAGE_WHITEBALANCE:
//        {
//            self.title = @"White Balance";
//            
//            filter = [[GPUImageWhiteBalanceFilter alloc] init];
//        }; break;
//        case GPUIMAGE_EXPOSURE:
//        {
//            self.title = @"Exposure";
//            
//            filter = [[GPUImageExposureFilter alloc] init];
//        }; break;
//        case GPUIMAGE_SHARPEN:
//        {
//            self.title = @"Sharpen";
//            
//            filter = [[GPUImageSharpenFilter alloc] init];
//        }; break;
//        case GPUIMAGE_UNSHARPMASK:
//        {
//            self.title = @"Unsharp Mask";
//            
//            filter = [[GPUImageUnsharpMaskFilter alloc] init];
//            
////            [(GPUImageUnsharpMaskFilter *)filter setIntensity:3.0];
//        }; break;
//        case GPUIMAGE_GAMMA:
//        {
//            self.title = @"Gamma";
//            
//            filter = [[GPUImageGammaFilter alloc] init];
//        }; break;
//        case GPUIMAGE_TONECURVE:
//        {
//            self.title = @"Tone curve";
//
//            filter = [[GPUImageToneCurveFilter alloc] init];
//            [(GPUImageToneCurveFilter *)filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
//        }; break;
//        case GPUIMAGE_HIGHLIGHTSHADOW:
//        {
//            self.title = @"Highlights and Shadows";
//            
//            filter = [[GPUImageHighlightShadowFilter alloc] init];
//        }; break;
//		case GPUIMAGE_HAZE:
//        {
//            self.title = @"Haze / UV";
//            
//            filter = [[GPUImageHazeFilter alloc] init];
//        }; break;
//		case GPUIMAGE_AVERAGECOLOR:
//        {
//            self.title = @"Average Color";
//            
//            filter = [[GPUImageAverageColor alloc] init];
//        }; break;
//		case GPUIMAGE_LUMINOSITY:
//        {
//            self.title = @"Luminosity";
//            
//            filter = [[GPUImageLuminosity alloc] init];
//        }; break;
//		case GPUIMAGE_HISTOGRAM:
//        {
//            self.title = @"Histogram";
//            
//            filter = [[GPUImageHistogramFilter alloc] initWithHistogramType:kGPUImageHistogramRGB];
//        }; break;
//                case GPUIMAGE_HISTOGRAM_EQUALIZATION:
//        {
//            self.title = @"Histogram Equalization";
//            
//            filter = [[GPUImageHistogramEqualizationFilter alloc] initWithHistogramType:kGPUImageHistogramLuminance];
//        }; break;
//		case GPUIMAGE_THRESHOLD:
//        {
//            self.title = @"Luminance Threshold";
//            
//            [self.filterSettingsSlider setMinimumValue:0.0];
//            [self.filterSettingsSlider setMaximumValue:1.0];
//            [self.filterSettingsSlider setValue:0.5];
//            
//            filter = [[GPUImageLuminanceThresholdFilter alloc] init];
//        }; break;
//		case GPUIMAGE_ADAPTIVETHRESHOLD:
//        {
//            self.title = @"Adaptive Threshold";
//            
//            filter = [[GPUImageAdaptiveThresholdFilter alloc] init];
//        }; break;
//		case GPUIMAGE_AVERAGELUMINANCETHRESHOLD:
//        {
//            self.title = @"Avg. Lum. Threshold";
//            
//            [self.filterSettingsSlider setMinimumValue:0.0];
//            [self.filterSettingsSlider setMaximumValue:2.0];
//            [self.filterSettingsSlider setValue:1.0];
//            
//            filter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];
//        }; break;
//        case GPUIMAGE_CROP:
//        {
//            self.title = @"Crop";
//            
//            filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 1.0, 0.25)];
//        }; break;
//		case GPUIMAGE_MASK:
//		{
//            self.title = @"Mask";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageMaskFilter alloc] init];
//			
//			[(GPUImageFilter*)filter setBackgroundColorRed:0.0 green:1.0 blue:0.0 alpha:1.0];
//        }; break;
//        case GPUIMAGE_TRANSFORM:
//        {
//            self.title = @"Transform (2-D)";
//            
//            filter = [[GPUImageTransformFilter alloc] init];
//            [(GPUImageTransformFilter *)filter setAffineTransform:CGAffineTransformMakeRotation(2.0)];
////            [(GPUImageTransformFilter *)filter setIgnoreAspectRatio:YES];
//        }; break;
//        case GPUIMAGE_TRANSFORM3D:
//        {
//            self.title = @"Transform (3-D)";
//            
//            filter = [[GPUImageTransformFilter alloc] init];
//            CATransform3D perspectiveTransform = CATransform3DIdentity;
//            perspectiveTransform.m34 = 0.4;
//            perspectiveTransform.m33 = 0.4;
//            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
//            perspectiveTransform = CATransform3DRotate(perspectiveTransform, 0.75, 0.0, 1.0, 0.0);
//            
//            [(GPUImageTransformFilter *)filter setTransform3D:perspectiveTransform];
//		}; break;
//        case GPUIMAGE_SOBELEDGEDETECTION:
//        {
//            self.title = @"Sobel Edge Detection";
//
//            filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
//        }; break;
//        case GPUIMAGE_XYGRADIENT:
//        {
//            self.title = @"XY Derivative";
//            
//            filter = [[GPUImageXYDerivativeFilter alloc] init];
//        }; break;
//        case GPUIMAGE_HARRISCORNERDETECTION:
//        {
//            self.title = @"Harris Corner Detection";
//
//            filter = [[GPUImageHarrisCornerDetectionFilter alloc] init];
//            [(GPUImageHarrisCornerDetectionFilter *)filter setThreshold:0.20];            
//        }; break;
//        case GPUIMAGE_NOBLECORNERDETECTION:
//        {
//            self.title = @"Noble Corner Detection";
//            
//            filter = [[GPUImageNobleCornerDetectionFilter alloc] init];
//            [(GPUImageNobleCornerDetectionFilter *)filter setThreshold:0.20];            
//        }; break;
//        case GPUIMAGE_SHITOMASIFEATUREDETECTION:
//        {
//            self.title = @"Shi-Tomasi Feature Detection";
//            
//            filter = [[GPUImageShiTomasiFeatureDetectionFilter alloc] init];
//            [(GPUImageShiTomasiFeatureDetectionFilter *)filter setThreshold:0.20];            
//        }; break;
//        case GPUIMAGE_HOUGHTRANSFORMLINEDETECTOR:
//        {
//            self.title = @"Line Detection";
//            
//            filter = [[GPUImageHoughTransformLineDetector alloc] init];
//            [(GPUImageHoughTransformLineDetector *)filter setLineDetectionThreshold:0.60];
//        }; break;
//
//        case GPUIMAGE_PREWITTEDGEDETECTION:
//        {
//            self.title = @"Prewitt Edge Detection";
//            
//            filter = [[GPUImagePrewittEdgeDetectionFilter alloc] init];
//        }; break;
//        case GPUIMAGE_CANNYEDGEDETECTION:
//        {
//            self.title = @"Canny Edge Detection";
//
//            filter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
//        }; break;
//        case GPUIMAGE_THRESHOLDEDGEDETECTION:
//        {
//            self.title = @"Threshold Edge Detection";
//            
//            filter = [[GPUImageThresholdEdgeDetectionFilter alloc] init];
//        }; break;
//        case GPUIMAGE_LOCALBINARYPATTERN:
//        {
//            self.title = @"Local Binary Pattern";
//            
//            filter = [[GPUImageLocalBinaryPatternFilter alloc] init];
//        }; break;
//        case GPUIMAGE_BUFFER:
//        {
//            self.title = @"Image Buffer";
//            
//            filter = [[GPUImageBuffer alloc] init];
//        }; break;
//        case GPUIMAGE_LOWPASS:
//        {
//            self.title = @"Low Pass";
//            
//            filter = [[GPUImageLowPassFilter alloc] init];
//        }; break;
//        case GPUIMAGE_HIGHPASS:
//        {
//            self.title = @"High Pass";
//            
//            filter = [[GPUImageHighPassFilter alloc] init];
//        }; break;
//        case GPUIMAGE_MOTIONDETECTOR:
//        {
//            [videoCamera rotateCamera];
//
//            self.title = @"Motion Detector";
//            
//            filter = [[GPUImageMotionDetector alloc] init];
//        }; break;
//        case GPUIMAGE_SKETCH:
//        {
//            self.title = @"Sketch";
//            
//            filter = [[GPUImageSketchFilter alloc] init];
//        }; break;
//        case GPUIMAGE_THRESHOLDSKETCH:
//        {
//            self.title = @"Threshold Sketch";
//            
//            filter = [[GPUImageThresholdSketchFilter alloc] init];
//        }; break;
//        case GPUIMAGE_TOON:
//        {
//            self.title = @"Toon";
//            
//            filter = [[GPUImageToonFilter alloc] init];
//        }; break;            
//        case GPUIMAGE_SMOOTHTOON:
//        {
//            self.title = @"Smooth Toon";
//            
//            filter = [[GPUImageSmoothToonFilter alloc] init];
//        }; break;            
//        case GPUIMAGE_TILTSHIFT:
//        {
//            self.title = @"Tilt Shift";
//            
//            filter = [[GPUImageTiltShiftFilter alloc] init];
//            [(GPUImageTiltShiftFilter *)filter setTopFocusLevel:0.4];
//            [(GPUImageTiltShiftFilter *)filter setBottomFocusLevel:0.6];
//            [(GPUImageTiltShiftFilter *)filter setFocusFallOffRate:0.2];
//        }; break;
//        case GPUIMAGE_CGA:
//        {
//            self.title = @"CGA Colorspace";
//            
//            filter = [[GPUImageCGAColorspaceFilter alloc] init];
//        }; break;
//        case GPUIMAGE_CONVOLUTION:
//        {
//            self.title = @"3x3 Convolution";
//            
//            filter = [[GPUImage3x3ConvolutionFilter alloc] init];
////            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
////                {-2.0f, -1.0f, 0.0f,@"hasValue":@"yes"},
////                {-1.0f,  1.0f, 1.0f},
////                { 0.0f,  1.0f, 2.0f}
////            }];
//            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
//                {-1.0f,  0.0f, 1.0f},
//                {-2.0f, 0.0f, 2.0f},
//                {-1.0f,  0.0f, 1.0f}
//            }];
//
////            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
////                {1.0f,  1.0f, 1.0f},
////                {1.0f, -8.0f, 1.0f},
////                {1.0f,  1.0f, 1.0f}
////            }];
////            [(GPUImage3x3ConvolutionFilter *)filter setConvolutionKernel:(GPUMatrix3x3){
////                { 0.11f,  0.11f, 0.11f},
////                { 0.11f,  0.11f, 0.11f},
////                { 0.11f,  0.11f, 0.11f}
////            }];
//        }; break;
//        case GPUIMAGE_EMBOSS:
//        {
//            self.title = @"Emboss";
//            
//            filter = [[GPUImageEmbossFilter alloc] init];
//        }; break;
//        case GPUIMAGE_LAPLACIAN:
//        {
//            self.title = @"Laplacian";
//            
//            filter = [[GPUImageLaplacianFilter alloc] init];
//        }; break;
//        case GPUIMAGE_POSTERIZE:
//        {
//            self.title = @"Posterize";
//            
//            filter = [[GPUImagePosterizeFilter alloc] init];
//        }; break;
//        case GPUIMAGE_SWIRL:
//        {
//            self.title = @"Swirl";
//            
//            filter = [[GPUImageSwirlFilter alloc] init];
//        }; break;
//        case GPUIMAGE_BULGE:
//        {
//            self.title = @"Bulge";
//            
//            filter = [[GPUImageBulgeDistortionFilter alloc] init];
//        }; break;
//        case GPUIMAGE_SPHEREREFRACTION:
//        {
//            self.title = @"Sphere Refraction";
//            
//            filter = [[GPUImageSphereRefractionFilter alloc] init];
//            [(GPUImageSphereRefractionFilter *)filter setRadius:0.15];
//        }; break;
//        case GPUIMAGE_GLASSSPHERE:
//        {
//            self.title = @"Glass Sphere";
//            
//            filter = [[GPUImageGlassSphereFilter alloc] init];
//            [(GPUImageGlassSphereFilter *)filter setRadius:0.15];
//        }; break;
//        case GPUIMAGE_PINCH:
//        {
//            self.title = @"Pinch";
//            
//            filter = [[GPUImagePinchDistortionFilter alloc] init];
//        }; break;
//        case GPUIMAGE_STRETCH:
//        {
//            self.title = @"Stretch";
//            
//            filter = [[GPUImageStretchDistortionFilter alloc] init];
//        }; break;
//        case GPUIMAGE_DILATION:
//        {
//            self.title = @"Dilation";
//            
//            filter = [[GPUImageRGBDilationFilter alloc] initWithRadius:4];
//		}; break;
//        case GPUIMAGE_EROSION:
//        {
//            self.title = @"Erosion";
//            
//            filter = [[GPUImageRGBErosionFilter alloc] initWithRadius:4];
//		}; break;
//        case GPUIMAGE_OPENING:
//        {
//            self.title = @"Opening";
//            
//            filter = [[GPUImageRGBOpeningFilter alloc] initWithRadius:4];
//		}; break;
//        case GPUIMAGE_CLOSING:
//        {
//            self.title = @"Closing";
//            
//            filter = [[GPUImageRGBClosingFilter alloc] initWithRadius:4];
//		}; break;
//
//        case GPUIMAGE_PERLINNOISE:
//        {
//            self.title = @"Perlin Noise";
//            
//            filter = [[GPUImagePerlinNoiseFilter alloc] init];
//        }; break;
//        case GPUIMAGE_VORONOI:
//        {
//            self.title = @"Voronoi";
//            needsSecondImage = YES;
//            
//            GPUImageJFAVoronoiFilter *jfa = [[GPUImageJFAVoronoiFilter alloc] init];
//            [jfa setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
//            
//            sourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"voroni_points2.png"]];
//
//            [sourcePicture addTarget:jfa];
//            
//            filter = [[GPUImageVoronoiConsumerFilter alloc] init];
//            
//            [jfa setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
//            [(GPUImageVoronoiConsumerFilter *)filter setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
//            
//            [videoCamera addTarget:filter];
//            [jfa addTarget:filter];
//            [sourcePicture processImage];
//        }; break;
//        case GPUIMAGE_MOSAIC:
//        {
//            self.title = @"Mosaic";
//            
//            filter = [[GPUImageMosaicFilter alloc] init];
//            [(GPUImageMosaicFilter *)filter setTileSet:@"squares.png"];
//            [(GPUImageMosaicFilter *)filter setColorOn:NO];
//            //[(GPUImageMosaicFilter *)filter setTileSet:@"dotletterstiles.png"];
//            //[(GPUImageMosaicFilter *)filter setTileSet:@"curvies.png"]; 
//                        
//        }; break;
//        case GPUIMAGE_CHROMAKEY:
//        {
//            self.title = @"Chroma Key (Green)";
//            needsSecondImage = YES;	
//            
//            [self.filterSettingsSlider setMinimumValue:0.0];
//            [self.filterSettingsSlider setMaximumValue:1.0];
//            [self.filterSettingsSlider setValue:0.4];
//            
//            filter = [[GPUImageChromaKeyBlendFilter alloc] init];
//            [(GPUImageChromaKeyBlendFilter *)filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
//        }; break;
//        case GPUIMAGE_CHROMAKEYNONBLEND:
//        {
//            self.title = @"Chroma Key (Green)";
//            needsSecondImage = YES;
//            
//            [self.filterSettingsSlider setMinimumValue:0.0];
//            [self.filterSettingsSlider setMaximumValue:1.0];
//            [self.filterSettingsSlider setValue:0.4];
//            
//            filter = [[GPUImageChromaKeyFilter alloc] init];
//            [(GPUImageChromaKeyFilter *)filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
//        }; break;
//        case GPUIMAGE_ADD:
//        {
//            self.title = @"Add Blend";
//            needsSecondImage = YES;
//            
//            filter = [[GPUImageAddBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_DIVIDE:
//        {
//            self.title = @"Divide Blend";
//            needsSecondImage = YES;
//            
//            filter = [[GPUImageDivideBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_MULTIPLY:
//        {
//            self.title = @"Multiply Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageMultiplyBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_OVERLAY:
//        {
//            self.title = @"Overlay Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageOverlayBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_LIGHTEN:
//        {
//            self.title = @"Lighten Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageLightenBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_DARKEN:
//        {
//            self.title = @"Darken Blend";
//            
//            needsSecondImage = YES;	
//            filter = [[GPUImageDarkenBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_DISSOLVE:
//        {
//            self.title = @"Dissolve Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageDissolveBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_SCREENBLEND:
//        {
//            self.title = @"Screen Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageScreenBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_COLORBURN:
//        {
//            self.title = @"Color Burn Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageColorBurnBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_COLORDODGE:
//        {
//            self.title = @"Color Dodge Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageColorDodgeBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_LINEARBURN:
//        {
//            self.title = @"Linear Burn Blend";
//            needsSecondImage = YES;
//            
//            filter = [[GPUImageLinearBurnBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_EXCLUSIONBLEND:
//        {
//            self.title = @"Exclusion Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageExclusionBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_DIFFERENCEBLEND:
//        {
//            self.title = @"Difference Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageDifferenceBlendFilter alloc] init];
//        }; break;
//		case GPUIMAGE_SUBTRACTBLEND:
//        {
//            self.title = @"Subtract Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageSubtractBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_HARDLIGHTBLEND:
//        {
//            self.title = @"Hard Light Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageHardLightBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_SOFTLIGHTBLEND:
//        {
//            self.title = @"Soft Light Blend";
//            needsSecondImage = YES;	
//            
//            filter = [[GPUImageSoftLightBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_COLORBLEND:
//        {
//            self.title = @"Color Blend";
//            needsSecondImage = YES;
//            
//            filter = [[GPUImageColorBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_HUEBLEND:
//        {
//            self.title = @"Hue Blend";
//            needsSecondImage = YES;
//            
//            filter = [[GPUImageHueBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_SATURATIONBLEND:
//        {
//            self.title = @"Saturation Blend";
//            needsSecondImage = YES;
//            
//            filter = [[GPUImageSaturationBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_LUMINOSITYBLEND:
//        {
//            self.title = @"Luminosity Blend";
//            needsSecondImage = YES;
//            
//            filter = [[GPUImageLuminosityBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_NORMALBLEND:
//        {
//            self.title = @"Normal Blend";
//            needsSecondImage = YES;
//            
//            filter = [[GPUImageNormalBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_POISSONBLEND:
//        {
//            self.title = @"Poisson Blend";
//            needsSecondImage = YES;
//
//            filter = [[GPUImagePoissonBlendFilter alloc] init];
//        }; break;
//        case GPUIMAGE_OPACITY:
//        {
//            self.title = @"Opacity Adjustment";
//            needsSecondImage = YES;
//            
//            filter = [[GPUImageOpacityFilter alloc] init];
//        }; break;
//        case GPUIMAGE_CUSTOM:
//        {
//            self.title = @"Custom";
//
//            filter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomFilter"];
//        }; break;
//        case GPUIMAGE_KUWAHARA:
//        {
//            self.title = @"Kuwahara";
//            
//            filter = [[GPUImageKuwaharaFilter alloc] init];
//        }; break;
//        case GPUIMAGE_KUWAHARARADIUS3:
//        {
//            self.title = @"Kuwahara (Radius 3)";
//            
//            filter = [[GPUImageKuwaharaRadius3Filter alloc] init];
//        }; break;
//        case GPUIMAGE_VIGNETTE:
//        {
//             self.title = @"Vignette";
//            
//            filter = [[GPUImageVignetteFilter alloc] init];
//        }; break;
//        case GPUIMAGE_GAUSSIAN:
//        {
//            self.title = @"Gaussian Blur";
//            
//            filter = [[GPUImageGaussianBlurFilter alloc] init];
//        }; break;
//        case GPUIMAGE_BOXBLUR:
//        {
//            self.title = @"Box Blur";
//            
//            filter = [[GPUImageBoxBlurFilter alloc] init];
//		}; break;
//        case GPUIMAGE_MEDIAN:
//        {
//            self.title = @"Median";
//            
//            filter = [[GPUImageMedianFilter alloc] init];
//		}; break;
//        case GPUIMAGE_MOTIONBLUR:
//        {
//            self.title = @"Motion Blur";
//            
//            filter = [[GPUImageMotionBlurFilter alloc] init];
//        }; break;
//        case GPUIMAGE_ZOOMBLUR:
//        {
//            self.title = @"Zoom Blur";
//            
//            filter = [[GPUImageZoomBlurFilter alloc] init];
//        }; break;
//        case GPUIMAGE_IOSBLUR:
//        {
//            self.title = @"iOS 7 Blur";
//            
//            filter = [[GPUImageiOSBlurFilter alloc] init];
//        }; break;
//        case GPUIMAGE_UIELEMENT:
//        {
//            self.title = @"UI Element";
//            
//            filter = [[GPUImageSepiaFilter alloc] init];
//		}; break;
//        case GPUIMAGE_GAUSSIAN_SELECTIVE:
//        {
//            self.title = @"Selective Blur";
//            
//            filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
//            [(GPUImageGaussianSelectiveBlurFilter*)filter setExcludeCircleRadius:40.0/320.0];
//        }; break;
//        case GPUIMAGE_GAUSSIAN_POSITION:
//        {
//            self.title = @"Selective Blur";
//            
//            [self.filterSettingsSlider setMinimumValue:0.0];
//            [self.filterSettingsSlider setMaximumValue:.75f];
//            [self.filterSettingsSlider setValue:40.0/320.0];
//            
//            filter = [[GPUImageGaussianBlurPositionFilter alloc] init];
//            [(GPUImageGaussianBlurPositionFilter*)filter setBlurRadius:40.0/320.0];
//        }; break;
//        case GPUIMAGE_BILATERAL:
//        {
//            self.title = @"Bilateral Blur";
//            
//            filter = [[GPUImageBilateralFilter alloc] init];
//        }; break;
//        case GPUIMAGE_FILTERGROUP:
//        {
//            self.title = @"Filter Group";
//            
//            filter = [[GPUImageFilterGroup alloc] init];
//            
//            GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
//            [(GPUImageFilterGroup *)filter addFilter:sepiaFilter];
//
//            GPUImagePixellateFilter *pixellateFilter = [[GPUImagePixellateFilter alloc] init];
//            [(GPUImageFilterGroup *)filter addFilter:pixellateFilter];
//            
//            [sepiaFilter addTarget:pixellateFilter];
//            [(GPUImageFilterGroup *)filter setInitialFilters:[NSArray arrayWithObject:sepiaFilter]];
//            [(GPUImageFilterGroup *)filter setTerminalFilter:pixellateFilter];
//        }; break;
//
//        case GPUIMAGE_FACES:
//        {
//            facesSwitch.hidden = NO;
//            facesLabel.hidden = NO;
//
//            [videoCamera rotateCamera];
//            self.title = @"Face Detection";
//            
//            filter = [[GPUImageSaturationFilter alloc] init];
//            [videoCamera setDelegate:self];
//            break;
//        }
//            
//        default: filter = [[GPUImageSepiaFilter alloc] init]; break;
//    }
    
    
//    valueLabel.text = [NSString stringWithFormat:@"%.2f",self.filterSettingsSlider.value];
  
    if (arrayTemp == nil) {
        arrayTemp = [[NSMutableArray alloc]init];
    }
    
    if (filterArr == nil) {
        filterArr = [[NSMutableArray alloc] init];
    }
    
//    pipeline = [[GPUImageFilterPipeline alloc]initWithOrderedFilters:arrayTemp input:staticPicture output:(GPUImageView*)self.view];
    

    
    
    
    
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
        GPUImageView *filterView = (GPUImageView *)self.view;
        
//        if (needsSecondImage)
//        {
//			UIImage *inputImage;
//			
//			if (filterType == GPUIMAGE_MASK) 
//			{
//				inputImage = [UIImage imageNamed:@"mask"];
//			}
//            /*
//			else if (filterType == GPUIMAGE_VORONOI) {
//                inputImage = [UIImage imageNamed:@"voroni_points.png"];
//            }*/
//            else {
//				// The picture is only used for two-image blend filters
//				inputImage = [UIImage imageNamed:@"WID-small.jpg"];
//			}
//			
////            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:NO];
//            sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
//            [sourcePicture processImage];
//            [sourcePicture addTarget:filter];
//        }
//
        
//        if (filterType == GPUIMAGE_HISTOGRAM)
//        {
//            // I'm adding an intermediary filter because glReadPixels() requires something to be rendered for its glReadPixels() operation to work
//            [videoCamera removeTarget:filter];
//            GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
//            [videoCamera addTarget:gammaFilter];
//            [gammaFilter addTarget:filter];
//
//            GPUImageHistogramGenerator *histogramGraph = [[GPUImageHistogramGenerator alloc] init];
//            
//            [histogramGraph forceProcessingAtSize:CGSizeMake(256.0, 330.0)];
//            [filter addTarget:histogramGraph];
//            
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            blendFilter.mix = 0.75;            
//            [blendFilter forceProcessingAtSize:CGSizeMake(256.0, 330.0)];
//            
//            [videoCamera addTarget:blendFilter];
//            [histogramGraph addTarget:blendFilter];
//
//            [blendFilter addTarget:filterView];
//        }
//        else if ( (filterType == GPUIMAGE_HARRISCORNERDETECTION) || (filterType == GPUIMAGE_NOBLECORNERDETECTION) || (filterType == GPUIMAGE_SHITOMASIFEATUREDETECTION) )
//        {
//            GPUImageCrosshairGenerator *crosshairGenerator = [[GPUImageCrosshairGenerator alloc] init];
//            crosshairGenerator.crosshairWidth = 15.0;
//            [crosshairGenerator forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
//            
//            [(GPUImageHarrisCornerDetectionFilter *)filter setCornersDetectedBlock:^(GLfloat* cornerArray, NSUInteger cornersDetected, CMTime frameTime) {
//                [crosshairGenerator renderCrosshairsFromArray:cornerArray count:cornersDetected frameTime:frameTime];
//            }];
//
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            [blendFilter forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
//            GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
//            [videoCamera addTarget:gammaFilter];
//            [gammaFilter addTarget:blendFilter];
//
//            [crosshairGenerator addTarget:blendFilter];
//
//            [blendFilter addTarget:filterView];
//        }
//        else if (filterType == GPUIMAGE_HOUGHTRANSFORMLINEDETECTOR)
//        {
//            GPUImageLineGenerator *lineGenerator = [[GPUImageLineGenerator alloc] init];
////            lineGenerator.crosshairWidth = 15.0;
//            [lineGenerator forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
//            [lineGenerator setLineColorRed:1.0 green:0.0 blue:0.0];
//            [(GPUImageHoughTransformLineDetector *)filter setLinesDetectedBlock:^(GLfloat* lineArray, NSUInteger linesDetected, CMTime frameTime){
//                [lineGenerator renderLinesFromArray:lineArray count:linesDetected frameTime:frameTime];
//            }];
//            
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            [blendFilter forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
//            GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
//            [videoCamera addTarget:gammaFilter];
//            [gammaFilter addTarget:blendFilter];
//            
//            [lineGenerator addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//        }
//        else if (filterType == GPUIMAGE_UIELEMENT)
//        {
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            blendFilter.mix = 1.0;
//            
//            NSDate *startTime = [NSDate date];
//            
//            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0f, 320.0f)];
//            timeLabel.font = [UIFont systemFontOfSize:17.0f];
//            timeLabel.text = @"Time: 0.0 s";
//            timeLabel.textAlignment = UITextAlignmentCenter;
//            timeLabel.backgroundColor = [UIColor clearColor];
//            timeLabel.textColor = [UIColor whiteColor];
//
//            uiElementInput = [[GPUImageUIElement alloc] initWithView:timeLabel];
//            
//            [filter addTarget:blendFilter];
//            [uiElementInput addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//
//            __unsafe_unretained GPUImageUIElement *weakUIElementInput = uiElementInput;
//            
//            [filter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime){
//                timeLabel.text = [NSString stringWithFormat:@"Time: %f s", -[startTime timeIntervalSinceNow]];
//                [weakUIElementInput update];
//            }];
//        }
//        else if (filterType == GPUIMAGE_BUFFER)
//        {
//            GPUImageDifferenceBlendFilter *blendFilter = [[GPUImageDifferenceBlendFilter alloc] init];
//
//            [videoCamera removeTarget:filter];
//
//            GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
//            [videoCamera addTarget:gammaFilter];
//            [gammaFilter addTarget:blendFilter];
//            [videoCamera addTarget:filter];
//
//            [filter addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//        }
//        else if ( (filterType == GPUIMAGE_OPACITY) || (filterType == GPUIMAGE_CHROMAKEYNONBLEND) )
//        {
//            [sourcePicture removeTarget:filter];
//            [videoCamera removeTarget:filter];
//            [videoCamera addTarget:filter];
//            
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            blendFilter.mix = 1.0;
//            [sourcePicture addTarget:blendFilter];
//            [filter addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//        }
//        else if ( (filterType == GPUIMAGE_SPHEREREFRACTION) || (filterType == GPUIMAGE_GLASSSPHERE) )
//        {
//            // Provide a blurred image for a cool-looking background
//            GPUImageGaussianBlurFilter *gaussianBlur = [[GPUImageGaussianBlurFilter alloc] init];
//            [videoCamera addTarget:gaussianBlur];
//            gaussianBlur.blurRadiusInPixels = 5.0;
//
//            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
//            blendFilter.mix = 1.0;
//            [gaussianBlur addTarget:blendFilter];
//            [filter addTarget:blendFilter];
//            
//            [blendFilter addTarget:filterView];
//
//        }
//        else if (filterType == GPUIMAGE_AVERAGECOLOR)
//        {
//            GPUImageSolidColorGenerator *colorGenerator = [[GPUImageSolidColorGenerator alloc] init];
//            [colorGenerator forceProcessingAtSize:[filterView sizeInPixels]];
//            
//            [(GPUImageAverageColor *)filter setColorAverageProcessingFinishedBlock:^(CGFloat redComponent, CGFloat greenComponent, CGFloat blueComponent, CGFloat alphaComponent, CMTime frameTime) {
//                [colorGenerator setColorRed:redComponent green:greenComponent blue:blueComponent alpha:alphaComponent];
////                NSLog(@"Average color: %f, %f, %f, %f", redComponent, greenComponent, blueComponent, alphaComponent);
//            }];
//            
//            [colorGenerator addTarget:filterView];
//        }
//        else if (filterType == GPUIMAGE_LUMINOSITY)
//        {
//            GPUImageSolidColorGenerator *colorGenerator = [[GPUImageSolidColorGenerator alloc] init];
//            [colorGenerator forceProcessingAtSize:[filterView sizeInPixels]];
//            
//            [(GPUImageLuminosity *)filter setLuminosityProcessingFinishedBlock:^(CGFloat luminosity, CMTime frameTime) {
//                [colorGenerator setColorRed:luminosity green:luminosity blue:luminosity alpha:1.0];
//            }];
//            
//            [colorGenerator addTarget:filterView];
//        }
//        else if (filterType == GPUIMAGE_IOSBLUR)
//        {
//            [videoCamera removeAllTargets];
//            [videoCamera addTarget:filterView];
//            GPUImageCropFilter *cropFilter = [[GPUImageCropFilter alloc] init];
//            cropFilter.cropRegion = CGRectMake(0.0, 0.5, 1.0, 0.5);
//            [videoCamera addTarget:cropFilter];
//            [cropFilter addTarget:filter];
//            
//            CGRect currentViewFrame = filterView.bounds;
//            GPUImageView *blurOverlayView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, round(currentViewFrame.size.height / 2.0), currentViewFrame.size.width, currentViewFrame.size.height - round(currentViewFrame.size.height / 2.0))];
//            [filterView addSubview:blurOverlayView];
//            [filter addTarget:blurOverlayView];
//        }
//        else if (filterType == GPUIMAGE_MOTIONDETECTOR)
//        {
//            faceView = [[UIView alloc] initWithFrame:CGRectMake(100.0, 100.0, 100.0, 100.0)];
//            faceView.layer.borderWidth = 1;
//            faceView.layer.borderColor = [[UIColor redColor] CGColor];
//            [self.view addSubview:faceView];
//            faceView.hidden = YES;
//            
//            __unsafe_unretained ShowcaseFilterViewController * weakSelf = self;
//            [(GPUImageMotionDetector *) filter setMotionDetectionBlock:^(CGPoint motionCentroid, CGFloat motionIntensity, CMTime frameTime) {
//                if (motionIntensity > 0.01)
//                {
//                    CGFloat motionBoxWidth = 1500.0 * motionIntensity;
//                    CGSize viewBounds = weakSelf.view.bounds.size;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        weakSelf->faceView.frame = CGRectMake(round(viewBounds.width * motionCentroid.x - motionBoxWidth / 2.0), round(viewBounds.height * motionCentroid.y - motionBoxWidth / 2.0), motionBoxWidth, motionBoxWidth);
//                        weakSelf->faceView.hidden = NO;
//                    });
//                    
//                }
//                else
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        weakSelf->faceView.hidden = YES;
//                    });
//                }
//                
//            }];
//            
//            [videoCamera addTarget:filterView];
//        }
//        else
//        {
//            [filter addTarget:filterView];
//        }
    }
//    [staticPicture processImage];
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
        case GPUIMAGE_CHROMAKEY: [(GPUImageChromaKeyBlendFilter *)filter setThresholdSensitivity:slidervalue]; break;
        case GPUIMAGE_CHROMAKEYNONBLEND: [(GPUImageChromaKeyFilter *)filter setThresholdSensitivity:slidervalue]; break;
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
        case GPUIMAGE_GAUSSIAN_POSITION: [(GPUImageGaussianBlurPositionFilter *)filter setBlurRadius:slidervalue]; break;
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
