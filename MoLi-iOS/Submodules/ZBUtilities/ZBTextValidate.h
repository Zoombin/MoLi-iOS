//
//  CTTextFieldValidate.h
//  Clutter
//
//  Created by zhangbin on 7/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZBTextValidateType) {
	ZBTextValidateTypeRequired,
	ZBTextValidateTypeEmail,
	ZBTextValidateTypePassword,
	ZBTextValidateTypeUSZip,
	ZBTextValidateTypeCustom
};

@interface ZBTextValidate : NSObject

@property (nonatomic, assign) ZBTextValidateType type;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) NSString *messageTitle;
@property (nonatomic, strong) NSString *invalidMessage;

- (BOOL)isValid:(NSString *)text invalidMessage:(NSString **)invalidMessage;
- (BOOL)isValid:(NSString *)text messageTitle:(NSString **)messageTitle invalidMessage:(NSString **)invalidMessage;

+ (id)textValidateWithType:(ZBTextValidateType)type;
+ (id)textValidateWithType:(ZBTextValidateType)type invalidMessage:(NSString *)invalidMessage;

+ (NSPredicate *)defaultRequiredPredicate;
+ (NSPredicate *)defaultEmailPredicate;
+ (NSPredicate *)defaultPasswordPredicate;
+ (NSPredicate *)defaultUSZipPredicate;

@end

#pragma mark - TEST

@interface ZBTextValidate(Test)

+ (void)test;

@end
