//
//  UIImageView+ASCII.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/21/14.
//
//

#import "UIImageView+ASCII.h"
#import "UIImage+ASCII.h"
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
            UIFont *font = [UIFont fontWithName:@"Courier New" size:12.0];
            UIColor *color = self.backgroundColor == [UIColor blackColor] ? [UIColor yellowColor] : [UIColor blackColor];
            UIImage *asciiImage = [image asciiImage:font color:color];
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

@end
