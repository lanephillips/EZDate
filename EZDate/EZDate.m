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
#import "EZMutableDate.h"

@interface EZDate ()

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
                              // Apple bug: NSQuarterCalendarUnit |
                              NSWeekOfMonthCalendarUnit |
                              NSWeekOfYearCalendarUnit |
                              NSYearForWeekOfYearCalendarUnit)
                  fromDate:self];
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
// Apple bug: -(NSInteger)quarter           { return self.comps.quarter;           }
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

- (id)init { return [self initWithTimeIntervalSinceReferenceDate:[NSDate timeIntervalSinceReferenceDate]]; }
- (id)initWithTimeIntervalSinceNow:(NSTimeInterval)secs { return [super initWithTimeIntervalSinceNow:secs]; }
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

// required for NSDate subclasses
// this is where all the init calls eventually end up
- (id)initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)secsToBeAdded
{
    self = [super init];
    if (self) {
        _timeIntervalSinceReferenceDate = secsToBeAdded;
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

+(id)dateWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    EZDate* d = [EZDate date];
    return [self dateWithYear:d.year month:d.month day:d.day
                         hour:hour minute:minute second:second];
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

// TODO: not sure if these are working
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
    self.formatter.calendar = self.calendar;
    return [self.formatter stringFromDate:self];
}

-(NSString *)prettyString
{
    // key dates: midnight this morning
    EZDate* midnight = [EZDate dateWithHour:0 minute:0 second:0];
    NSLog(@"midnight: %@", midnight);
    
    // midnight tonight
    EZDate* tomorrow = [midnight dateByAddingYears:0 months:0 days:1];
    
    // first of this month
    EZDate* first = [EZDate dateWithYear:midnight.year month:midnight.month day:1];
    NSLog(@"first: %@", first);
    
    // first of next month, last year
    EZDate* fnmly = [first dateByAddingYears:-1 months:1 days:0];
    NSLog(@"fnmly: %@", fnmly);
    
    if ([midnight compare:self] != NSOrderedDescending &&
        [self compare:tomorrow] == NSOrderedAscending) {
        // date is today, return just the time
        return [NSDateFormatter localizedStringFromDate:self
                                              dateStyle:NSDateFormatterNoStyle
                                              timeStyle:NSDateFormatterShortStyle];
    }
    
    if ([self compare:fnmly] == NSOrderedAscending ||
        [tomorrow compare:self] != NSOrderedDescending) {
        // date is in future or more than a year ago, return full date
        return [NSDateFormatter localizedStringFromDate:self
                                              dateStyle:NSDateFormatterShortStyle
                                              timeStyle:NSDateFormatterNoStyle];
    }
    
    
    // date more recent than this month last year, return month day
    return [self stringWithDateFormat: @"MMM d"];
}

-(NSString *)prettyElapsedTimeString
{
    NSDate* now = [NSDate date];
    NSDateComponents* c = [self.calendar components:NSYearCalendarUnit|NSDayCalendarUnit|
                           NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                           fromDate:[self earlierDate:now]
                                             toDate:[self laterDate:now]
                                            options:0];
    
    // just return the value for the biggest unit
    if (c.year)
        return [NSString stringWithFormat:@"%dy", c.year];
    // don't do months, because 'm' would be confused with minutes
    // (Twitter actually switches to full dates at some point)
    if (c.day)
        return [NSString stringWithFormat:@"%dd", c.day];
    if (c.hour)
        return [NSString stringWithFormat:@"%dh", c.hour];
    if (c.minute)
        return [NSString stringWithFormat:@"%ds", c.minute];
    return [NSString stringWithFormat:@"%dy", c.second];
}

#pragma mark - NSCopying and NSCoding

-(id)copyWithZone:(NSZone *)zone
{
    // we're immutable, so just return ourselves
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _timeIntervalSinceReferenceDate = [aDecoder decodeDoubleForKey:@"timeIntervalSinceReferenceDate"];
        _calId = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"calId"];
        _timeZone = [aDecoder decodeObjectOfClass:[NSTimeZone class] forKey:@"timeZone"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // this is all the information required to construct an equivalent EZDate
    [aCoder encodeDouble:_timeIntervalSinceReferenceDate forKey:@"timeIntervalSinceReferenceDate"];
    [aCoder encodeObject:_calId forKey:@"calId"];
    [aCoder encodeObject:_timeZone forKey:@"timeZone"];
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return [[EZMutableDate allocWithZone:zone] initWithNSDate:self calendarIdentifier:_calId timeZone:_timeZone];
}

@end
