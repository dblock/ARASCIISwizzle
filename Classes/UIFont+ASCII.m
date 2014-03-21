//
//  UIFont+ASCII.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/21/14.
//
//

#import "UIFont+ASCII.h"
#import <objc/runtime.h>

@implementation UIFont (ASCII)

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
                [UIFont swizzle:@selector(fontWithName:size:) forMethod:@selector(fontWithNameASCII:size:)];
            } else {
                [UIFont swizzle:@selector(fontWithNameASCII:size:) forMethod:@selector(fontWithName:size:)];
            }
        }
    }
}

+ (void)swizzle:(SEL)originalSelector forMethod:(SEL)overrideSelector
{
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method overrideMethod = class_getClassMethod(self, overrideSelector);
    Class c = object_getClass((id) self);
    if (class_addMethod(c, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(c, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

+ (UIFont *)fontWithNameASCII:(NSString *)name size:(CGFloat)fontSize
{
    return [self fontWithNameASCII:@"Courier" size:fontSize];
}

@end
