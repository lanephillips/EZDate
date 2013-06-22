//
//  EZMutableDate.m
//  Photo Redact
//
//  Created by Lane Phillips (@bugloaf) on 6/21/13.
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

#import "EZMutableDate.h"

@interface EZMutableDate ()

@end

@implementation EZMutableDate

#pragma mark - properties

-(void)setTimeIntervalSinceReferenceDate:(NSTimeInterval)timeIntervalSinceReferenceDate
{
    _timeIntervalSinceReferenceDate = timeIntervalSinceReferenceDate;
    _comps = nil;   // force recompute
}

-(void)setCalendar:(NSCalendar *)calendar
{
    if (!calendar)
        // go back to default
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    _calendar = calendar;
    _calId = calendar.calendarIdentifier;
    _timeZone = calendar.timeZone;
    _comps = nil;
}

-(void)setTimeZone:(NSTimeZone *)timeZone
{
    if (!timeZone)
        timeZone = [NSTimeZone defaultTimeZone];
    
    _timeZone = timeZone;
    if (_calendar)
        _calendar.timeZone = timeZone;
    _comps = nil;
}

// TODO: none of these are being validated in any way, I'm not sure what the calendar does with weird values
-(void)setYear:(NSInteger)year
{
    [self setYear:year month:self.month day:self.day hour:self.hour minute:self.minute second:self.second];
}

-(void)setMonth:(NSInteger)month
{
    [self setYear:self.year month:month day:self.day hour:self.hour minute:self.minute second:self.second];
}

-(void)setDay:(NSInteger)day
{
    [self setYear:self.year month:self.month day:day hour:self.hour minute:self.minute second:self.second];
}

-(void)setHour:(NSInteger)hour
{
    [self setYear:self.year month:self.month day:self.day hour:hour minute:self.minute second:self.second];
}

-(void)setMinute:(NSInteger)minute
{
    [self setYear:self.year month:self.month day:self.day hour:self.hour minute:minute second:self.second];
}

-(void)setSecond:(NSInteger)second
{
    [self setYear:self.year month:self.month day:self.day hour:self.hour minute:self.minute second:second];
}

-(void)setWeekday:(NSInteger)weekday
{
    [self setYear:self.yearForWeekOfYear week:self.weekOfYear weekday:weekday hour:self.hour minute:self.minute second:self.second];
}

-(void)setWeekOfYear:(NSInteger)weekOfYear
{
    [self setYear:self.yearForWeekOfYear week:weekOfYear weekday:self.weekday hour:self.hour minute:self.minute second:self.second];
}

-(void)setYearForWeekOfYear:(NSInteger)yearForWeekOfYear
{
    [self setYear:yearForWeekOfYear week:self.weekOfYear weekday:self.weekday hour:self.hour minute:self.minute second:self.second];
}

-(void)setWeekdayOrdinal:(NSInteger)weekdayOrdinal
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.year = self.year;
    c.month = self.month;
    c.weekday = self.weekday;
    c.weekdayOrdinal = weekdayOrdinal;
    c.hour = self.hour;
    c.minute = self.minute;
    c.second = self.second;
    
    NSDate* d = [self.calendar dateFromComponents:c];
    self.timeIntervalSinceReferenceDate = d.timeIntervalSinceReferenceDate;
}

#pragma mark - overridden class methods

// overridden to return EZMutableDate instead of EZDate, otherwise the same

+ (id)date { return [[EZMutableDate alloc] init]; }

+ (id)dateWithTimeIntervalSinceNow:(NSTimeInterval)secs { return [[EZMutableDate alloc] initWithTimeIntervalSinceNow:secs]; }
+ (id)dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)secs { return [[EZMutableDate alloc] initWithTimeIntervalSinceReferenceDate:secs]; }
+ (id)dateWithTimeIntervalSince1970:(NSTimeInterval)secs { return [[EZMutableDate alloc] initWithTimeIntervalSince1970:secs]; }
+ (id)dateWithTimeInterval:(NSTimeInterval)ti sinceDate:(NSDate *)date { return [[EZMutableDate alloc] initWithTimeInterval:ti sinceDate:date]; }
+ (id)distantFuture { return [self dateWithNSDate:[NSDate distantFuture]]; }
+ (id)distantPast { return [self dateWithNSDate:[NSDate distantPast]]; }

+ (id)dateWithNSDate:(NSDate*)date { return [[EZMutableDate alloc] initWithNSDate:date]; }

+ (id)dateWithNSDate:(NSDate*)date calendarIdentifier:(NSString*)calendar timeZone:(NSTimeZone*)tz
{
    return [[EZMutableDate alloc] initWithNSDate:date calendarIdentifier:calendar timeZone:tz];
}

// these 3 call one of the above, so they don't need to be overridden
// TODO: test that assumption
//+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
//+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
//+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month ordinal:(NSInteger)ordinal weekday:(NSInteger)weekday

#pragma mark - other methods

-(void)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    [self setYear:year month:month day:day hour:0 minute:0 second:0];
}

-(void)setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.year = year;
    c.month = month;
    c.day = day;
    c.hour = hour;
    c.minute = minute;
    c.second = second;
    
    NSDate* d = [self.calendar dateFromComponents:c];
    self.timeIntervalSinceReferenceDate = d.timeIntervalSinceReferenceDate;
}

-(void)setYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    NSDateComponents* c = [[NSDateComponents alloc] init];
    c.yearForWeekOfYear = year;
    c.weekOfYear = week;
    c.weekday = weekday;
    c.hour = hour;
    c.minute = minute;
    c.second = second;
    
    NSDate* d = [self.calendar dateFromComponents:c];
    self.timeIntervalSinceReferenceDate = d.timeIntervalSinceReferenceDate;
}

- (id)addYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days
{
    // being mutable isn't buying the user any performance
    EZDate* d = [self dateByAddingYears:years months:months days:days];
    self.timeIntervalSinceReferenceDate = d.timeIntervalSinceReferenceDate;
    return self;
}

- (id)addHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds
{
    EZDate* d = [self dateByAddingHours:hours minutes:minutes seconds:seconds];
    self.timeIntervalSinceReferenceDate = d.timeIntervalSinceReferenceDate;
    return self;
}

- (id)addTimeInterval:(NSTimeInterval)ti
{
    self.timeIntervalSinceReferenceDate = self.timeIntervalSinceReferenceDate + ti;
    return self;
}

-(void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)aKey
{
    [self setDateFromString:[object description] withFormat:[NSString stringWithFormat:@"%@", aKey]];
}

- (void)setDateFromString:(NSString*)dateStr withFormat:(NSString*)format
{
    self.formatter.dateFormat = format;
    NSDate* d = [self.formatter dateFromString:dateStr];
    self.timeIntervalSinceReferenceDate = d.timeIntervalSinceReferenceDate;
}

@end
