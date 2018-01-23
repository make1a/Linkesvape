#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FFDataBaseModel+Custom.h"
#import "FFDataBaseModel+Sqlite.h"
#import "FFDataBaseModel.h"
#import "FFDB.h"
#import "FFDBLog.h"
#import "FFDBManager.h"
#import "FFDBSafeOperation.h"
#import "FFDBTransaction.h"
#import "FMDatabase+FFExtern.h"
#import "NSObject+FIDProperty.h"
#import "NSString+FFDBExtern.h"
#import "NSString+FFDBSQLStatement.h"

FOUNDATION_EXPORT double FFDBVersionNumber;
FOUNDATION_EXPORT const unsigned char FFDBVersionString[];

