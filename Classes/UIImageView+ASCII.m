//
//  UIImageView+ASCII.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/21/14.
//
//

#import "UIImageView+ASCII.h"
#import <objc/objc-runtime.h>

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
        [self setImageASCII:[self asciImageFromImage:image]];
    } else {
        [self setImageASCII:image];
    }
}

// http://weakreference.wordpress.com/2010/11/17/ios-creating-an-ascii-art-from-uiimage/
- (UIImage*)asciImageFromImage:(UIImage*)source;
{
    source = [self imageThumbnail:source];
    NSInteger imgWidth = source.size.width;
    NSInteger imgHeight = source.size.height;
    NSMutableString * resultString = [[NSMutableString alloc] initWithCapacity:imgWidth * imgHeight];
    for (int i = 0; i < imgHeight; i++) {
        NSString * line = [self getRGBAsFromImage:source atX:0 andY:i count:imgWidth];
        [resultString appendString:line];
        [resultString appendString:@"\n"];
    }
    
    return [self imageFromText:resultString];
}

- (NSString *)getRGBAsFromImage:(UIImage*)image atX:(NSInteger)xx andY:(NSInteger)yy count:(NSInteger)count
{
    NSMutableString * characterResult = [[NSMutableString alloc] initWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
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
        int g = (rawData[byteIndex] >> 8 ) & 0xff;
        int b = (rawData[byteIndex] >> 16 ) & 0xff;
        
        byteIndex += 4;
        NSInteger characterIndex =  7 - (((int)(r+g+b)/3)>>5) & 0x7 ;
        NSRange range;
        range.location = characterIndex;
        range.length = 1;
        NSString * resultCharacter = [UIImageViewASCII_CharacterMap substringWithRange:range];
        [characterResult appendString:resultCharacter];
    }
    
    free(rawData);
    return characterResult;
}

// http://stackoverflow.com/questions/2765537/how-do-i-use-the-nsstring-draw-functionality-to-create-a-uiimage-from-text
- (UIImage *)imageFromText:(NSString *)text
{
    // set the font type and size
    UIFont *font = [UIFont fontWithName:@"Courier" size:12.0];
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

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// https://gist.github.com/djbriane/160791
- (UIImage *)imageThumbnail:(UIImage *)image {
	// Create a thumbnail version of the image for the event object.
	CGSize size = image.size;
	CGSize croppedSize;
	CGFloat ratio = 64.0;
	CGFloat offsetX = 0.0;
	CGFloat offsetY = 0.0;
	
	// check the size of the image, we want to make it
	// a square with sides the size of the smallest dimension
	if (size.width > size.height) {
		offsetX = (size.height - size.width) / 2;
		croppedSize = CGSizeMake(size.height, size.height);
	} else {
		offsetY = (size.width - size.height) / 2;
		croppedSize = CGSizeMake(size.width, size.width);
	}
	
	// Crop the image before resize
	CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
	// Done cropping
	
	// Resize the image
	CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
	
	UIGraphicsBeginImageContext(rect.size);
	[[UIImage imageWithCGImage:imageRef] drawInRect:rect];
	UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
	// Done Resizing
	
	return thumbnail;
}

@end
