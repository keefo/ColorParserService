//
//  NSColor+LXExtension.m
//  iYY
//
//  Created by liam on 10-07-01.
//  Copyright 2010 Beyondcow. All rights reserved.
//

#import "NSColor+LXExtension.h"

@implementation NSColor (LXExtension)

+ (NSColor *)colorFromHexRGB:(NSString *)inColorString withAlpha:(float)a
{
	NSColor *result = nil;
	unsigned int colorCode = 0;
	unsigned char redByte, greenByte, blueByte;
	
	if (nil != inColorString)
	{
		NSScanner *scanner = [NSScanner scannerWithString:inColorString];
		(void) [scanner scanHexInt:&colorCode];	// ignore error
	}
	redByte		= (unsigned char) (colorCode >> 16);
	greenByte	= (unsigned char) (colorCode >> 8);
	blueByte	= (unsigned char) (colorCode);	// masks off high bits
	result = [NSColor
			  colorWithCalibratedRed:		(float)redByte	/ 0xff
			  green:(float)greenByte/ 0xff
			  blue:	(float)blueByte	/ 0xff
			  alpha:a];
	return result;
}

+ (NSColor *)colorFromHexRGB:(NSString *) inColorString
{
	return [NSColor colorFromHexRGB:inColorString withAlpha:1.0];
}

@end
