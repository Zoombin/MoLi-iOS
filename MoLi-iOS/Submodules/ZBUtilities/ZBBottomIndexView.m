//
//  ZBBottomIndexScrollView.m
//  MoLi
//
//  Created by zhangbin on 12/27/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "ZBBottomIndexView.h"

static CGFloat const heightForIndex = 1.5;

@interface ZBBottomIndexView ()

@property (readwrite) UIView *indexView;
@property (readwrite) NSArray *buttons;

@end

@implementation ZBBottomIndexView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - heightForIndex, frame.size.width, heightForIndex)];
		line.backgroundColor = [UIColor colorWithRed:218/255.0f green:218/255.0f blue:218/255.0f alpha:1.0f];
		[self addSubview:line];
		
		_indexView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - heightForIndex, frame.size.width, heightForIndex)];
		[self addSubview:_indexView];
		_titleColor = [UIColor blackColor];
		_titleColorSelected = [UIColor blueColor];
		_font = [UIFont systemFontOfSize:12];
	}
	return self;
}

- (void)setIndexColor:(UIColor *)indexColor {
	_indexColor = indexColor;
	_indexView.backgroundColor = _indexColor;
}

- (void)setItems:(NSArray *)items {
	_items = items;
	if (_items.count) {
		CGFloat width = self.bounds.size.width / _items.count;
		CGRect rect = _indexView.frame;
		rect.size.width = width;
		_indexView.frame = rect;
		_indexView.hidden = _hiddenIndexView;
		CGFloat height = self.bounds.size.height - heightForIndex;
		
		rect.origin.x = 0;
		rect.origin.y = 0;
		rect.size.width = width;
		rect.size.height = height;
		NSMutableArray *array = [NSMutableArray array];
		for (int i = 0; i < _items.count; i++) {
			rect.origin.x = width * i;
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.tag = i;
			button.frame = rect;
			NSString *title = _items[i];
			[button setTitle:title forState:UIControlStateNormal];
			[button setTitleColor:_titleColor forState:UIControlStateNormal];
			button.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
			[button setTitleColor:_titleColorSelected forState:UIControlStateSelected];
			button.titleLabel.font = _font;
			[button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
			
			CGRect r = rect;
			r.origin.x = width - 0.5;
			r.origin.y = 10;
			r.size.width = 0.5;
			r.size.height = 18;
			UIView *line = [[UIView alloc] initWithFrame:r];
			line.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0f];
			[button addSubview:line];
			
			[array addObject:button];
		}
		_buttons = [NSArray arrayWithArray:array];
		[self setSelectedIndex:0];
	}
}

- (void)selected:(UIButton *)sender {
	for (UIButton *button in _buttons) {
		button.selected = NO;
	}
	[self setSelectedIndex:sender.tag];
}

- (void)setTitleColor:(UIColor *)titleColor {
	_titleColor = titleColor;
	if (_titleColor) {
		for (UIButton *button in _buttons) {
			[button setTitleColor:_titleColor forState:UIControlStateNormal];
		}
	}
}

- (void)setTitleColorSelected:(UIColor *)titleColorSelected {
	_titleColorSelected = titleColorSelected;
	if (_titleColor) {
		for (UIButton *button in _buttons) {
			[button setTitleColor:_titleColorSelected forState:UIControlStateSelected];
		}
	}
}

- (void)setFont:(UIFont *)font {
	_font = font;
	if (_font) {
		for (UIButton *button in _buttons) {
			button.titleLabel.font = font;
		}
	}
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
	if (_buttons.count < selectedIndex) {
		return;
	}
	
	for	(UIButton *button in _buttons) {
		button.selected = NO;
	}
	
	_selectedIndex = selectedIndex;
	CGRect frame = _indexView.frame;
	UIButton *button = _buttons[selectedIndex];
	button.selected = YES;
	CGFloat endX = button.frame.origin.x;
	frame.origin.x = endX;
	[UIView animateWithDuration:0.2 animations:^{
		_indexView.frame = frame;
	}];
	if (_delegate) {
		[_delegate bottomIndexViewSelected:_selectedIndex];
	}
}

- (void)setHiddenIndexView:(BOOL)hiddenIndexView {
	_hiddenIndexView = hiddenIndexView;
	_indexView.hidden = _hiddenIndexView;
}

- (void)swipe:(UISwipeGestureRecognizer *)swipe {
	NSInteger index = _selectedIndex;
	if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
		index++;
		if (index < _items.count) {
			[self setSelectedIndex:index];
		}
	} else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
		index--;
		if (index >= 0) {
			[self setSelectedIndex:index];
		}
	}
}

- (UISwipeGestureRecognizer *)leftSwipeGestureRecognizer {
	UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
	left.direction = UISwipeGestureRecognizerDirectionLeft;
	return left;
}

- (UISwipeGestureRecognizer *)rightSwipeGestureRecognizer {
	UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
	right.direction = UISwipeGestureRecognizerDirectionRight;
	return right;
}

@end
