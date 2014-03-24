//
//  UIImage+ASCII.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/23/14.
//
//

#import "UIImage+ASCII.h"

@implementation UIImage (ASCII)

static const NSString * UIImageViewASCII_CharacterMap = @" .,;_-`*";

// http://weakreference.wordpress.com/2010/11/17/ios-creating-an-ascii-art-from-uiimage
- (UIImage *)asciiImage:(UIFont *)font
                 color:(UIColor *)color
{
    return [UIImage imageFromText:[self asciiText]
                             font:font
                            color:color];
}

- (NSString *)asciiText
{
    NSInteger screenWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    UIImage *scaledImage = [UIImage imageWithImage:self scaledToWidth:(screenWidth / 10)];
    NSInteger imgWidth = scaledImage.size.width;
    NSInteger imgHeight = scaledImage.size.height;
    NSMutableString * resultString = [[NSMutableString alloc] initWithCapacity:(imgWidth + 1) * imgHeight];
    for (int i = 0; i < imgHeight; i++) {
        NSString *line = [UIImage getRGBAsFromImage:scaledImage atX:0 andY:i count:imgWidth];
        [resultString appendString:line];
        [resultString appendString:@"\n"];
    }
    return resultString;
}

# pragma mark Implementation Details

+ (NSString *)getRGBAsFromImage:(UIImage*)image atX:(NSInteger)xx andY:(NSInteger)yy count:(NSInteger)count
{
    // get the image into a data buffer
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
    
    // rawData contains the image data in the RGBA8888 pixel format
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
+ (UIImage *)imageFromText:(NSString *)text font:(UIFont *)font color:(UIColor *)color
{
    // set the font type and size
    CGSize size = [text sizeWithAttributes:@{ NSFontAttributeName: font }];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    // add a shadow, to avoid clipping the shadow you should make the context size bigger
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
    
    // draw in context, you can use also drawInRect:withFont:
    [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:@{
        NSFontAttributeName: font,
        NSForegroundColorAttributeName: color
    }];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// http://stackoverflow.com/questions/7645454/resize-uiimage-by-keeping-aspect-ratio-and-width
+ (UIImage *)imageWithImage:(UIImage*)image scaledToWidth:(CGFloat)width
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
