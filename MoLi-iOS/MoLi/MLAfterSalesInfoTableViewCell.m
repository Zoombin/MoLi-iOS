//
//  MLAfterSalesInfoTableViewCell.m
//  MoLi
//
//  Created by zhangbin on 2/2/15.
//  Copyright (c) 2015 zoombin. All rights reserved.
//

#import "MLAfterSalesInfoTableViewCell.h"
#import "Header.h"
#import "MLUploadedImageView.h"

@interface MLAfterSalesInfoTableViewCell () <UITextFieldDelegate>

@property (readwrite) UIButton *returnButton;
@property (readwrite) UIButton *changeButton;
@property (readwrite) UITextField *reasonTextField;
@property (readwrite) UIButton *addPhotoButton;
@property (readwrite) NSMutableArray *uploadedImageViews;

@property (nonatomic,strong) UIView *viewReturn;
@property (nonatomic,strong) UIView *viewChange;

@end

@implementation MLAfterSalesInfoTableViewCell

+ (CGFloat)height {
	return 190;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		CGFloat fullWidth = [UIScreen mainScreen].bounds.size.width;
		UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
		CGRect rect = CGRectZero;
		rect.origin.x = edgeInsets.left;
		rect.origin.y = edgeInsets.top;
		rect.size.width = 64;
		rect.size.height = 34;
		
		UILabel *typeLabel = [[UILabel alloc] initWithFrame:rect];
		typeLabel.font = [UIFont systemFontOfSize:14];
		typeLabel.textColor = [UIColor fontGrayColor];
		NSString *string = @"*售后类型";
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
		[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor themeColor] range:NSMakeRange(0, 1)];
		typeLabel.attributedText = attributedString;
		[self.contentView addSubview:typeLabel];
        
        rect.origin.x = CGRectGetMaxX(typeLabel.frame);
		rect.size.width = fullWidth - rect.origin.x - edgeInsets.right;
        
        self.viewReturn = [self viewForType:rect title:@"我要退货" isSelected:(_type==MLAfterSalesTypeReturn?YES:NO) tag:MLAfterSalesTypeReturn];
        [self.contentView addSubview:self.viewReturn];
        
        rect.origin.y += 40;
        self.viewChange = [self viewForType:rect title:@"我要换货" isSelected:(_type==MLAfterSalesTypeChange?YES:NO) tag:MLAfterSalesTypeChange];
        [self.contentView addSubview:self.viewChange];
        
        rect.origin.y +=50;
        rect.origin.x = CGRectGetMinX(typeLabel.frame);
        rect.size.width = CGRectGetWidth(typeLabel.frame);
        UILabel *reasonLabel = [[UILabel alloc] initWithFrame:rect];
        reasonLabel.font = typeLabel.font;
        reasonLabel.textColor = [UIColor fontGrayColor];
        NSString *reasonString = @"*换货原因";
        NSMutableAttributedString *reasonAttributedString = [[NSMutableAttributedString alloc] initWithString:reasonString];
        [reasonAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor themeColor] range:NSMakeRange(0, 1)];
        reasonLabel.attributedText = reasonAttributedString;
        [self.contentView addSubview:reasonLabel];
        
        rect.origin.x = CGRectGetMaxX(reasonLabel.frame);
        rect.size.width = fullWidth - rect.origin.x - edgeInsets.right;
        _reasonTextField = [[UITextField alloc] initWithFrame:rect];
        _reasonTextField.delegate = self;
        _reasonTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _reasonTextField.backgroundColor = [UIColor customGrayColor];
        _reasonTextField.layer.borderWidth = 0.5;
        _reasonTextField.layer.cornerRadius = 4;
        _reasonTextField.font = [UIFont systemFontOfSize:13];
        _reasonTextField.placeholder = @"请输入您要退/换货的理由（限50字）";
        [self.contentView addSubview:_reasonTextField];
        
        
        rect.origin.x = CGRectGetMinX(reasonLabel.frame);
        rect.origin.y = CGRectGetMaxY(reasonLabel.frame)+6;
        rect.size.width = CGRectGetWidth(reasonLabel.frame);
        UILabel *photoLabel = [[UILabel alloc] initWithFrame:rect];
        photoLabel.font = reasonLabel.font;
        photoLabel.textColor = [UIColor fontGrayColor];
        photoLabel.text = @" 上传凭证";
        [self.contentView addSubview:photoLabel];
        
        rect.origin.x = CGRectGetMaxX(photoLabel.frame);
        rect.origin.y = CGRectGetMinY(photoLabel.frame) + 5;
        rect.size.width = 31;
        rect.size.height = rect.size.width;
        _addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhotoButton.frame = rect;
//        _addPhotoButton.layer.borderWidth = 0.5;
//        _addPhotoButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//        _addPhotoButton.layer.cornerRadius = 4;
        [_addPhotoButton setImage:[UIImage imageNamed:@"afterSaleAdd"] forState:UIControlStateNormal];
        [_addPhotoButton setImage:[UIImage imageNamed:@"afterSaleAddSelected"] forState:UIControlStateHighlighted];
        [_addPhotoButton addTarget:self action:@selector(willAddPhoto) forControlEvents:UIControlEventTouchUpInside];
        
        _uploadedImageViews = [NSMutableArray array];
        for (int i = 0; i < 6; i++) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedUploadedImageView:)];
            MLUploadedImageView *uploadedImageView = [[MLUploadedImageView alloc] initWithFrame:rect];
            uploadedImageView.userInteractionEnabled = YES;
            uploadedImageView.hidden = YES;
            uploadedImageView.tag = i;
            [uploadedImageView addGestureRecognizer:tap];
            [_uploadedImageViews addObject:uploadedImageView];
            rect.origin.x += rect.size.width + 8;
            [self.contentView addSubview:uploadedImageView];
        }
        
        [self.contentView addSubview:_addPhotoButton];
        
        /*
		_returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_returnButton.frame = rect;
		_returnButton.layer.borderColor = [[UIColor grayColor] CGColor];
		_returnButton.layer.borderWidth = 0.5;
		_returnButton.layer.cornerRadius = 4;
		_returnButton.backgroundColor = [UIColor customGrayColor];
		[_returnButton setTitle:@"我要退货" forState:UIControlStateNormal];
		[_returnButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[_returnButton 
         
         
         :[UIColor themeColor] forState:UIControlStateSelected];
		[_returnButton addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_returnButton];
		
		rect.origin.x = CGRectGetMaxX(_returnButton.frame) + edgeInsets.right;
		_changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_changeButton.frame = rect;
		_changeButton.layer.borderWidth = _returnButton.layer.borderWidth;
		_changeButton.layer.borderColor = _returnButton.layer.borderColor;
		_changeButton.layer.cornerRadius = _returnButton.layer.cornerRadius;
		_changeButton.backgroundColor = _returnButton.backgroundColor;
		[_changeButton setTitle:@"我要换货" forState:UIControlStateNormal];
		[_changeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[_changeButton setTitleColor:[UIColor themeColor] forState:UIControlStateSelected];
		[_changeButton addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_changeButton];
		
		
		
		
         */
	}
	return self;
}

- (void)setType:(MLAfterSalesType)type {
	_type = type;
	if (_type == MLAfterSalesTypeReturn) {
		_returnButton.selected = YES;
		_changeButton.selected = NO;
	} else if (_type == MLAfterSalesTypeChange) {
		_returnButton.selected = NO;
		_changeButton.selected = YES;
	} else {
		_returnButton.selected = NO;
		_changeButton.selected = NO;
	}
    
    [self changeState];
}

- (void)setReason:(NSString *)reason {
	_reason = reason;
	if (_reason) {
		_reasonTextField.text = _reason;
	}
}

- (void)willAddPhoto {
	if (_delegate) {
		[_delegate willAddPhoto];
	}
}

- (void)setUploadedImages:(NSArray *)uploadedImages {
	_uploadedImages = [NSArray arrayWithArray:uploadedImages];
	NSInteger min = MIN(_uploadedImageViews.count, _uploadedImages.count);
	for (int i = 0; i < _uploadedImageViews.count; i++) {
		MLUploadedImageView	*uploadedImageView = _uploadedImageViews[i];
		if (i < min) {
			UIImage *image = _uploadedImages[i];
			uploadedImageView.image = image;
			uploadedImageView.hidden = NO;
		} else {
			uploadedImageView.hidden = YES;
		}
	}
	
	if (min >= 6) {
		_addPhotoButton.hidden = YES;
	} else {
		MLUploadedImageView	*uploadedImageView = _uploadedImageViews[min];
		_addPhotoButton.frame = uploadedImageView.frame;
	}
}

- (void)tappedUploadedImageView:(UITapGestureRecognizer *)tap {
	if (_delegate) {
		[_delegate willDeletePhotoAtIndex:tap.view.tag];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (_delegate) {
		[_delegate didEndEditing:textField.text];
	}
}

- (void)changeType:(UIButton *)sender {
	_changeButton.selected = NO;
	_returnButton.selected = NO;
	sender.selected = YES;
	if (sender == _changeButton) {
		if (_delegate) {
			[_delegate didSelectAfterSalesType:MLAfterSalesTypeChange];
		}
	} else {
		if (_delegate) {
			[_delegate didSelectAfterSalesType:MLAfterSalesTypeReturn];
		}
	}
}


- (UIView *)viewForType:(CGRect)frame title:(NSString *)title isSelected:(BOOL)select tag:(MLAfterSalesType)type
{
    UIView *returnBgView = [[UIView alloc] initWithFrame:frame];
    returnBgView.layer.borderWidth = 0.5;
    returnBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    returnBgView.layer.cornerRadius = 4;
    returnBgView.backgroundColor = [UIColor customGrayColor];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, frame.size.width-10, frame.size.height)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = title;
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.textColor = select?[UIColor blackColor]:[UIColor darkGrayColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    [returnBgView addSubview:lbl];
    
    if(select) {
        UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circleSelected"]];
        imgview.center = CGPointMake(frame.size.width - 25, frame.size.height/2.0);
        [returnBgView addSubview:imgview];
    }
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    control.backgroundColor = [UIColor clearColor];
    control.tag = type;
    [control addTarget:self action:@selector(didSelectType:) forControlEvents:UIControlEventTouchUpInside];
    [returnBgView addSubview:control];
    
    return returnBgView;

}

- (void)changeState
{
    CGRect rectReturn = self.viewReturn.frame;
    CGRect rectChange = self.viewChange.frame;
    
    //    [self.viewReturn removeFromSuperview];
    //    [self.viewChange removeFromSuperview];
    
    if (_type == MLAfterSalesTypeReturn) {
        self.viewReturn = [self viewForType:rectReturn title:@"我要退货" isSelected:YES tag:MLAfterSalesTypeReturn];
        self.viewChange = [self viewForType:rectChange title:@"我要换货" isSelected:NO tag:MLAfterSalesTypeChange];
    }
    else {
        self.viewReturn = [self viewForType:rectReturn title:@"我要退货" isSelected:NO tag:MLAfterSalesTypeReturn];
        self.viewChange = [self viewForType:rectChange title:@"我要换货" isSelected:YES tag:MLAfterSalesTypeChange];
    }
    [self.contentView addSubview:self.viewReturn];
    [self.contentView addSubview:self.viewChange];
}


- (void)didSelectType:(UIControl *)control
{
    _type = control.tag;
    [self changeState];
}

@end
