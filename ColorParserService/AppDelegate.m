//
//  AppDelegate.m
//  ColorParserService
//
//  Created by xu lian on 12-07-02.
//  Copyright (c) 2012 Beyondcow. All rights reserved.
//

#import "AppDelegate.h"
#import "RegexKitLite.h"
#import "NSColor+LXExtension.h"

@implementation AppDelegate

- (NSString*)calString:(NSString*)s
{
    NSString *str=nil;
    @try {
        NSTask *task = [[NSTask alloc] init];
        [task setLaunchPath: @"/usr/bin/bc"];
        
        NSPipe *readPipe = [NSPipe pipe];
        NSFileHandle *readHandle = [readPipe fileHandleForReading];
        
        NSPipe *writePipe = [NSPipe pipe];
        NSFileHandle *writeHandle = [writePipe fileHandleForWriting];

        [task setStandardInput: writePipe];
        [task setStandardOutput: readPipe];
        [task launch];
        
        NSString *exp=[NSString stringWithFormat:@"scale=8;%@\nquit", s];
        [writeHandle writeData:[exp dataUsingEncoding: NSASCIIStringEncoding]];
        [writeHandle closeFile];
        [task waitUntilExit];
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSData *readData;
        
        while ((readData = [readHandle availableData])
               && [readData length]) {
            [data appendData: readData];
        }
        
        str = [[NSString alloc]
               initWithData: data
               encoding: NSASCIIStringEncoding];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    return str;
}

- (void)colorWithArray:(NSArray*)array r:(float*)r g:(float*)g b:(float*)b a:(float*)alpha
{
    *r=*g=*b=*alpha=-1;
    NSString *str;
    for(str in array){
        NSString *exp=[self calString:str];
        if (exp) {
            if (*r<0) {
                *r=[exp floatValue];
            }
            else if(*g<0){
                *g=[exp floatValue];
            }
            else if(*b<0){
                *b=[exp floatValue];
            }
            else if(*alpha<0){
                *alpha=[exp floatValue];
            }
        }
    }
    if (*alpha<0) {
        *alpha=1;
    }
    else if (*alpha>1) {
        *alpha=1;
    }
}

- (void)colorWithArray:(NSArray*)array val:(float*)val alpha:(float*)alpha
{
    *val=*alpha=-1;
    NSString *str;
    for(str in array){
        NSString *exp=[self calString:str];
        if (exp) {
            if (*val<0) {
                *val=[exp floatValue];
            }
            else if(*alpha<0){
                *alpha=[exp floatValue];
            }
        }
    }
    if (*alpha<0) {
        *alpha=1;
    }
    else if (*alpha>1) {
        *alpha=1;
    }
}

- (NSColor *)parserColorString:(NSString *)s;
{
    s=[s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    @try {
        /////////////////////////////////////////////////////
        NSRange range=[s rangeOfString:@"#"];
        if (range.location!=NSNotFound) {
            //Parser Color String Format: #FFF #FFFFFF ...
            s=[s substringFromIndex:range.location+1];
            s=[s lowercaseString];
            NSString *str=@"";
            for(NSInteger i=0; i<[s length] && [str length]<6; i++){
                UniChar c=[s characterAtIndex:i];
                if ( (c>='0' && c<='9') || (c>='a' && c<='f') ) {
                    str=[str stringByAppendingFormat:@"%C",c];
                }
                else{
                    break;
                }
            }
            
            if ([str length]>2) {
                if ([str length]==3) {
                    NSString *a=[str substringWithRange:NSMakeRange(0, 1)];
                    NSString *b=[str substringWithRange:NSMakeRange(1, 1)];
                    NSString *c=[str substringWithRange:NSMakeRange(2, 1)];
                    str=[NSString stringWithFormat:@"%@%@%@%@%@%@", a, a, b, b, c, c];
                }
                NSColor *color=[NSColor colorFromHexRGB:str];
                if(color) return color;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
        
    @try {
        /////////////////////////////////////////////////////
        if([s length]<=6){
            //Parser Color String Format: FFF FFFFFF ...
            s=[s lowercaseString];
            NSString *str=@"";
            for(NSInteger i=0; i<[s length] && [str length]<6; i++){
                UniChar c=[s characterAtIndex:i];
                if ( (c>='0' && c<='9') || (c>='a' && c<='f') ) {
                    str=[str stringByAppendingFormat:@"%C",c];
                }
                else{
                    break;
                }
            }
            if ([str length]>2) {
                if ([str length]==3) {
                    NSString *a=[str substringWithRange:NSMakeRange(0, 1)];
                    NSString *b=[str substringWithRange:NSMakeRange(1, 1)];
                    NSString *c=[str substringWithRange:NSMakeRange(2, 1)];
                    str=[NSString stringWithFormat:@"%@%@%@%@%@%@", a, a, b, b, c, c];
                }
                NSColor *color=[NSColor colorFromHexRGB:str];
                if(color) return color;
            }  
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
   
    @try {
        /////////////////////////////////////////////////////
        if ([s rangeOfString:@","].location!=NSNotFound) {
            //Parser Color String Format: 157/255.0, 170/255.0, 197/255.0, 1.0,
            NSArray *sep=[s componentsSeparatedByString:@","];
            NSMutableArray *array=[NSMutableArray array];
            NSString *a=nil;
            for(a in sep){
                a=[a stringByReplacingOccurrencesOfRegex:@"\\s" withString:@""];
                if ([a length]>0) {
                    [array addObject:a];
                }
            }
            if ([array count]>=3) {
                float r=-1,g=-1,b=-1,alpha=-1;
                [self colorWithArray:array r:&r g:&g b:&b a:&alpha];
                if (r>=0 && b>=0 && g>=0) {
                    NSColor *color=[NSColor colorWithDeviceRed:r green:g blue:b alpha:alpha];
                    if (color) return color;
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    @try {
        /////////////////////////////////////////////////////
        if ([s rangeOfString:@":"].location!=NSNotFound && [s rangeOfString:@" "].location!=NSNotFound) {
            //Parser Color String Format:  colorWithDeviceRed:1.0 green:0.7 blue:7.0 alpha:1.0
            s=[s lowercaseString];
            NSArray *sep=[s componentsSeparatedByString:@" "];
            NSMutableArray *array=[NSMutableArray array];
            NSString *a=nil;
            for(a in sep){
                if ([a rangeOfString:@":"].location!=NSNotFound) {
                    a=[a stringByReplacingOccurrencesOfRegex:@"\\s" withString:@""];
                    NSArray *two=[a componentsSeparatedByString:@":"];
                    if ([two count]==2) {
                        a=[two lastObject];
                        a=[a stringByReplacingOccurrencesOfRegex:@"[\\[\\]\\s]" withString:@""];
                        [array addObject:a];
                    }                    
                }
            }
            
            if ([array count]>=3) {
                
                if ([s rangeOfString:@"tedred"].location!=NSNotFound) {
                    for(a in array){
                        float r=-1,g=-1,b=-1,alpha=-1;
                        [self colorWithArray:array r:&r g:&g b:&b a:&alpha];
                        if (r>=0 && b>=0 && g>=0) {
                            NSColor *color=[NSColor colorWithCalibratedRed:r green:g blue:b alpha:alpha];
                            if (color) return color;
                        }
                    }
                }
                
                if ([s rangeOfString:@"icered"].location!=NSNotFound) {
                    for(a in array){
                        float r=-1,g=-1,b=-1,alpha=-1;
                        [self colorWithArray:array r:&r g:&g b:&b a:&alpha];
                        if (r>=0 && b>=0 && g>=0) {
                            NSColor *color=[NSColor colorWithDeviceRed:r green:g blue:b alpha:alpha];
                            if (color) return color;
                        }
                    }
                }
                
                if ([s rangeOfString:@"tedhue"].location!=NSNotFound) {
                    for(a in array){
                        float r=-1,g=-1,b=-1,alpha=-1;
                        [self colorWithArray:array r:&r g:&g b:&b a:&alpha];
                        if (r>=0 && b>=0 && g>=0) {
                            NSColor *color=[NSColor colorWithCalibratedHue:r saturation:g brightness:g alpha:alpha];
                            if (color) return color;
                        }
                    }
                }
                
                if ([s rangeOfString:@"icehue"].location!=NSNotFound) {
                    for(a in array){
                        float r=-1,g=-1,b=-1,alpha=-1;
                        [self colorWithArray:array r:&r g:&g b:&b a:&alpha];
                        if (r>=0 && b>=0 && g>=0) {
                            NSColor *color=[NSColor colorWithDeviceHue:r saturation:g brightness:g alpha:alpha];
                            if (color) return color;
                        }
                    }
                }
                
                if ([s rangeOfString:@"rgbred"].location!=NSNotFound) {
                    for(a in array){
                        float r=-1,g=-1,b=-1,alpha=-1;
                        [self colorWithArray:array r:&r g:&g b:&b a:&alpha];
                        if (r>=0 && b>=0 && g>=0) {
                            NSColor *color=[NSColor colorWithSRGBRed:r green:g blue:b alpha:alpha];
                            if (color) return color;
                        }
                    }
                }
                
                if ([s rangeOfString:@"red"].location!=NSNotFound) {
                    for(a in array){
                        float r=-1,g=-1,b=-1,alpha=-1;
                        [self colorWithArray:array r:&r g:&g b:&b a:&alpha];
                        if (r>=0 && b>=0 && g>=0) {
                            NSColor *color=[NSColor colorWithCalibratedRed:r green:g blue:b alpha:alpha];
                            if (color) return color;
                        }
                    }
                }
                
                if ([s rangeOfString:@"hue"].location!=NSNotFound) {
                    for(a in array){
                        float r=-1,g=-1,b=-1,alpha=-1;
                        [self colorWithArray:array r:&r g:&g b:&b a:&alpha];
                        if (r>=0 && b>=0 && g>=0) {
                            NSColor *color=[NSColor colorWithCalibratedHue:r saturation:g brightness:g alpha:alpha];
                            if (color) return color;
                        }
                    }
                }
 
                for(a in array){
                    float r=-1,g=-1,b=-1,alpha=-1;
                    [self colorWithArray:array r:&r g:&g b:&b a:&alpha];
                    if (r>=0 && b>=0 && g>=0) {
                        NSColor *color=[NSColor colorWithCalibratedRed:r green:g blue:b alpha:alpha];
                        if (color) return color;
                    }
                }
                
            }
            
            
            if ([array count]>=2) {
                
                if ([s rangeOfString:@"tedwhite"].location!=NSNotFound) {
                    for(a in array){
                        float val=-1,alpha=-1;
                        [self colorWithArray:array val:&val alpha:&alpha];
                        if (val>=0 && alpha>=0) {
                            NSColor *color=[NSColor colorWithCalibratedWhite:val alpha:alpha];
                            if (color) return color;
                        }
                    }
                }
                
                if ([s rangeOfString:@"icewhite"].location!=NSNotFound) {
                    for(a in array){
                        float val=-1,alpha=-1;
                        [self colorWithArray:array val:&val alpha:&alpha];
                        if (val>=0 && alpha>=0) {
                            NSColor *color=[NSColor colorWithDeviceWhite:val alpha:alpha];
                            if (color) return color;
                        }
                    }
                }
                
                for(a in array){
                    float val=-1,alpha=-1;
                    [self colorWithArray:array val:&val alpha:&alpha];
                    if (val>=0 && alpha>=0) {
                        NSColor *color=[NSColor colorWithCalibratedWhite:val alpha:alpha];
                        if (color) return color;
                    }
                }
            }
        }

    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return nil;
}

- (void)windowWillClose:(NSNotification *)notification
{
    [NSApp terminate:self];
}

- (void)showColor:(NSColor*)c
{
    if (c) {        
        NSColorPanel *cp=[NSColorPanel sharedColorPanel];
        if (cp) {
            [cp setColor:c];
            [cp setShowsAlpha:YES];
            [cp setDelegate:self];
            [cp setHidesOnDeactivate:NO];
            [cp orderFront:self];
            [cp makeKeyWindow];
        }
        else{
            NSLog(@"no sharedColorPanel");
        }
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[NSApp setServicesProvider:self];
    
    NSColor *c=[self parserColorString:@"#FFA500"];
    if (c) {
        [self showColor:c];
    }
 
}

- (void)colorParser:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error
{
	@try
	{
		if ([pboard canReadObjectForClasses:[NSArray arrayWithObject:[NSString class]] options:[NSDictionary dictionary]])
		{
            NSArray *items = [pboard readObjectsForClasses:[NSArray arrayWithObject:[NSString class]] options:[NSDictionary dictionary]];
			for (NSString *item in items){
                NSColor *c=[self parserColorString:item];
                if (c) {
                    [self showColor:c];
                    break;
                }
			}
        }
	}
    @catch (NSException *e) {
        NSLog(@"e=%@", e);
    }
	@finally
	{
    }
}

@end
