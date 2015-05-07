//
//  FMDBManger.h
//  MoLi
//
//  Created by imooly-mac on 15/5/7.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface FMDBManger : NSObject

@property (strong,nonatomic) FMDatabase *db;

+ (instancetype)shared;
-(void)creatDatabase;
-(void)insertNewMsg:(MLMessage*)newmsg;
-(NSMutableArray *)getAllMessage;
-(void)operationMessage:(MLMessage*)message updateMessage:(BOOL)update delete:(BOOL)de;
@end
