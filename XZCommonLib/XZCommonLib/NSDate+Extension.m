//
//  NSDate+Extension.m
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import "NSDate+Extension.h"
#import "NSString+RegulerExpression.h"
#import <xlocale.h>

#define D_MINUTE    60
#define D_HOUR        3600
#define D_DAY        86400
#define D_WEEK        604800

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)

