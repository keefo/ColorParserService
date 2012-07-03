//
//  NSColor+LXExtension.h
//  iYY
//
//  Created by liam on 10-07-01.
//  Copyright 2010 Beyondcow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (LXExtension)

+ (NSColor *)colorFromHexRGB:(NSString *)inColorString;
+ (NSColor *)colorFromHexRGB:(NSString *)inColorString withAlpha:(float)a;

@end
