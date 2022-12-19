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

@implementation NSDate (Extension)

- (NSDate *)tomorrow
{
    return [self dateByAddingDays:1];
}

- (NSDate *)yesterday
{
    return [self dateByAddingDays:-1];
}

- (NSDate *)beginOfDate
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    components.second = 0;
    components.minute = 0;
    components.hour = 0;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)endOfDate
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    components.second = 59;
    components.minute = 59;
    components.hour = 23;
    NSCalendar *result = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [result dateFromComponents:components];
}

- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)isEqualToDateIgnoringDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.hour == components2.hour) &&
            (components1.minute == components2.minute) &&
            (components1.second == components2.second));
}

- (BOOL)isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate date].tomorrow];
}

- (BOOL)isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate date].yesterday];
}

- (BOOL)isSameWeekAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:aDate];
    
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL)isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isSameMonthAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    return ((components1.month == components2.month) && (components1.year == components2.year));
}

- (BOOL)isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL)isNextMonth
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return ((components1.month == components2.month+1) && (components1.year == components2.year));
}

- (BOOL)isLastMonth
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return ((components1.month == components2.month-1) && (components1.year == components2.year));
}

- (BOOL)isSameYearAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL)isThisYear
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextYear
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year + 1));
}

- (BOOL)isLastYear
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year - 1));
}

- (BOOL)isWorkday
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL)isWeekend
{
    return ![self isWorkday];
}

- (BOOL)isEarlierThanDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThanDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

- (NSDate *)dateByAddingDays:(NSInteger)days
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingHours:(NSInteger)hours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingMonth:(NSInteger)month
{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:month];
    return [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)dateByAddingYear:(NSInteger)year
{
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:year];
    return [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSInteger)minutesBetweenDate:(NSDate *)date
{
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)ceil(ti / D_MINUTE);
}

- (NSInteger)hoursBetweenDate:(NSDate *)date
{
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_HOUR);
}

- (NSInteger)daysBetweenDate:(NSDate *)date
{
    NSTimeInterval ti = [date timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_DAY);
}

- (NSInteger)monthBetweenDate:(NSDate *)date
{
    return (12 * (date.year - self.year) + date.month - self.month);
}

- (NSInteger)weeksBetweenDate:(NSDate *)date
{
    //    return date.week - self.week;
    NSDateComponents *comp1 = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSDateComponents *comp2 = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    NSDate *date1 = [date dateByAddingDays:(1-comp1.weekday)];
    NSDate *date2 = [self dateByAddingDays:(1-comp2.weekday)];
    NSTimeInterval interval = [date1 timeIntervalSinceDate:date2];
    return (interval/D_WEEK);
}

- (NSInteger) hour
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

- (NSInteger) minute
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

- (NSInteger) second
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

- (NSInteger) nanosecond
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitNanosecond fromDate:self];
    return components.nanosecond;
}

- (NSInteger) day
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger) month
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger) week
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self];
    return components.weekOfYear;
}

- (NSInteger) weekday
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}

- (NSInteger) year
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:DATE_COMPONENTS fromDate:self];
    return components.year;
}

- (NSInteger)daysInMonth
{
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.calendar = [NSCalendar currentCalendar];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    return components.date;
}

+(NSDate*)dateFromRFC1123:(NSString*)value
{
    if(value == nil)
        return nil;
    
    const char *str = [value UTF8String];
    const char *fmt;
    NSDate *retDate;
    char *ret;
    
    fmt = "%a, %d %b %Y %H:%M:%S %Z";
    struct tm rfc1123timeinfo;
    memset(&rfc1123timeinfo, 0, sizeof(rfc1123timeinfo));
    ret = strptime_l(str, fmt, &rfc1123timeinfo, NULL);
    if (ret) {
        time_t rfc1123time = mktime(&rfc1123timeinfo);
        retDate = [NSDate dateWithTimeIntervalSince1970:rfc1123time];
        if (retDate != nil)
            return retDate;
    }
    
    
    fmt = "%A, %d-%b-%y %H:%M:%S %Z";
    struct tm rfc850timeinfo;
    memset(&rfc850timeinfo, 0, sizeof(rfc850timeinfo));
    ret = strptime_l(str, fmt, &rfc850timeinfo, NULL);
    if (ret) {
        time_t rfc850time = mktime(&rfc850timeinfo);
        retDate = [NSDate dateWithTimeIntervalSince1970:rfc850time];
        if (retDate != nil)
            return retDate;
    }
    
    fmt = "%a %b %e %H:%M:%S %Y";
    struct tm asctimeinfo;
    memset(&asctimeinfo, 0, sizeof(asctimeinfo));
    ret = strptime_l(str, fmt, &asctimeinfo, NULL);
    if (ret) {
        time_t asctime = mktime(&asctimeinfo);
        return [NSDate dateWithTimeIntervalSince1970:asctime];
    }
    
    return nil;
}

-(NSString*)rfc1123String
{
    time_t date = (time_t)[self timeIntervalSince1970];
    struct tm timeinfo;
    gmtime_r(&date, &timeinfo);
    char buffer[32];
    size_t ret = strftime_l(buffer, sizeof(buffer), "%a, %d %b %Y %H:%M:%S GMT", &timeinfo, NULL);
    if (ret) {
        return @(buffer);
    } else {
        return nil;
    }
}

@end

static inline NSString * DateFormatString(GOSDateFormat fmt)
{
    switch (fmt) {
        case GOSDateLineFormatYMDHMS: return @"yyyy-MM-dd HH:mm:ss";
        case GOSDateLineFormatYMDHM: return @"yyyy-MM-dd HH:mm";
        case GOSDateLineFormatYMD: return @"yyyy-MM-dd";
        case GOSDateLineFormatYM: return @"yyyy-MM";
        case GOSDateDotFormatYMDHMS: return @"yyyy.MM.dd HH:mm:ss";
        case GOSDateDotFormatYMDHM: return @"yyyy.MM.dd HH:mm";
        case GOSDateDotFormatYMD: return @"yyyy.MM.dd";
        case GOSDateDotFormatYM: return @"yyyy.MM";
        case GOSDateFormatTimeOnly: return @"HH:mm:ss";
        case GOSDateLocalizedFormat12HourTimeOnly: return @"hh:mm:ss a";
        case GOSDateLocalizedFormatWeekdayOnly: return @"E";
        case GOSDateLocalizedFormatYMD: return @"yyyy年MM月dd日";
        case GOSDateLocalizedFormatEYMD: return @"yyyy年MM月dd日 E";
        case GOSDateLocalizedFormatMD: return @"MM月dd日";
        case GOSDateLocalizedFormatYM: return @"yyyy年MM月";
        case GOSDateLocalizedFormatMonthOnly: return @"M月";
        case GOSDateLocalizedFormatYearOnly: return @"yyyy年";
        default: return @"";
    }
}

@implementation NSDate (DateFormat)

- (NSString *)stringFormat:(GOSDateFormat)fmt
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:DateFormatString(fmt)];
    return [format stringFromDate:self];
}

- (NSString *)chineseTimeSeprator
{
    NSString *sep = nil;
    int hour = (int)self.hour;
    if (hour >= 0 && hour < 12) sep = NSLocalizedStringFromTable(@"Forenoon", @"Utils", nil);
    else if (hour >= 12 && hour < 18) sep = NSLocalizedStringFromTable(@"Afternoon", @"Utils", nil);
    else sep = NSLocalizedStringFromTable(@"Night", @"Utils", nil);
    
    return [NSString stringWithFormat:@"%@ %@", [self stringFormat:GOSDateDotFormatYMD], sep];
}

- (NSString *)weekdayChineseString:(GOSWeekdayChineseType)type
{
    NSInteger value = self.weekday;
    if (type == GOSWeekdayChineseZhouType) {
        return value==1?@"周日":value==2?@"周一":value==3?@"周二":value==4?@"周三":value==5?@"周四":value==6?@"周五":value==7?@"周六":@"";
    }else {
        return value==1?@"星期日":value==2?@"星期一":value==3?@"星期二":value==4?@"星期三":value==5?@"星期四":value==6?@"星期五":value==7?@"星期六":@"";
    }
}

@end

@implementation NSString (DateFormat)

- (NSDate *)dateWithFormat:(GOSDateFormat)fmt
{
    if (!self.isValid) return nil;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    if (fmt == GOSDateLineFormatYM) {
        [format setDateFormat:DateFormatString(GOSDateLineFormatYMD)];
        return [format dateFromString:[self stringByAppendingString:@"-01"]];
    }else if (fmt == GOSDateDotFormatYM) {
        [format setDateFormat:DateFormatString(GOSDateDotFormatYMD)];
        return [format dateFromString:[self stringByAppendingString:@".01"]];
    }
    [format setDateFormat:DateFormatString(fmt)];
    return [format dateFromString:self];
}

- (NSString *)dotDateString
{
    if (!self.isValid) return nil;
    if ([self rangeOfString:@"-"].location == NSNotFound) {
        return [self copy];
    }
    return [self stringByReplacingOccurrencesOfString:@"-" withString:@"."];
}

- (NSString *)lineDateString
{
    if (!self.isValid) return nil;
    if ([self rangeOfString:@"."].location == NSNotFound) {
        return [self copy];
    }
    return [self stringByReplacingOccurrencesOfString:@"." withString:@"-"];
}

- (NSString *)dateComponent
{
    if (!self.isValid) return nil;
    NSRange range = [self rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return [self substringToIndex:range.location];
    }
    return [self copy];
}

- (NSString *)timeComponent
{
    if (!self.isValid) return nil;
    NSRange range = [self rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return [self substringFromIndex:range.location+1];
    }
    return [self copy];
}

+ (NSString *)chainDateString:(NSString *)from andDateString:(NSString *)to
{
    if (!from.isValid) return nil;
    if (!to.isValid) return nil;
    
    NSString *fromFmtted = from.dateComponent.dotDateString;
    if (!fromFmtted) return nil;
    NSString *toFmtted = to.dateComponent.dotDateString;
    if (!toFmtted) return nil;
    
    return [NSString stringWithFormat:@"%@-%@", fromFmtted, toFmtted];
}

// 时间戳—>字符串时间
+ (NSString *)cStringFromTimestamp:(NSString *)timestamp fmt:(GOSDateFormat)fmt {
    
    NSString *dateFmt;
    switch (fmt) {
        case GOSDateBacklashYMDHMS:
            dateFmt = @"yyyy/MM/dd HH:mm:ss";
            break;
        case GOSDateChineseYMDHM:
            dateFmt = @"yyyy年MM月dd日 HH:mm";
            break;
        case GOSDateChineseMDHM:
            dateFmt = @"MM月dd日 HH:mm";
            break;
        case GOSDateChineseYMDHMS:
            dateFmt = @"yyyy年MM月dd日 HH:mm:ss";
            break;
        default:
            dateFmt = @"yyyy/MM/dd HH:mm:ss";
            break;
    }
    
NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:dateFmt];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}

@end
