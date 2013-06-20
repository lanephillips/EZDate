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

@interface EZDate : NSDate

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
// the designated initializer
- (id)initWithNSDate:(NSDate*)date calendarIdentifier:(NSString*)calendar timeZone:(NSTimeZone*)tz;

// what you really wanted
+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

// overridden to return EZDate
- (id)dateByAddingTimeInterval:(NSTimeInterval)ti;

// overridden to guarantee YYYY-MM-DD HH:MM:SS ±HHMM format
- (NSString *)description;

// date at next occurrence after the receiver, useful for setting alarms not in the past
- (id)dateAtNextOccurrenceOfMonth:(int)month day:(int)day;
- (id)dateAtNextOccurrenceOfHour:(int)hour minute:(int)minute;

// TODO: enumerators for various calendar applications

// suscript with a format string to get the formatted date string, e.g. NSString* formatted = aDate[@"yyyy-MM-dd"];
- (id)objectForKeyedSubscript:(id)key;
// if you think that's a hack you can use this
- (NSString*)stringWithDateFormat:(NSString*)format;

@end
