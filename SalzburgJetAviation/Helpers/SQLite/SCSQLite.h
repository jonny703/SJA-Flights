//
//  SCSQLite.h
//  SalzburgJetAviation
//
//  Created by John Nik on 12/8/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface SCSQLite : NSObject {
    sqlite3 *db;
}

@property (copy, nonatomic) NSString *database;


+ (void)initWithDatabase:(NSString *)database;
+ (BOOL)executeSQL:(NSString *)sql, ...;
+ (NSArray *)selectRowSQL:(NSString *)sql;
//NS_FORMAT_FUNCTION(1,2);
+ (NSString *)getDatabaseDump;

@end
