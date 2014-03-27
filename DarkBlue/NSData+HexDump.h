//
//  NSData+hex.h
//  DarkBlue
//
//  Created by chenee on 14-3-27.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HexDump)
- (NSString *)hexval;
- (NSString *)hexdump;
@end