//
//  EZDate.m
//  Photo Redact
//
//  Created by Lane Phillips (@bugloaf) on 6/20/13.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Milk LLC (@Milk_LLC).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EZDate.h"

@interface EZDate ()
{
    // backing for readonly properties
    NSDate* _NSDate;
    NSCalendar* _calendar;
    NSTimeZone* _timeZone;
}

@property (nonatomic) NSString* calId;
@property (nonatomic) NSDateFormatter* formatter;
@property (nonatomic) NSDateComponents* comps;

@end

@implementation EZDate

#pragma mark - basic properties

// these are all lazy inited
-(NSString *)calId
{
    if (!_calId)
        _calId = NSGregorianCalendar;
    return _calId;
}

-(NSDateFormatter*)formatter
{
    if (!_formatter)
        _formatter = [[NSDateFormatter alloc] init];
    return _formatter;
}

-(NSTimeZone *)timeZone
{
    if (!_timeZone)
        _timeZone = [NSTimeZone defaultTimeZone];
    return _timeZone;
}

-(NSCalendar *)calendar
{
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:self.calId];
        _calendar.timeZone = self.timeZone;
    }
    return _calendar;
}

-(NSDateComponents *)comps
{
    if (!_comps) {
        // get everything
        _comps = [self.calendar
                  components:(NSEraCalendarUnit |
                              NSYearCalendarUnit |
                              NSMonthCalendarUnit |
                              NSDayCalendarUnit |
                              NSHourCalendarUnit |
                              NSMinuteCalendarUnit |
                              NSSecondCalendarUnit |
                              NSWeekCalendarUnit |
                              NSWeekdayCalendarUnit |
                              NSWeekdayOrdinalCalendarUnit |
                              NSQuarterCalendarUnit |
                              NSWeekOfMonthCalendarUnit |
                              NSWeekOfYearCalendarUnit |
                              NSYearForWeekOfYearCalendarUnit)
                  fromDate:_NSDate];
    }
    return _comps;
}

#pragma mark - date components

-(NSInteger)year              { return self.comps.year;              }
-(NSInteger)month             { return self.comps.month;             }
-(NSInteger)day               { return self.comps.day;               }
-(NSInteger)hour              { return self.comps.hour;              }
-(NSInteger)minute            { return self.comps.minute;            }
-(NSInteger)second            { return self.comps.second;            }

-(NSInteger)era               { return self.comps.era;               }
-(NSInteger)week              { return self.comps.week;              }
-(NSInteger)weekday           { return self.comps.weekday;           }
-(NSInteger)weekdayOrdinal    { return self.comps.weekdayOrdinal;    }
-(NSInteger)quarter           { return self.comps.quarter;           }
-(NSInteger)weekOfMonth       { return self.comps.weekOfMonth;       }
-(NSInteger)weekOfYear        { return self.comps.weekOfYear;        }
-(NSInteger)yearForWeekOfYear { return self.comps.yearForWeekOfYear; }

#pragma mark - date creation

+ (id)date { return [[EZDate alloc] init]; }

+ (id)dateWithTimeIntervalSinceNow:(NSTimeInterval)secs { return [[EZDate alloc] initWithTimeIntervalSinceNow:secs]; }
+ (id)dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)secs { return [[EZDate alloc] initWithTimeIntervalSinceReferenceDate:secs]; }
+ (id)dateWithTimeIntervalSince1970:(NSTimeInterval)secs { return [[EZDate alloc] initWithTimeIntervalSince1970:secs]; }
+ (id)dateWithTimeInterval:(NSTimeInterval)ti sinceDate:(NSDate *)date { return [[EZDate alloc] initWithTimeInterval:ti sinceDate:date]; }
+ (id)distantFuture { return [self dateWithNSDate:[NSDate distantFuture]]; }
+ (id)distantPast { return [self dateWithNSDate:[NSDate distantPast]]; }

- (id)init { return [super init]; }
- (id)initWithTimeIntervalSinceNow:(NSTimeInterval)secs { return [super initWithTimeIntervalSinceNow:secs]; }
- (id)initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)secsToBeAdded { return [super initWithTimeIntervalSinceReferenceDate:secsToBeAdded]; }
- (id)initWithTimeIntervalSince1970:(NSTimeInterval)ti { return [super initWithTimeIntervalSince1970:ti]; }
- (id)initWithTimeInterval:(NSTimeInterval)secsToBeAdded sinceDate:(NSDate *)anotherDate { return [super initWithTimeInterval:secsToBeAdded sinceDate:anotherDate]; }

+ (id)dateWithNSDate:(NSDate*)date { return [[EZDate alloc] initWithNSDate:date]; }
- (id)initWithNSDate:(NSDate*)date { return [self initWithTimeInterval:0 sinceDate:date]; }

+ (id)dateWithNSDate:(NSDate*)date calendarIdentifier:(NSString*)calendar timeZone:(NSTimeZone*)tz
{
    return [[EZDate alloc] initWithNSDate:date calendarIdentifier:calendar timeZone:tz];
}

- (id)initWithNSDate:(NSDate*)date calendarIdentifier:(NSString*)calendar timeZone:(NSTimeZone*)tz
{
    self = [self initWithNSDate:date];
    if (self) {
        _calId = calendar;
        _timeZone = tz;
    }
    return self;
}

+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    return [self dateWithYear:year month:month day:day
                         hour:0 minute:0 second:0];
}

+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    
    comps.year = year;
    comps.month = month;
    comps.day = day;
    comps.hour = hour;
    comps.minute = minute;
    comps.second = second;
    
    return [self dateWithNSDate:[cal dateFromComponents:comps]];
}

+(id)dateWithYear:(NSInteger)year month:(NSInteger)month ordinal:(NSInteger)ordinal weekday:(NSInteger)weekday
{
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    
    comps.year = year;
    comps.month = month;
    comps.weekdayOrdinal = ordinal;
    comps.weekday = weekday;
    
    return [self dateWithNSDate:[cal dateFromComponents:comps]];
}

-(id)dateByAddingYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days
{
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    
    comps.year = years;
    comps.month = months;
    comps.day = days;
    
    return [EZDate dateWithNSDate:[cal dateByAddingComponents:comps toDate:self options:0]];
}

-(id)dateByAddingHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    NSCalendar* cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    
    comps.hour = hours;
    comps.minute = minutes;
    comps.second = seconds;
    
    return [EZDate dateWithNSDate:[cal dateByAddingComponents:comps toDate:self options:0]];
}

- (id)dateByAddingTimeInterval:(NSTimeInterval)ti
{
    return [[EZDate alloc] initWithTimeInterval:ti sinceDate:self];
}

- (NSString *)description
{
    return [self stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
}

-(id)dateAtNextOccurrenceOfWeekday:(NSInteger)weekday
{
    // date of given weekday this week
    NSDateComponents* c = [self.calendar components:NSYearForWeekOfYearCalendarUnit|NSWeekOfYearCalendarUnit
                                               fromDate:self];
    c.weekday = weekday;
    
    // is the date in the future?
    NSDate* d = [self.calendar dateFromComponents:c];
    if ([self compare:d] == NSOrderedAscending)
        return [EZDate dateWithNSDate:d];
    
    // bump it forward a week
    c = [[NSDateComponents alloc] init];
    c.weekOfYear = 1;
    return [EZDate dateWithNSDate:[self.calendar dateByAddingComponents:c toDate:d options:0]];
}

- (id)dateAtNextOccurrenceOfMonth:(int)month day:(int)day
{
    // create a date with the given month and day with the receiving date's year
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = month;
    c.day = day;
    
    // is the date in the future?
    NSDate* d = [self.calendar dateFromComponents:c];
    if ([self compare:d] == NSOrderedAscending)
        return [EZDate dateWithNSDate:d];
    
    // bump it forward a year
    c = [[NSDateComponents alloc] init];
    c.year = 1;
    return [EZDate dateWithNSDate:[self.calendar dateByAddingComponents:c toDate:d options:0]];
}

- (id)dateAtNextOccurrenceOfHour:(int)hour minute:(int)minute
{
    // create a date at the given time on the day of the receiving date
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    c.day = self.day;
    c.hour = hour;
    c.minute = minute;
    c.second = 0;
    
    // is the date in the future?
    NSDate* d = [self.calendar dateFromComponents:c];
    if ([self compare:d] == NSOrderedAscending)
        return [EZDate dateWithNSDate:d];
    
    // bump it forward a day
    c = [[NSDateComponents alloc] init];
    c.day = 1;
    return [EZDate dateWithNSDate:[self.calendar dateByAddingComponents:c toDate:d options:0]];
}

- (void)repeatEvery:(NSInteger)days daysEndingAt:(NSDate*)end usingBlock:(void(^)(EZDate* date, BOOL *stop))block
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.day = days;
    [self repeatByAddingComponents:c endingAt:end usingBlock:block];
}

- (void)repeatEvery:(NSInteger)days daysEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void(^)(EZDate* date, BOOL *stop))block
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.day = days;
    [self repeatByAddingComponents:c endingAfter:occurrences occurrencesUsingBlock:block];
}

- (void)repeatEvery:(NSInteger)weeks weeksOnWeekdays:(EZWeekdayMask)mask endingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block
{
    // start on Sunday this week, our block will filter out the earlier dates
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.yearForWeekOfYear = self.yearForWeekOfYear;
    c.weekOfYear = self.weekOfYear;
    c.weekday = 1;
    c.hour = self.hour;
    c.minute = self.minute;
    c.second = self.second;
    EZDate* sunday = [EZDate dateWithNSDate:[self.calendar dateFromComponents:c]];
    
    // repeat weekly, then run a daily block on that week
    c = [[NSDateComponents alloc] init];
    c.weekOfYear = weeks;
    [sunday repeatByAddingComponents:c endingAt:end usingBlock:^(EZDate *wdate, BOOL *wstop) {
        // just repeat every day and filter out the days that don't match the mask
        [wdate repeatEvery:1 daysEndingAt:end usingBlock:^(EZDate *ddate, BOOL *dstop) {
            if ([ddate compare:self] != NSOrderedAscending) {
                switch (ddate.weekday) {
                    case 1: if (mask & EZSunday   ) { block(ddate, dstop); } break;
                    case 2: if (mask & EZMonday   ) { block(ddate, dstop); } break;
                    case 3: if (mask & EZTuesday  ) { block(ddate, dstop); } break;
                    case 4: if (mask & EZWednesday) { block(ddate, dstop); } break;
                    case 5: if (mask & EZThursday ) { block(ddate, dstop); } break;
                    case 6: if (mask & EZFriday   ) { block(ddate, dstop); } break;
                    case 7: if (mask & EZSaturday ) { block(ddate, dstop); } break;
                }
                *wstop = *dstop;
            }
        }];
    }];
}

- (void)repeatEvery:(NSInteger)weeks weeksOnWeekdays:(EZWeekdayMask)mask endingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block
{
    // start on Sunday this week, our block will filter out the earlier dates
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.yearForWeekOfYear = self.yearForWeekOfYear;
    c.weekOfYear = self.weekOfYear;
    c.weekday = 1;
    c.hour = self.hour;
    c.minute = self.minute;
    c.second = self.second;
    EZDate* sunday = [EZDate dateWithNSDate:[self.calendar dateFromComponents:c]];
    
    // count the number of occurrences we find so we know when to exit
    __block int i = 0;
    
    // repeat weekly, then run a daily block on that week
    c = [[NSDateComponents alloc] init];
    c.weekOfYear = weeks;
    [sunday repeatByAddingComponents:c endingAt:[NSDate distantFuture] usingBlock:^(EZDate *wdate, BOOL *wstop) {
        // just repeat every day and filter out the days that don't match the mask
        [wdate repeatEvery:1 daysEndingAt:[NSDate distantFuture] usingBlock:^(EZDate *ddate, BOOL *dstop) {
            if ([ddate compare:self] != NSOrderedAscending) {
                switch (ddate.weekday) {
                    case 1: if (mask & EZSunday   ) { block(ddate, dstop); i++; } break;
                    case 2: if (mask & EZMonday   ) { block(ddate, dstop); i++; } break;
                    case 3: if (mask & EZTuesday  ) { block(ddate, dstop); i++; } break;
                    case 4: if (mask & EZWednesday) { block(ddate, dstop); i++; } break;
                    case 5: if (mask & EZThursday ) { block(ddate, dstop); i++; } break;
                    case 6: if (mask & EZFriday   ) { block(ddate, dstop); i++; } break;
                    case 7: if (mask & EZSaturday ) { block(ddate, dstop); i++; } break;
                }
                *dstop = (*dstop || i >= occurrences);
                *wstop = *dstop;
            }
        }];
    }];
}

- (void)repeatEvery:(NSInteger)months monthsEndingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.month = months;
    [self repeatByAddingComponents:c endingAt:end usingBlock:block];
}

- (void)repeatEvery:(NSInteger)months monthsEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.month = months;
    [self repeatByAddingComponents:c endingAfter:occurrences occurrencesUsingBlock:block];
}

- (void)repeatOrdinalEvery:(NSInteger)months monthsEndingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    int modMonth = c.month - 1;
    c.weekdayOrdinal = self.weekdayOrdinal;
    c.weekday = self.weekday;
    
    NSDate* date = self;
    BOOL stop = NO;
    while (!stop && [date compare:end] != NSOrderedDescending) {
        block([EZDate dateWithNSDate:date], &stop);
        
        // look out, we're doing date math on our own
        modMonth += months;
        // how many years did we roll over (in case someone is insane enough to enter more than 12 months)?
        c.year += modMonth / 12;
        // TODO: what about negatives?
        modMonth %= 12;
        c.month = modMonth + 1;
        
        date = [self.calendar dateFromComponents:c];
    }
}

- (void)repeatOrdinalEvery:(NSInteger)months monthsEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    int modMonth = c.month - 1;
    c.weekdayOrdinal = self.weekdayOrdinal;
    c.weekday = self.weekday;
    
    NSDate* date = self;
    BOOL stop = NO;
    for (int i = 0; !stop && i < occurrences; i++) {
        block([EZDate dateWithNSDate:date], &stop);
        
        // look out, we're doing date math on our own
        modMonth += months;
        // how many years did we roll over (in case someone is insane enough to enter more than 12 months)?
        c.year += modMonth / 12;
        // TODO: what about negatives?
        modMonth %= 12;
        c.month = modMonth + 1;
        
        date = [self.calendar dateFromComponents:c];
    }
}

- (void)repeatEvery:(NSInteger)years yearsEndingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.year = years;
    [self repeatByAddingComponents:c endingAt:end usingBlock:block];
}

- (void)repeatEvery:(NSInteger)years yearsEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.year = years;
    [self repeatByAddingComponents:c endingAfter:occurrences occurrencesUsingBlock:block];
}

- (void)repeatByAddingComponents:(NSDateComponents*)comps endingAt:(NSDate*)end usingBlock:(void(^)(EZDate* date, BOOL *stop))block
{
    NSDate* date = self;
    BOOL stop = NO;
    while (!stop && [date compare:end] != NSOrderedDescending) {
        block([EZDate dateWithNSDate:date], &stop);
        
        date = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    }
}

- (void)repeatByAddingComponents:(NSDateComponents*)comps endingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void(^)(EZDate* date, BOOL *stop))block
{
    NSDate* date = self;
    BOOL stop = NO;
    for (int i = 0; !stop && i < occurrences; i++) {
        block([EZDate dateWithNSDate:date], &stop);
        
        date = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    }
}

- (id)objectForKeyedSubscript:(id)key
{
    return [self stringWithDateFormat:[key description]];
}

- (NSString*)stringWithDateFormat:(NSString*)format
{
    self.formatter.dateFormat = format;
    return [self.formatter stringFromDate:self];
}

@end
