//
//  MLJudgeViewController.m
//  MoLi
//
//  Created by 颜超 on 15/4/16.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "MLJudgeViewController.h"
#import "MLGoodsOrderTableViewCell.h"
#import "MLCommentInfo.h"


@interface MLJudgeViewController ()

@end

@implementation MLJudgeViewController {
    NSArray *goodsArray;
    NSMutableArray *commentInfos;
    int currentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor backgroundColor];
    self.title = @"评价订单";
    currentIndex = 0;
    [self setLeftBarButtonItemAsBackArrowButton];
    commentInfos = [NSMutableArray array];
    [self showInfo];
}

- (void)selectPhoto {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil), NSLocalizedString(@"从相册选取", nil), nil];
        [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    if (actionSheet.firstOtherButtonIndex == buttonIndex) {
        NSLog(@"拍照");
        [self takePhoto];
    } else if (actionSheet.firstOtherButtonIndex + 1 == buttonIndex) {
        NSLog(@"从相册获取");
        [self LocalPhoto];
    }
}

- (void)uploadImage:(UIImage *)img {
    [self displayHUD:@"上传中..."];
    [[MLAPIClient shared] uploadImage:img withBlock:^(NSString *imagePath, MLResponse *response) {
        [self displayResponseMessage:response];
        if (response.success) {
            NSLog(@"上传成功");
            MLCommentInfo *commentInfo = commentInfos[currentIndex];
            NSMutableDictionary *imgDict = [[NSMutableDictionary alloc] init];
            imgDict[@"img"] = img;
            imgDict[@"url"] = imagePath;
            if ([commentInfo.imgages count] == 0) {
                NSArray *imgs = @[imgDict];
                commentInfo.imgages = imgs;
            } else {
                NSMutableArray *imgs = [NSMutableArray arrayWithArray:commentInfo.imgages];
                [imgs addObject:imgDict];
                commentInfo.imgages = imgs;
            }
            [_tableView reloadData];
        }
    }];
}

-(void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        [self displayHUDTitle:nil message:@"模拟机不能测试相机"];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1.0)];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self uploadImage:image];
}

- (void)showInfo {
    if (_order) {
        [self displayHUD:@"加载中..."];
        [[MLAPIClient shared] orderCommentInfo:_order.ID WithBlock:^(NSDictionary *attributes, MLResponse *response) {
            [self displayResponseMessage:response];
            if (response.success) {
                NSLog(@"%@",response.data);
                NSArray *goodslist = response.data[@"goodslist"];
                goodsArray = [MLGoods createGoodsWithArray:goodslist];
                for (int i = 0; i < [goodsArray count]; i++) {
                    MLGoods *goods = goodsArray[i];
                    MLCommentInfo *cInfo = [[MLCommentInfo alloc] init];
                    cInfo.goodsid = goods.ID;
                    cInfo.unique = goods.unique;
                    cInfo.stars = @"5";
                    cInfo.content = @"";
                    [commentInfos addObject:cInfo];
                }
                [_tableView reloadData];
            }
        }];
    }
}

- (void)refreshOrderList {
    [[NSNotificationCenter defaultCenter] postNotificationName:ML_GOODS_TAKE
                                                        object:nil];
}

- (IBAction)sendComment:(id)sender {
    if ([goodsArray count] == 0) {
        return;
    }
    BOOL canSend = YES;
    NSString *failReason = nil;
    for (MLCommentInfo *commentInfo in commentInfos) {
        if ([commentInfo.content length] == 0) {
            canSend = NO;
            failReason = @"请填写评价内容!";
        }
//        if ([commentInfo.imgages count] == 0) {
//            canSend = NO;
//            failReason = @"请上传晒单照片!";
//        }
        if ([commentInfo.content length] > 140) {
            canSend = NO;
            failReason = @"评价内容超出字数限制!";
        }
    }
    if (!canSend) {
        [self displayHUDTitle:nil message:failReason];
        return;
    }
    [self displayHUD:@"加载中..."];
    NSMutableArray *infoArray = [NSMutableArray array];
    for (int i = 0; i < [commentInfos count]; i++) {
        MLCommentInfo *goods = commentInfos[i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict[@"goodsid"] = goods.goodsid;
        dict[@"unique"] = goods.unique;
        dict[@"content"] = goods.content;
        NSMutableArray *imgs = [NSMutableArray array];
        for (int j = 0; j < [goods.imgages count]; j++) {
            NSDictionary *dict = goods.imgages[j];
            [imgs addObject:dict[@"url"]];
        }
        if ([imgs count] > 0) {
            dict[@"images"] = imgs;
        }
        dict[@"stars"] = goods.stars;
        [infoArray addObject:dict];
    }
    NSLog(@"%@", infoArray);
    NSData *jsonData = [self toJSONData:infoArray];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    [[MLAPIClient shared] sendComment:_order.ID commentInfo:jsonStr WithBlock:^(NSDictionary *attributes, MLResponse *response) {
        if (response.success) {
            [self displayHUDTitle:nil message:@"评价成功"];
            [self performSelector:@selector(back) withObject:nil afterDelay:1.0];
            return;
        }
        [self displayResponseMessage:response];
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    [self refreshOrderList];
}

- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 360;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [goodsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UITableViewCell";
    MLJudgeGoodsCell *cell = (MLJudgeGoodsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MLJudgeGoodsCell" owner:nil options:nil];
        cell = [nibs lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor whiteColor];
    }
    MLGoods *goods = goodsArray[indexPath.row];
    cell.delegate = self;
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:goods.imagePath]];
    cell.goodsNameLabel.text = goods.name;
    [cell.goodsNameLabel sizeToFit];
    cell.typeLabel.text = goods.goodsPropertiesString;
    cell.priceLabel.text = [NSString stringWithFormat:@"价格:%@", goods.price];
    cell.numLabel.text = [NSString stringWithFormat:@"数量:%@", goods.quantityInCart];
    MLCommentInfo *commentInfo = commentInfos[indexPath.row];
    [cell setStar:commentInfo.stars];
    [cell setContent:commentInfo.content];
    [cell refreshButton:commentInfo.imgages];
    cell.tag = indexPath.row;
    return cell;
}

- (void)starChanged:(NSString *)stars
              index:(NSInteger)index {
    MLCommentInfo *commentInfo = commentInfos[index];
    commentInfo.stars = stars;
}

- (void)contentChanged:(NSString *)content
                 index:(NSInteger)index {
    MLCommentInfo *commentInfo = commentInfos[index];
    commentInfo.content = content;
}

- (void)takePhoto:(NSInteger)index currentButton:(NSInteger)tag {
    MLCommentInfo *commentInfo = commentInfos[index];
    if (tag - 1000 <=  [commentInfo.imgages count]) {
        NSMutableArray *imgs = [NSMutableArray arrayWithArray:commentInfo.imgages];
        [imgs removeObjectAtIndex:tag - 1001];
        commentInfo.imgages = imgs;
        [_tableView reloadData];
    } else {
        currentIndex = index;
        [self selectPhoto];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


@end
