//
//  EZDate.h
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

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, EZWeekdayMask) { EZSunday, EZMonday, EZTuesday, EZWednesday, EZThursday, EZFriday, EZSaturday };

@interface EZDate : NSDate
{
    @protected
    // backing for readonly properties
    NSTimeInterval _timeIntervalSinceReferenceDate;
    NSCalendar* _calendar;
    NSTimeZone* _timeZone;
    NSString* _calId;
    NSDateFormatter* _formatter;
    NSDateComponents* _comps;
}

// this is what makes us an NSDate
@property (nonatomic,readonly) NSTimeInterval timeIntervalSinceReferenceDate;

// the calendar used for date calculations
@property (nonatomic,readonly) NSCalendar* calendar;
// the timezone
@property (nonatomic,readonly) NSTimeZone* timeZone;

// things that would require you to mess with NSCalendar and NSDateComponents
// are conveniently exposed as properties

// the basics
@property (nonatomic,readonly) NSInteger year;
@property (nonatomic,readonly) NSInteger month;
@property (nonatomic,readonly) NSInteger day;
@property (nonatomic,readonly) NSInteger hour;
@property (nonatomic,readonly) NSInteger minute;
@property (nonatomic,readonly) NSInteger second;

// less common
@property (nonatomic,readonly) NSInteger era;
@property (nonatomic,readonly) NSInteger week;
@property (nonatomic,readonly) NSInteger weekday;
@property (nonatomic,readonly) NSInteger weekdayOrdinal;
@property (nonatomic,readonly) NSInteger quarter;
@property (nonatomic,readonly) NSInteger weekOfMonth;
@property (nonatomic,readonly) NSInteger weekOfYear;
@property (nonatomic,readonly) NSInteger yearForWeekOfYear;

// all the NSDate creation methods are provided
+ (id)date;

+ (id)dateWithTimeIntervalSinceNow:(NSTimeInterval)secs;
+ (id)dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)secs;
+ (id)dateWithTimeIntervalSince1970:(NSTimeInterval)secs;
+ (id)dateWithTimeInterval:(NSTimeInterval)ti sinceDate:(NSDate *)date;

+ (id)distantFuture;
+ (id)distantPast;

- (id)init;
- (id)initWithTimeIntervalSinceNow:(NSTimeInterval)secs;
- (id)initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)secsToBeAdded;
- (id)initWithTimeIntervalSince1970:(NSTimeInterval)ti;
- (id)initWithTimeInterval:(NSTimeInterval)secsToBeAdded sinceDate:(NSDate *)anotherDate;

// create a date with an existing NSDate using the user's timezone and a Gregorian calendar
+ (id)dateWithNSDate:(NSDate*)date;
- (id)initWithNSDate:(NSDate*)date;

+ (id)dateWithNSDate:(NSDate*)date calendarIdentifier:(NSString*)calendar timeZone:(NSTimeZone*)tz;
- (id)initWithNSDate:(NSDate*)date calendarIdentifier:(NSString*)calendar timeZone:(NSTimeZone*)tz;

// what you really wanted
+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
// e.g. first Wednesday of the month
+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month ordinal:(NSInteger)ordinal weekday:(NSInteger)weekday;

- (id)dateByAddingYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days;
- (id)dateByAddingHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;

// overridden to return EZDate
- (id)dateByAddingTimeInterval:(NSTimeInterval)ti;

// overridden to guarantee YYYY-MM-DD HH:MM:SS ±HHMM format
- (NSString *)description;

// date at next occurrence after the receiver, useful for setting alarms not in the past
- (id)dateAtNextOccurrenceOfWeekday:(NSInteger)weekday;
- (id)dateAtNextOccurrenceOfMonth:(NSInteger)month day:(NSInteger)day;
- (id)dateAtNextOccurrenceOfHour:(NSInteger)hour minute:(NSInteger)minute;

// enumerators for various calendar applications, basically every repeat option offered by Google Calendar
// the argument to the first block call is the receiver
// set stop to YES to exit enumeration
- (void)repeatEvery:(NSInteger)days daysEndingAt:(NSDate*)end usingBlock:(void(^)(EZDate* date, BOOL *stop))block;
- (void)repeatEvery:(NSInteger)days daysEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void(^)(EZDate* date, BOOL *stop))block;
- (void)repeatEvery:(NSInteger)weeks weeksOnWeekdays:(EZWeekdayMask)mask endingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block;
- (void)repeatEvery:(NSInteger)weeks weeksOnWeekdays:(EZWeekdayMask)mask endingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block;
- (void)repeatEvery:(NSInteger)months monthsEndingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block;
- (void)repeatEvery:(NSInteger)months monthsEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block;
- (void)repeatOrdinalEvery:(NSInteger)months monthsEndingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block;
- (void)repeatOrdinalEvery:(NSInteger)months monthsEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block;
- (void)repeatEvery:(NSInteger)years yearsEndingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block;
- (void)repeatEvery:(NSInteger)years yearsEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block;

// what implements most of the above
- (void)repeatByAddingComponents:(NSDateComponents*)comps endingAt:(NSDate*)end usingBlock:(void(^)(EZDate* date, BOOL *stop))block;
- (void)repeatByAddingComponents:(NSDateComponents*)comps endingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void(^)(EZDate* date, BOOL *stop))block;

// subscript with a format string to get the formatted date string, e.g. NSString* formatted = aDate[@"yyyy-MM-dd"];
- (id)objectForKeyedSubscript:(id)key;
// if you think that's a hack you can use this
- (NSString*)stringWithDateFormat:(NSString*)format;

// these properties aren't really meant to be used by other code
// they're here for the EZMutableDate subclass
@property (nonatomic) NSString* calId;
@property (nonatomic) NSDateFormatter* formatter;
@property (nonatomic) NSDateComponents* comps;

@end
