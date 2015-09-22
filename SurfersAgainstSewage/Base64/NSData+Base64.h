//
//  NSData+Base64.h
//  iForms
//
//  Created by Dan Clarke on 22/04/2012.
//  Copyright (c) 2012 OverByThere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData_Base64 : NSObject

+ (NSString *)encodeBase64WithString:(NSString *)strData;
+ (NSString *)encodeBase64WithData:(NSData *)objData;
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;


@end
