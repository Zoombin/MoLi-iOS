//
//  FMDBManger.m
//  MoLi
//
//  Created by imooly-mac on 15/5/7.
//  Copyright (c) 2015年 zoombin. All rights reserved.
//

#import "FMDBManger.h"


@implementation FMDBManger

+ (instancetype)shared {
    static FMDBManger *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        _shared = [[FMDBManger alloc] init];

    });
    return _shared;
    
}

-(void)creatDatabase
{
    if (!_db) {
        _db = [FMDatabase databaseWithPath:[self databaseFilePath]];
        [self creatTable];
    }

}


-(NSString *)databaseFilePath{
    
   NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentPath = [filePath objectAtIndex:0];
    NSLog(@"%@",filePath);
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"UserMessage.sqlite"];
    return dbFilePath;
    
}

-(void)creatTable
{
	if (!_db) {
	[self creatDatabase];
	}

    if (![_db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    	//为数据库设置缓存，提高查询效率
    	[_db setShouldCacheStatements:YES];

     if(![_db tableExists:@"NewMsg"])
     {
       BOOL success = [_db executeUpdate:@"CREATE TABLE NewMsg(NewMsg_id TEXT, type TEXT, link TEXT, title TEXT, isread TEXT, senddate TEXT, username TEXT) "];
    
         if (success) {
              NSLog(@"创建NewMsg完成");
         }
     }
    
    if(![_db tableExists:@"CheckNewMsg"])
    {
      BOOL successd =  [_db executeUpdate:@"CREATE TABLE CheckNewMsg(username TEXT, num TEXT) "];
        if (successd) {
           NSLog(@"创建CheckNewMsg成功");
        }
        
    }
    
   [_db close];
}

-(void)insertNewMsg:(MLMessage*)newmsg{
    if (!_db) {
        [self creatDatabase];
    }
    
    if (![_db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    [_db setShouldCacheStatements:YES];
    if(![_db tableExists:@"NewMsg"])
    {
        [self creatTable];
    }
    FMResultSet *rs = [_db executeQuery:@"select * from NewMsg where NewMsg_id = ?",newmsg.ID];
    if([rs next])
    {
        [_db executeUpdate:@"update NewMsg set type = ?, link = ?, title = ?, isread = ?, senddate = ?, username = ? where NewMsg_id = ?",newmsg.type,newmsg.link,newmsg.title,newmsg.isRead,[newmsg.sendTimestamp stringValue],newmsg.ID,newmsg.username];
    }
    else{
        [_db executeUpdate:@"INSERT INTO NewMsg (NewMsg_id, link, title, isread, senddate, username) VALUES (?, ?, ?, ?, ?, ?)",newmsg.ID,newmsg.link,newmsg.title,[newmsg.isRead stringValue],[newmsg.sendTimestamp stringValue],newmsg.username];
    }
    
     [_db close];
}

-(NSMutableArray *)getAllMessage:(NSString*)username
{
    
    if(!_db) {
        [self creatDatabase];
    }

   if (![_db open]) {
      NSLog(@"数据库打开失败");
        return nil;
    }

   [_db setShouldCacheStatements:YES];
    if(![_db tableExists:@"NewMsg"])
      {
        return nil;
     }

    	NSMutableArray *messageArray = [[NSMutableArray alloc] initWithArray:0];
    
    	FMResultSet *rs = [_db executeQuery:@"select * from NewMsg where username = ?",username];
    
    	while ([rs next]) {
        	MLMessage *message = [[MLMessage alloc] init];
        
        	message.ID = [rs stringForColumn:@"NewMsg_id"];
        	message.type = [rs stringForColumn:@"type"];
        	message.link = [rs stringForColumn:@"link"];
            message.title = [rs stringForColumn:@"title"];
            message.isRead = [NSNumber numberWithInteger:[[rs stringForColumn:@"isread"] integerValue]];
            message.sendTimestamp = [NSNumber numberWithInteger:[[rs stringForColumn:@"senddate"] integerValue]];
            message.username = username;
            [messageArray addObject:message];
        	}
     [_db close];
    return messageArray;
}

-(void)operationMessage:(MLMessage*)message updateMessage:(BOOL)update delete:(BOOL)del{
    if(!_db) {
        [self creatDatabase];
    }
    
    if (![_db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    
    [_db setShouldCacheStatements:YES];
    if(![_db tableExists:@"NewMsg"])
    {
        return;
    }

    if (update) {
        [_db executeUpdate:@"update NewMsg set isread = ? where NewMsg_id = ?",message.isRead,message.ID];

    }
    
    if (del) {
        
        [_db executeUpdate:@"delete from NewMsg where NewMsg_id = ?", message.ID];

    }
    
    [_db close];
}

-(void)updateOrInsertMsgnumTouserTable:(MLMessageNum*)messagenum{
    if(!_db) {
        [self creatDatabase];
    }
    
    if (![_db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    
    [_db setShouldCacheStatements:YES];
    if(![_db tableExists:@"CheckNewMsg"])
    {
        return;
    }
    
    FMResultSet *rs = [_db executeQuery:@"select * from CheckNewMsg where username = ?",messagenum.username];
    if([rs next])
    {
        [_db executeUpdate:@"update CheckNewMsg set num = ? where username = ?",messagenum.num,messagenum.username];
    }
    else{
        [_db executeUpdate:@"INSERT INTO CheckNewMsg (username, num) VALUES (?, ?)",messagenum.username,messagenum.num];
    }
    
    [_db close];

}

-(MLMessageNum*)getUserMessageNum:(NSString*)username{
    if(!_db) {
        [self creatDatabase];
    }
    
    if (![_db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    
    [_db setShouldCacheStatements:YES];
    if(![_db tableExists:@"CheckNewMsg"])
    {
        return nil;
    }
    
    FMResultSet *rs = [_db executeQuery:@"select * from CheckNewMsg where username = ?",username];
    
      MLMessageNum *messagenums = [[MLMessageNum alloc] init];
    
    while ([rs next]) {

        messagenums.username = [rs stringForColumn:@"username"];
        messagenums.num = [NSNumber numberWithInteger:[[rs stringForColumn:@"num"] integerValue]];
        
    }
    
    
    
    [_db close];
    
    
    return messagenums;
 

}

@end
