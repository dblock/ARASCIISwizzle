//
//  UIImage+ASCII.h
//  Pods
//
//  Created by Daniel Doubrovkine on 3/23/14.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (ASCII)

/**
 *  Convert an image to ASCII.
 *
 *  @param font  ASCII font.
 *  @param color Text color.
 *
 *  @return Returns an image with the ASCII text.
 */
- (UIImage *)asciiImage:(UIFont *)font color:(UIColor *)color;

/**
 *  Convert an image to ASCII.
 *
 *  @return Returns the ASCII text.
 */
- (NSString *)asciiText;

@end
