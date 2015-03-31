//
//  ViewController.m
//  SqlcipherTest
//
//  Created by 阿凡树 on 13-12-24.
//  Copyright (c) 2013年 优米网. All rights reserved.
//

#import "ViewController.h"
#import <sqlite3.h>
//#import <OpenSSL/md5.h>
@interface ViewController ()

@end

@implementation ViewController
//void Md5( NSString * string){
//    // 输入参数 1 ：要生成 md5 值的字符串， NSString-->uchar*
//    unsigned char *inStrg = ( unsigned char *)[[string dataUsingEncoding : NSASCIIStringEncoding ] bytes];
//    // 输入参数 2 ：字符串长度
//    unsigned long lngth = [string length ];
//    // 输出参数 3 ：要返回的 md5 值， MD5_DIGEST_LENGTH 为 16bytes ， 128 bits
//    unsigned char result[ MD5_DIGEST_LENGTH ];
//    // 临时 NSString 变量，用于把 uchar* 组装成可以显示的字符串： 2 个字符一 byte 的 16 进制数
//    NSMutableString *outStrg = [ NSMutableString string ];
//    // 调用 OpenSSL 函数
//    MD5 (inStrg, lngth, result);
//    unsigned int i;
//    for (i = 0 ; i < MD5_DIGEST_LENGTH ; i++)
//    {
//        [outStrg appendFormat : @"%02x" , result[i]];
//    }
//    NSLog ( @"input string:%@" ,string);
//    NSLog ( @"md5:%@" ,outStrg);
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    Md5(@"asd");
	// Do any additional setup after loading the view, typically from a nib.
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                              stringByAppendingPathComponent: @"sqlcipher.db"];
    NSLog(@"databasePath: %@",databasePath);
    
    sqlite3 *db;
    if (sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK) {
        const char* key = [@"BIGSecret" UTF8String];
        sqlite3_key(db, key, strlen(key));
        if (sqlite3_exec(db, (const char*) "SELECT count(*) FROM sqlite_master;", NULL, NULL, NULL) == SQLITE_OK) {
            // password is correct, or, database has been initialized
            NSLog(@"打开数据库成功");
            char *errorMsg;
            const char *createSql="create table if not exists persons (id integer primary key autoincrement,name text)";
            
            if (sqlite3_exec(db, createSql, NULL, NULL, &errorMsg)==SQLITE_OK) {
                NSLog(@"create ok.");
            }
            
            const char *insertSql="insert into persons (name) values('张三')";
            if (sqlite3_exec(db, insertSql, NULL, NULL, &errorMsg)==SQLITE_OK) {
                NSLog(@"insert ok.");
            }
            
            const char *selectSql="select id,name from persons";
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(db, selectSql, -1, &statement, nil)==SQLITE_OK) {
                NSLog(@"select ok.");
            }
            
            while (sqlite3_step(statement)==SQLITE_ROW) {
                int _id=sqlite3_column_int(statement, 0);
                NSString *name=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
                NSLog(@"row>>id %i, name %@",_id,name);
            }
            
        } else {
            // incorrect password!
        }
        
        sqlite3_close(db);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
