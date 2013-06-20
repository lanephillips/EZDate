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

- (id)dateByAddingTimeInterval:(NSTimeInterval)ti
{
    return [[EZDate alloc] initWithTimeInterval:ti sinceDate:self];
}

- (NSString *)description
{
    return [self stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
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
    c.year = 1;
    c.month = 0;
    c.day = 0;
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
    c.year = 0;
    c.month = 0;
    c.day = 1;
    c.hour = 0;
    c.minute = 0;
    return [EZDate dateWithNSDate:[self.calendar dateByAddingComponents:c toDate:d options:0]];
}

// TODO: enumerators for various calendar applications

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
