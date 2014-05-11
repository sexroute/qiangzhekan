//
//  LYGlobalSettings.m
//  bh
//
//  Created by zhaodali on 13-2-21.
//
//

#import "LYGlobalSettings.h"
#import "LYUtility.h"
#import "JSON.h"

@implementation LYGlobalSettings

static sqlite3 *contactDB = nil;
static NSMutableDictionary * g_pSettingsDic = nil;
static NSArray *dirPaths = nil;
static NSString *docsDir = nil;
static NSString * databasePath = nil;

+ (void)InitSetting
{
    @synchronized(self)
    {
        if (nil == g_pSettingsDic) {
            g_pSettingsDic = [[NSMutableDictionary alloc] init];
            [LYGlobalSettings initDict];
        }
        
    }
    
}
#pragma mark 数据库操作
+(BOOL) SetVal2Database:(NSString*) apKey :(NSString* )apVal
{
    @synchronized(self)
    {
        BOOL lbRet = NO;
        if (( (nil==apKey || ![apKey isKindOfClass:[NSString class]])) || ( (nil==apVal || ![apVal isKindOfClass:[NSString class]])))
        {
            return lbRet;
        }
        
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement = nil;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            NSString *lstrInsertQuerySQL = [NSString stringWithFormat:@"INSERT OR REPLACE INTO SETTING (ID,VAL) VALUES(\"%@\",\"%@\")",apKey,apVal];
            
            const char *insert_stmt = [lstrInsertQuerySQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL)==SQLITE_OK)
            {
                if (sqlite3_step(statement)==SQLITE_DONE)
                {
                    lbRet = YES;
                }
                 sqlite3_finalize(statement);
            }
            
            sqlite3_close(contactDB);
        }
        
        return  lbRet;
    }
    
}

+(NSString*) GetValFromDatabase:(NSString*) apKey
{
    NSString * lpRet = [NSString stringWithFormat:@""];
    
    if(nil==apKey || !([apKey isKindOfClass:[NSString class]]))
    {
        return lpRet;
    }
    
    @synchronized(self)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement = nil;
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT ID,VAL FROM SETTING WHERE ID=\"%@\"",apKey];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    lpRet = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]autorelease];
                    
                }
                
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(contactDB);
        }
        
    }
    
    return lpRet;
    
    
}

+(void)FillAllKeysInDatabase
{
    @synchronized(self)
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement = nil;
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT ID,VAL FROM SETTING "];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString * lpVal = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]autorelease];
                    NSString * lpKey = [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]autorelease];
                     [g_pSettingsDic setObject:lpVal forKey:lpKey];
                }
                
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(contactDB);
        }
        
    }
}

+ (void)InitDatabase
{
    
    @synchronized(self)
    {
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Settings.db"]];
        DLog(@"Database path:%@",docsDir);
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath:databasePath] == NO)
        {
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
            {
                char *errMsg;
                const char *sql_stmt = "CREATE TABLE IF NOT EXISTS SETTING(ID TEXT PRIMARY KEY , VAL TEXT)";
                if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg)!=SQLITE_OK) {
                    DLog(@"创建表失败\n");
                }
                
                sqlite3_close(contactDB);
            }
            else
            {
                DLog(@"创建/打开数据库失败"); ;
            }
        }
        
    }
    
}

#pragma mark 内存操作
+(BOOL) SetSettingInt:(NSString *)apKey apVal:(int)anVal
{
    NSString * lpVal = [NSString stringWithFormat:@"%d",anVal];
    BOOL lbRet = [LYGlobalSettings SetSettingString:apKey apVal:lpVal];
    return  lbRet;
}


+(int) GetSettingInt:(NSString *)apKey
{
    return  [LYGlobalSettings GetSettingInt:apKey anDefault:0];
}

+ (int) GetSettingInt:(NSString *) apKey anDefault:(int) anDefault
{
    NSString * lpVal = [LYGlobalSettings GetSettingString:apKey];
    if ([LYUtility IsStringEmpty:lpVal])
    {
        return anDefault;
    }
    
    int lnVal = [lpVal intValue];
    
    return  lnVal;
}

+(BOOL) SetSettingDouble:(NSString*)apKey apVal:(double)adblVal
{
    NSString * lpVal = [NSString stringWithFormat:@"%f",adblVal];
    BOOL lbRet = [LYGlobalSettings SetSettingString:apKey apVal:lpVal];
    return  lbRet;
}

+ (double) GetSettingDouble:(NSString *) apKey
{
    return  [LYGlobalSettings GetSettingDouble:apKey adblDefault:.0];
}

+ (double) GetSettingDouble:(NSString *) apKey adblDefault:(double) adblDefault
{
    NSString * lpVal = [LYGlobalSettings GetSettingString:apKey];
    if ([LYUtility IsStringEmpty:lpVal])
    {
        return adblDefault;
    }
    
    double ldblVal = [lpVal doubleValue];
    return  ldblVal;
}

+(NSDictionary *)GetJsonValue:(NSString *)apString
{
    NSDictionary * lpData = [NSDictionary dictionary];
    if (![apString isKindOfClass:[NSString class]])
    {
        return  lpData;
    }
    
    NSError *error = nil;
	SBJSON *json = [[SBJSON new] autorelease];
	id loData = [json objectWithString:apString error:&error];
    if([loData isKindOfClass:[NSDictionary class]])
    {
        lpData = loData;
    }
    return  lpData;
}

+(BOOL) SetSettingString:(NSString*)apKey apVal:(NSString*)apVal
{
    @synchronized(self)
    {
        if (nil == g_pSettingsDic)
        {
            [LYGlobalSettings InitSetting];
        }
        BOOL lbRet = [LYGlobalSettings SetVal2Database:apKey :apVal];
        //assert(lbRet);
        if (TRUE)
        {
            [g_pSettingsDic setObject:apVal forKey:(apKey)];
        }
        
        return  lbRet;
        
    }
}

+ (NSString *) GetSettingString:(NSString *) apKey apStrDefault:(NSString *) apStrDefault
{
    NSString * lpRetValue = nil;
    if (nil!= apKey && ([apKey isKindOfClass:[NSString class]]))
    {
        @synchronized(self)
        {
            if (nil == g_pSettingsDic) {
                [LYGlobalSettings InitSetting];
            }
            id lpDataInDic = [g_pSettingsDic objectForKey:apKey];
            if (nil != lpDataInDic && ([lpDataInDic isKindOfClass :[NSString class]]))
            {
                lpRetValue = [NSString stringWithFormat:@"%@",(NSString *)lpDataInDic];
            }
        }
    }
    
    if (nil ==lpRetValue)
    {
        if (nil == apStrDefault)
        {
            apStrDefault = @"";
        }
        
        lpRetValue = [NSString stringWithFormat:@"%@",apStrDefault];
    }
    return  lpRetValue;
}

+(NSString *) GetSettingString:(NSString *) apKey
{
    return [LYGlobalSettings GetSettingString:apKey apStrDefault:@""];
}
+ (void) initDict
{
    @synchronized(self)
    {
        //1.初始化数据库
        [LYGlobalSettings InitDatabase];
        
        //2.初始化远程连接地址
        [g_pSettingsDic setObject:@"http://qiangzhekan.sinaapp.com" forKey:(SETTING_KEY_SERVER_ADDRESS)];
        [g_pSettingsDic setObject:@"222.199.224.145" forKey:(SETTING_KEY_MIDDLE_WARE_IP)];
        [g_pSettingsDic setObject:@"7005" forKey:(SETTING_KEY_MIDDLE_WARE_PORT)];
        [g_pSettingsDic setObject:@"1" forKey:(SETTING_KEY_SERVERTYPE)];
        
        [g_pSettingsDic setObject:@"1" forKey:SETTING_KEY_STYLE];

        
        
       [LYGlobalSettings FillAllKeysInDatabase];
    }
}


- (id)init
{
    self = [super init];
    
    return self;
}
+ (NSString *) GetPostDataPrefix
{
    
    NSString * lpPostDataPreFix = [NSString stringWithFormat:@"user_token=%@",[LYGlobalSettings GetSettingString:SETTING_KEY_USER_TOKEN ]];
    return lpPostDataPreFix;
}

@end
