//
//  AppDelegate.h
//  ColorParserService
//
//  Created by xu lian on 12-07-02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

- (NSColor *)parserColorString:(NSString *)s;

@end
