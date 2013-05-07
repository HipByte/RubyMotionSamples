//
//  NSString+GHMarkdownParser.h
//  GHMarkdownParser
//
//  Created by Oliver Letterer on 01.08.11.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (GHMarkdownParser)

@property (nonatomic, readonly) NSString *HTMLStringFromMarkdown;
@property (nonatomic, readonly) NSString *flavoredHTMLStringFromMarkdown;

@end
