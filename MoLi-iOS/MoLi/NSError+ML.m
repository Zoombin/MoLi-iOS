//
//  NSError+ML.m
//  MoLi
//
//  Created by LLToo on 15/4/23.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "NSError+ML.h"

@implementation NSError(ML)

- (NSString *)MLErrorDesc
{
    return [self.userInfo objectForKey:@"ML_ERROR_MESSAGE_IDENTIFIER"];
}

@end
