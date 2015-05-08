//
//  FMDBManger.h
//  MoLi
//
//  Created by imooly-mac on 15/5/7.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "MLMessage.h"
#import "MLMessageNum.h"

@interface FMDBManger : NSObject

@property (strong,nonatomic) FMDatabase *db;

+ (instancetype)shared;
-(void)creatDatabase;
-(void)insertNewMsg:(MLMessage*)newmsg;
-(NSMutableArray *)getAllMessage:(NSString*)username;
-(void)operationMessage:(MLMessage*)message updateMessage:(BOOL)update delete:(BOOL)del;
-(void)updateOrInsertMsgnumTouserTable:(MLMessageNum*)messagenum;
-(MLMessageNum*)getUserMessageNum:(NSString*)username;
@end
