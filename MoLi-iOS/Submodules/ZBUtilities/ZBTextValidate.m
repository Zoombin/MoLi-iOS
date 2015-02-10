//
//  CTTextFieldValidate.m
//  Clutter
//
//  Created by zhangbin on 7/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "ZBTextValidate.h"

@implementation ZBTextValidate

- (BOOL)isValid:(NSString *)text
{
	return [self isValid:text messageTitle:nil invalidMessage:nil];
}

- (BOOL)isValid:(NSString *)text invalidMessage:(NSString **)invalidMessage
{
	return [self isValid:text messageTitle:nil invalidMessage:invalidMessage];
}

- (BOOL)isValid:(NSString *)text messageTitle:(NSString **)messageTitle invalidMessage:(NSString **)invalidMessage
{
	if (invalidMessage) *invalidMessage = self.invalidMessage;
	if (messageTitle) *messageTitle = self.messageTitle;
	if (!text) return NO;
	BOOL isValid = [self.predicate evaluateWithObject:text.lowercaseString];
	if (isValid) {
		if (messageTitle) *messageTitle = nil;
		if (invalidMessage) *invalidMessage = nil;
	}
	return isValid;
}

+ (id)textValidateWithType:(ZBTextValidateType)type
{
	return [[ZBTextValidate alloc] initWithType:type predicate:nil messageTitle:nil invalidMessage:nil];
}

+ (id)textValidateWithType:(ZBTextValidateType)type invalidMessage:(NSString *)invalidMessage
{
	return [[ZBTextValidate alloc] initWithType:type predicate:nil messageTitle:nil invalidMessage:invalidMessage];
}

- (id)initWithType:(ZBTextValidateType)type predicate:(NSPredicate *)predicate messageTitle:(NSString *)messageTitle invalidMessage:(NSString *)invalidMessage
{
	self = [super init];
	if (self) {
		self.type = type;
		
		//must ranking as ZBTextValidateType enum define
		NSArray *defaultPredicates = @[	[[self class] defaultRequiredPredicate],
										[[self class] defaultEmailPredicate],
										[[self class] defaultPasswordPredicate],
										[[self class] defaultUSZipPredicate],
										[[self class] defaultRequiredPredicate] ];
		
		NSArray *defaultInvalidMessages = @[@"Can't be blank.",
											@"Invalid email.",
											@"Invalid password",
											@"Invalid Zip",
											@"Invalid input."];
		
		self.predicate = predicate ? predicate : defaultPredicates[type];
		self.invalidMessage = invalidMessage ? invalidMessage : defaultInvalidMessages[type];
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"type:%@, predicate:%@, messageTitle:%@, invalidMessage:%@", @(self.type), self.predicate, self.messageTitle, self.invalidMessage];
}

+ (NSPredicate *)defaultRequiredPredicate
{
	static NSString *reg = @"^\\S(?:.*?\\S)?$";
	return [NSPredicate predicateWithFormat:@"SELF matches %@", reg];
}

+ (NSPredicate *)defaultEmailPredicate
{
	static NSString *reg = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
												@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
												@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
												@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
												@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
												@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
												@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	return [NSPredicate predicateWithFormat:@"SELF matches %@", reg];
}

+ (NSPredicate *)defaultPasswordPredicate
{
	static NSString *reg = @"^\\S{6,}$";
	return [NSPredicate predicateWithFormat:@"SELF matches %@", reg];
}

+ (NSPredicate *)defaultUSZipPredicate
{
	static NSString *reg = @"^\\d{5}$";
	return [NSPredicate predicateWithFormat:@"SELF matches %@", reg];
}

@end

#pragma mark - TEST

@implementation ZBTextValidate(Test)

+ (void)test
{
	ZBTextValidate *validate = [ZBTextValidate textValidateWithType:ZBTextValidateTypeUSZip invalidMessage:@"invalid us zip"];
	validate.messageTitle = @"error";
	NSArray *array = @[@"12382", @"123", @"ewq321.co", @"qwe12"];
	for (NSString *text in array) {
		NSString *title = nil;
		NSString *message = nil;
		BOOL isValid = [validate isValid:text messageTitle:&title invalidMessage:&message];
		NSLog(@"%@ isValid:%@, title:%@, message:%@", text, @(isValid), title, message);
	}
}

@end
