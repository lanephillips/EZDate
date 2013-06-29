//
//  EZMutableDate.h
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

#import "EZDate.h"

@interface EZMutableDate : EZDate

// these properties are mutable now
@property (nonatomic,readwrite) NSTimeInterval timeIntervalSinceReferenceDate;
@property (nonatomic,readwrite) NSCalendar* calendar;
@property (nonatomic,readwrite) NSTimeZone* timeZone;

@property (nonatomic,readwrite) NSInteger year;
@property (nonatomic,readwrite) NSInteger month;
@property (nonatomic,readwrite) NSInteger day;
@property (nonatomic,readwrite) NSInteger hour;
@property (nonatomic,readwrite) NSInteger minute;
@property (nonatomic,readwrite) NSInteger second;

@property (nonatomic,readwrite) NSInteger weekday;              // set a different day in the same week
@property (nonatomic,readwrite) NSInteger weekdayOrdinal;       // select a different ordinal weekday in the same month (e.g. 3rd Friday instead of 1st)
@property (nonatomic,readwrite) NSInteger weekOfYear;           // same weekday, different week of the year
@property (nonatomic,readwrite) NSInteger yearForWeekOfYear;    // change the year while keeping weekOfYear and weekday constant

// factory methods are all overridden to return EZMutableDates
// init methods all work the same

- (id)addYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days;
- (id)addHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;
- (id)addTimeInterval:(NSTimeInterval)ti;

// subscript with a format string to set the date from a string, e.g. aDate[@"yyyy-MM-dd"] = @"2003-06-21";
- (void)setObject:(id)object forKeyedSubscript:(id < NSCopying >)aKey;
// if you think that's a hack you can use this
- (void)setDateFromString:(NSString*)dateStr withFormat:(NSString*)format;

@end
