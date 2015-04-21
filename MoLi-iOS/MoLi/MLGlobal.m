//
//  MLGlobal.m
//  MoLi
//
//  Created by LLToo on 15/4/21.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLGlobal.h"

@implementation MLGlobal

+ (instancetype)shared; {
    static MLGlobal *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[MLGlobal alloc] init];
    });
    return _shared;
    
}

- (void)fetchGlobalData
{
    __weak __typeof(self)weakSelf = self;
    [[MLAPIClient shared] vouchertermDetailwithBlock:^(NSDictionary *attributes, MLResponse *response) {
        NSArray *array = attributes[@"content"];
        if (array) {
            NSMutableString *tempStr = [[NSMutableString alloc] init];
            for(NSString *str in array) {
                [tempStr appendFormat:@"%@\n",str];
            }
            [tempStr replaceCharactersInRange:NSMakeRange(tempStr.length-1, 1) withString:@""];
            weakSelf.voucherterm = tempStr;
        }
    }];
}

@end
