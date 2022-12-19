//
//  NSDate+Extension.h
//  XZCommonLib
//
//  Created by LuckyXYJ on 2023/3/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extension)

/// 获取对象日期的tomorrow
@property (readonly) NSDate *tomorrow;
/// 获取对象日期的yesterday
@property (readonly) NSDate *yesterday;
/// 获取对象日期的00:00:00
@property (readonly) NSDate *beginOfDate;
/// 获取对象日期的23:59:59
@property (readonly) NSDate *endOfDate;

/// 判断日期是否相等，即是否同一天
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;
/// 判断时间是否想单，不判断是否为同一天
- (BOOL)isEqualToDateIgnoringDate:(NSDate *)aDate;

// 下列property君以当前系统时间为参照来判断对象
@property (readonly) BOOL isToday;
@property (readonly) BOOL isTomorrow;
@property (readonly) BOOL isYesterday;
@property (readonly) BOOL isThisWeek NS_AVAILABLE(10_7, 5_0);
@property (readonly) BOOL isNextWeek NS_AVAILABLE(10_7, 5_0);
@property (readonly) BOOL isLastWeek NS_AVAILABLE(10_7, 5_0);
@property (readonly) BOOL isThisMonth;
@property (readonly) BOOL isNextMonth;
@property (readonly) BOOL isLastMonth;
@property (readonly) BOOL isThisYear;
@property (readonly) BOOL isNextYear;
@property (readonly) BOOL isLastYear;
@property (readonly) BOOL isWorkday;
@property (readonly) BOOL isWeekend;

/// 判断对象时间是否比aData早
- (BOOL)isEarlierThanDate:(NSDate *)aDate;
/// 判断对象时间是否比aData晚
- (BOOL)isLaterThanDate:(NSDate *)aDate;

- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateByAddingHours:(NSInteger)hours;
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;
- (NSDate *)dateByAddingMonth:(NSInteger)month;
- (NSDate *)dateByAddingYear:(NSInteger)year;

- (NSInteger)minutesBetweenDate:(NSDate *)date;
- (NSInteger)hoursBetweenDate:(NSDate *)date;
- (NSInteger)daysBetweenDate:(NSDate *)date;
- (NSInteger)monthBetweenDate:(NSDate *)date;
- (NSInteger)weeksBetweenDate:(NSDate *)date;

@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger second;
@property (readonly) NSInteger nanosecond;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week NS_AVAILABLE(10_7, 5_0);
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger year;

/// 获取当前对象所在月份总共天数
- (NSInteger)daysInMonth;

/// 快速根据给定值创建日期对象，给定值需要在真实可以存在的取值范围内
+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;

// rfc1123标准日期字符串互转函数
+(NSDate*)dateFromRFC1123:(NSString*)value;
-(NSString*)rfc1123String;

@end

typedef NS_OPTIONS(int, GOSDateFormat) {
    GOSDateLineFormatYMDHMS,                 // yyyy-MM-dd HH:mm:ss
    GOSDateLineFormatYMDHM,                  // yyyy-MM-dd HH:mm
    GOSDateLineFormatYMD,                    // yyyy-MM-dd
    GOSDateLineFormatYM,                     // yyyy-MM
    
    GOSDateBacklashYMDHMS,                   // yyyy/MM/dd HH:mm:ss
    
    GOSDateChineseYMDHMS,                    // yyyy年MM月dd日 HH:mm:ss
    GOSDateChineseYMDHM,                     // yyyy年MM月dd日 HH:mm
    GOSDateChineseMDHM,                      // MM月dd日 HH:mm
    
    GOSDateDotFormatYMDHMS,                  // yyyy.MM.dd HH:mm:ss
    GOSDateDotFormatYMDHM,                   // yyyy.MM.dd HH:mm
    GOSDateDotFormatYMD,                     // yyyy.MM.dd
    GOSDateDotFormatYM,                      // yyyy.MM
    
    GOSDateFormatTimeOnly,                   // HH:mm:ss
    
    GOSDateLocalizedFormatYMD,               // MMM dd, yyyy     yyyy年M月d日
    GOSDateLocalizedFormatEYMD,              // E, MMM d, yyyy   yyyy年M月d日 E
    GOSDateLocalizedFormat12HourTimeOnly,    // hh:mm:ss a
    GOSDateLocalizedFormatMD,                // MMM dd           MM月dd日
    GOSDateLocalizedFormatYM,                // MMM, yyyy        yyyy年MM月
    GOSDateLocalizedFormatMonthOnly,         // MMM              M月
    GOSDateLocalizedFormatWeekdayOnly,       // E
    GOSDateLocalizedFormatYearOnly,          // yyyy             yyyy年
};

typedef NS_OPTIONS(int, GOSWeekdayChineseType) {
    GOSWeekdayChineseZhouType,                   // 周
    GOSWeekdayChineseXingqiType                  // 星期
};

@interface NSDate (DateFormat)

/// 快速将日期对象转换为字符串
- (NSString *)stringFormat:(GOSDateFormat)fmt;

/// 获取中文周显示字符串
- (NSString *)weekdayChineseString:(GOSWeekdayChineseType)type;

/// 获取当前时间分区，含：上午，下午，晚间
- (NSString *)chineseTimeSeprator;

@end

@interface NSString (DateFormat)

/// 快速将字符串转换为日期对象
- (NSDate *)dateWithFormat:(GOSDateFormat)fmt;

/// 快速用'-'替换日期分隔符，copy属性
- (NSString *)lineDateString;

/// 快速用'.'替换日期分隔符，copy属性
- (NSString *)dotDateString;

/// 快速获取日期对象日期部分字符串，copy属性
- (NSString *)dateComponent;

/// 快速获取日期对象时间不分字符串，copy属性
- (NSString *)timeComponent;

/// 用'-'串联两个日期格式字符串，并用'.'作为日期分隔符
+ (NSString *)chainDateString:(NSString *)from andDateString:(NSString *)to;

// 时间戳—>字符串时间
+ (NSString *)cStringFromTimestamp:(NSString *)timestamp fmt:(GOSDateFormat)fmt;

@end


NS_ASSUME_NONNULL_END
