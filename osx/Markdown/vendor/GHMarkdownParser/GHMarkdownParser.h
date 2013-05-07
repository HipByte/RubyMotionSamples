//
//  GHMarkdownParser.h
//  GHMarkdownParser
//
//  Created by Oliver Letterer on 01.08.11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+GHMarkdownParser.h"

@interface GHMarkdownParser : NSObject

+ (NSString *)HTMLStringFromMarkdownString:(NSString *)markdownString;
+ (NSString *)flavoredHTMLStringFromMarkdownString:(NSString *)markdownString;

@end
