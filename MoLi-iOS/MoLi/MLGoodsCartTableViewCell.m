//
//  MLGoodsCartTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 12/23/14.
//  Copyright (c) 2014 zoombin. All rights reserved.
//

#import "MLGoodsCartTableViewCell.h"
#import "Header.h"
#import "MLNotOnSaleLabel.h"

@interface MLGoodsCartTableViewCell () <UITextFieldDelegate>

@property (readwrite) UIButton *selectButton;
@property (readwrite) UIImageView *iconView;
@property (readwrite) UILabel *nameLabe;
@property (readwrite) UILabel *propertiesLabel;
@property (readwrite) UIButton *decreaseButton;
@property (readwrite) UIButton *increaseButton;
@property (readwrite) UILabel *priceLabel;
@property (readwrite) UILabel *storageLabel;
@property (readwrite) UITextField *quantityTextField;
@property (readwrite) MLNotOnSaleLabel *notOnSaleLabel;

@end

@implementation MLGoodsCartTableViewCell

+ (CGFloat)height {
	return 124;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(22, 10, 5, 10);
		CGRect rect = CGRectZero;
		
		UIImage *selectImage = [UIImage imageNamed:@"GoodsUnselected"];
		UIImage *selectedImage = [UIImage imageNamed:@"GoodsSelected"];
		rect.size = selectImage.size;
        rect.size.width = rect.size.width+10;
        rect.size.height = rect.size.height+60;
		rect.origin.x = self.indentationWidth;
		rect.origin.y = ([[self class] height] - selectImage.size.height-60 ) / 2;
		_selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_selectButton.frame = rect;
		[_selectButton setImage:selectImage forState:UIControlStateNormal];
		[_selectButton setImage:selectedImage forState:UIControlStateSelected];
		[_selectButton addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_selectButton];
		
		rect.size = [MLNotOnSaleLabel size];
		rect.origin.y -= 8;
		_notOnSaleLabel = [[MLNotOnSaleLabel alloc] initWithFrame:rect];
		_notOnSaleLabel.hidden = YES;
		[self.contentView addSubview:_notOnSaleLabel];
		
		rect.origin.x = CGRectGetMaxX(_selectButton.frame);
		rect.origin.y = edgeInsets.top;
		rect.size.width = 78;
		rect.size.height = rect.size.width;
		_iconView = [[UIImageView alloc] initWithFrame:rect];
		_iconView.layer.borderWidth = 0.5;
		_iconView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		[self.contentView addSubview:_iconView];
		
		CGFloat widthForPriceLabel = 70;
		
		rect.origin.x = CGRectGetMaxX(_iconView.frame) + edgeInsets.right;
		rect.size.width = fullWidth - rect.origin.x - widthForPriceLabel;
		rect.size.height = 40;
		_nameLabe = [[UILabel alloc] initWithFrame:rect];
		_nameLabe.numberOfLines = 0;
		_nameLabe.font = [UIFont systemFontOfSize:15];
		_nameLabe.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:_nameLabe];
		
		rect.origin.y = CGRectGetMaxY(_nameLabe.frame);
		_propertiesLabel = [[UILabel alloc] initWithFrame:rect];
		_propertiesLabel.numberOfLines = 0;
		_propertiesLabel.font = [UIFont systemFontOfSize:13];
		_propertiesLabel.textColor = [UIColor fontGrayColor];
		[self.contentView addSubview:_propertiesLabel];
		
		rect.origin.y = CGRectGetMinY(_nameLabe.frame);
		rect.size.width = 32;
		rect.size.height = rect.size.width;
		_decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_decreaseButton.frame = rect;
		[_decreaseButton setTitle:@"－" forState:UIControlStateNormal];
		_decreaseButton.backgroundColor = [UIColor borderGrayColor];
		[_decreaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_decreaseButton.layer.borderWidth = 0.5;
		_decreaseButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		[_decreaseButton addTarget:self action:@selector(decrease) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_decreaseButton];
		
		rect.origin.x = CGRectGetMaxX(_decreaseButton.frame);
		rect.size.width = 48;
		rect.size.height = CGRectGetHeight(_decreaseButton.frame);
		_quantityTextField = [[UITextField alloc] initWithFrame:rect];
		_quantityTextField.frame = rect;
		_quantityTextField.textAlignment = NSTextAlignmentCenter;
		_quantityTextField.textColor = [UIColor lightGrayColor];
		_quantityTextField.layer.borderWidth = 0.5;
		_quantityTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		_quantityTextField.keyboardType = UIKeyboardTypeNumberPad;
		_quantityTextField.delegate = self;
		_quantityTextField.adjustsFontSizeToFitWidth = YES;
		[self.contentView addSubview:_quantityTextField];
		
		rect.origin.x = CGRectGetMaxX(_quantityTextField.frame);
		rect.size.width = CGRectGetWidth(_decreaseButton.frame);
		_increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_increaseButton.frame = rect;
		[_increaseButton setTitle:@"+" forState:UIControlStateNormal];
		_increaseButton.backgroundColor = [UIColor borderGrayColor];
		[_increaseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_increaseButton.layer.borderWidth = 0.5;
		_increaseButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		[_increaseButton addTarget:self action:@selector(increase) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_increaseButton];
		
		rect.size.width = widthForPriceLabel;
		rect.size.height = 60;
		rect.origin.x = fullWidth - edgeInsets.right - widthForPriceLabel;
		rect.origin.y -= 8;
		_priceLabel = [[UILabel alloc] initWithFrame:rect];
		_priceLabel.numberOfLines = 0;
		_priceLabel.textAlignment = NSTextAlignmentRight;
		_priceLabel.adjustsFontSizeToFitWidth = YES;
		[self.contentView addSubview:_priceLabel];
		
		rect.origin.y = CGRectGetMaxY(_priceLabel.frame);
		_storageLabel = [[UILabel alloc] initWithFrame:rect];
		_storageLabel.text = @"库存不足";
		_storageLabel.textColor = [UIColor redColor];
		_storageLabel.font = [UIFont systemFontOfSize:13];
		_storageLabel.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:_storageLabel];
		
		_decreaseButton.hidden = YES;
		_increaseButton.hidden = YES;
		_quantityTextField.hidden = YES;
		_storageLabel.hidden = YES;
	}
	return self;
}

- (void)setGoods:(MLGoods *)goods {
	_goods = goods;
	if (_goods) {
		_selectButton.selected = _goods.selectedInCart;
		[_iconView setImageWithURL:[NSURL URLWithString:_goods.imagePath] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
		_nameLabe.text = _goods.name;
		_propertiesLabel.text = _goods.displayGoodsPropertiesInCart;
		_quantityTextField.text = [NSString stringWithFormat:@"%@", _goods.quantityInCart];
		_priceLabel.text = [NSString stringWithFormat:@"¥%0.2f\nx%@", [_goods.price floatValue], _goods.quantityInCart];
		
		if (_goods.hasStorage) {
			_storageLabel.hidden = _goods.hasStorage.boolValue;
		} else {
			_storageLabel.hidden = YES;
		}
		if (!_storageLabel.hidden) {
			_selectButton.hidden = YES;
		}
	}
}

- (void)setEditMode:(BOOL)editMode {
	_editMode = editMode;
	if (_editMode) {
		_selectButton.hidden = NO;
	}

	if (!_editMode && !_goods.isOnSale.boolValue) {
		_selectButton.hidden = YES;
		_notOnSaleLabel.hidden = NO;
	}
	_decreaseButton.hidden = !_editMode;
	_increaseButton.hidden = !_editMode;
	_quantityTextField.hidden = !_editMode;
	_nameLabe.hidden = _editMode;
}

- (void)tapped {
	if (_delegate) {
		if (_goods.selectedInCart) {
			[_delegate willDeselectGoods:_goods inCartStore:_cartStore];
		} else {
			[_delegate willSelectGoods:_goods inCartStore:_cartStore];
		}
	}
}

- (void)decrease {
	if (_delegate) {
		[_delegate willDecreaseQuantityOfGoods:_goods];
	}
}

- (void)increase {
	if (_delegate) {
		[_delegate willIncreaseQuantityOfGoods:_goods];
	}
}

- (void)prepareForReuse {
	[super prepareForReuse];
	_selectButton.selected = NO;
	_iconView.image = nil;
	_nameLabe.text = nil;
	_propertiesLabel.text = nil;
	_quantityTextField.text = nil;
	_priceLabel.text = nil;
	_storageLabel.text = nil;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	NSInteger number = [textField.text integerValue];
	if (_delegate) {
		[_delegate didEndEditingGoods:_goods quantity:number inTextField:_quantityTextField];
	}
}

@end
