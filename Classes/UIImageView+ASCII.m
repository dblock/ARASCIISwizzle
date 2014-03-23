//
//  UIImageView+ASCII.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/21/14.
//
//

#import "UIImageView+ASCII.h"
#import <objc/runtime.h>

static const NSString * UIImageViewASCII_CharacterMap = @" .,;_-`*";
static const NSInteger UIImageViewASCII_MinimumWidthOrHeight = 120;

@implementation UIImageView (Ascii)

static BOOL _ascii = NO;

+ (BOOL)ascii
{
    @synchronized(self) {
        return _ascii;
    }
}

+ (void)setAscii:(BOOL)value
{
    @synchronized(self) {
        if (_ascii != value) {
            _ascii = value;
            if (value) {
                [UIImageView swizzle:@selector(setImage:) forMethod:@selector(setImageASCII:)];
            } else {
                [UIImageView swizzle:@selector(setImageASCII:) forMethod:@selector(setImage:)];
            }
        }
    }
}

+ (void)swizzle:(SEL)originalSelector forMethod:(SEL)overrideSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

- (void)setImageASCII:(UIImage *)image
{
    if (image.size.width > UIImageViewASCII_MinimumWidthOrHeight || image.size.height > UIImageViewASCII_MinimumWidthOrHeight) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            UIImage *asciiImage = [self asciImageFromImage:image];
            dispatch_sync(dispatch_get_main_queue(), ^{
                // the ASCII flag may have flipped during processing
                if (UIImageView.ascii) {
                    [self setImageASCII:asciiImage];
                }
            });
        });
    } else {
        [self setImageASCII:image];
    }
}

// http://weakreference.wordpress.com/2010/11/17/ios-creating-an-ascii-art-from-uiimage/
- (UIImage*)asciImageFromImage:(UIImage*)source;
{
    NSInteger screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    source = [self imageWithImage:source scaledToWidth:(screenWidth / 10)]; // target about 32 characters wide
    NSInteger imgWidth = source.size.width;
    NSInteger imgHeight = source.size.height;
    NSMutableString * resultString = [[NSMutableString alloc] initWithCapacity:(imgWidth + 1) * imgHeight];
    for (int i = 0; i < imgHeight; i++) {
        NSString * line = [self getRGBAsFromImage:source atX:0 andY:i count:imgWidth];
        [resultString appendString:line];
        [resultString appendString:@"\n"];
    }
    return [self imageFromText:resultString size:source.size];
}

- (NSString *)getRGBAsFromImage:(UIImage*)image atX:(NSInteger)xx andY:(NSInteger)yy count:(NSInteger)count
{
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    unsigned char *stringData = malloc(count);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(
        rawData, width, height,
        bitsPerComponent, bytesPerRow, colorSpace,
        kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);

    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = (int) ((bytesPerRow * yy) + xx * bytesPerPixel);
    for (int ii = 0 ; ii < count ; ++ii)
    {
        int r = rawData[byteIndex] & 0xff;
        int g = (rawData[byteIndex] >> 8) & 0xff;
        int b = (rawData[byteIndex] >> 16) & 0xff;

        byteIndex += 4;
        NSInteger characterIndex =  7 - (((int)(r + g + b)/3) >> 5) & 0x7 ;
        stringData[ii] = [UIImageViewASCII_CharacterMap characterAtIndex:characterIndex];
    }

    free(rawData);

    return [[NSString alloc] initWithBytesNoCopy:stringData length:count encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

// http://stackoverflow.com/questions/2765537/how-do-i-use-the-nsstring-draw-functionality-to-create-a-uiimage-from-text
- (UIImage *)imageFromText:(NSString *)text size:(CGSize)imageSize
{
    // set the font type and size
    UIFont *font = [UIFont fontWithName:@"Courier New" size:12.0];
    CGSize size = [text sizeWithAttributes:@{ NSFontAttributeName: font }];

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    // add a shadow, to avoid clipping the shadow you should make the context size bigger
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);

    // draw in context, you can use also drawInRect:withFont:
    [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:@{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: self.backgroundColor == [UIColor blackColor] ? [UIColor yellowColor] : [UIColor blackColor]
    }];

    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

// http://stackoverflow.com/questions/7645454/resize-uiimage-by-keeping-aspect-ratio-and-width
- (UIImage *)imageWithImage:(UIImage*)image scaledToWidth:(CGFloat)width
{
    float oldWidth = image.size.width;
    float scaleFactor = width / oldWidth;

    float newHeight = image.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
