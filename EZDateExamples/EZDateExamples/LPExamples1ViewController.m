//
//  LPExamples1ViewController.m
//  EZDateExamples
//
//  Created by Lane Phillips on 6/29/13.
//  Copyright (c) 2013 Milk LLC. All rights reserved.
//

#import "LPExamples1ViewController.h"
#import "EZDate.h"

@interface LPExamples1ViewController ()

@property (nonatomic) NSArray* codes;
@property (nonatomic) NSArray* results;

@end

@implementation LPExamples1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _codes = @[
                 @"[EZDate date]",
                 @"[EZDate dateWithTimeIntervalSinceNow:12345678]",
                 @"[EZDate dateWithTimeIntervalSinceReferenceDate:12345678]",
                 @"[EZDate dateWithTimeIntervalSince1970:12345678]",
                 @"[EZDate dateWithTimeInterval:12345678 sinceDate:[NSDate date]]",
                 @"[EZDate distantFuture]",
                 @"[EZDate distantPast]",
                 @"[[EZDate alloc] init]",
                 @"[[EZDate alloc] initWithTimeIntervalSinceNow:12345678]",
                 @"[[EZDate alloc] initWithTimeIntervalSinceReferenceDate:12345678]",
                 @"[[EZDate alloc] initWithTimeIntervalSince1970:12345678]",
                 @"[[EZDate alloc] initWithTimeInterval:12345678 sinceDate:[NSDate date]]",
                 @"[EZDate dateWithNSDate:[NSDate date]]",
                 @"[[EZDate alloc] initWithNSDate:[NSDate date]]",
                 @"[EZDate dateWithNSDate:[NSDate date] calendarIdentifier:NSGregorianCalendar timeZone:[NSTimeZone defaultTimeZone]]",
                 @"[[EZDate alloc] initWithNSDate:[NSDate date] calendarIdentifier:NSGregorianCalendar timeZone:[NSTimeZone defaultTimeZone]]",
                 @"[EZDate dateWithYear:2013 month:7 day:4]",
                 @"[EZDate dateWithYear:2013 month:7 day:4 hour:22 minute:5 second:7]",
                 @"[EZDate dateWithHour:8 minute:33 second:47]",
                 @"[EZDate dateWithYear:2012 month:11 ordinal:1 weekday:2]",
                 @"[[EZDate date] dateByAddingYears:1 months:1 days:-1]",
                 @"[[EZDate date] dateByAddingHours:-1 minutes:1 seconds:20]",
                 @"[[EZDate date] dateByAddingTimeInterval:12345678]",
                 @"[[EZDate date] description]",
                 @"[[EZDate date] dateAtNextOccurrenceOfWeekday:6]",
                 @"[[EZDate date] dateAtNextOccurrenceOfMonth:7 day:4]",
                 @"[[EZDate date] dateAtNextOccurrenceOfHour:6 minute:45]",
                 @"[EZDate date][@\"EEEE, MMMM d, y\"]",
                 @"[[EZDate date] stringWithDateFormat:@\"EEEE, MMMM d, y\"]",
                 @"[[EZDate date] prettyString]",
                 @"[[EZDate dateWithYear:2013 month:7 day:4] prettyElapsedTimeString]"
                   ];
    _results = @[
                 [EZDate date],
                 [EZDate dateWithTimeIntervalSinceNow:12345678],
                 [EZDate dateWithTimeIntervalSinceReferenceDate:12345678],
                 [EZDate dateWithTimeIntervalSince1970:12345678],
                 [EZDate dateWithTimeInterval:12345678 sinceDate:[NSDate date]],
                 [EZDate distantFuture],
                 [EZDate distantPast],
                 [[EZDate alloc] init],
                 [[EZDate alloc] initWithTimeIntervalSinceNow:12345678],
                 [[EZDate alloc] initWithTimeIntervalSinceReferenceDate:12345678],
                 [[EZDate alloc] initWithTimeIntervalSince1970:12345678],
                 [[EZDate alloc] initWithTimeInterval:12345678 sinceDate:[NSDate date]],
                 [EZDate dateWithNSDate:[NSDate date]],
                 [[EZDate alloc] initWithNSDate:[NSDate date]],
                 [EZDate dateWithNSDate:[NSDate date] calendarIdentifier:NSGregorianCalendar timeZone:[NSTimeZone defaultTimeZone]],
                 [[EZDate alloc] initWithNSDate:[NSDate date] calendarIdentifier:NSGregorianCalendar timeZone:[NSTimeZone defaultTimeZone]],
                 [EZDate dateWithYear:2013 month:7 day:4],
                 [EZDate dateWithYear:2013 month:7 day:4 hour:22 minute:5 second:7],
                 [EZDate dateWithHour:8 minute:33 second:47],
                 [EZDate dateWithYear:2012 month:11 ordinal:1 weekday:2],
                 [[EZDate date] dateByAddingYears:1 months:1 days:-1],
                 [[EZDate date] dateByAddingHours:-1 minutes:1 seconds:20],
                 [[EZDate date] dateByAddingTimeInterval:12345678],
                 [[EZDate date] description],
                 [[EZDate date] dateAtNextOccurrenceOfWeekday:6],
                 [[EZDate date] dateAtNextOccurrenceOfMonth:7 day:4],
                 [[EZDate date] dateAtNextOccurrenceOfHour:6 minute:45],
                 [EZDate date][@"EEEE, MMMM d, y"],
                 [[EZDate date] stringWithDateFormat:@"EEEE, MMMM d, y"],
                 [[EZDate date] prettyString],
                 [[EZDate dateWithYear:2013 month:7 day:4] prettyElapsedTimeString]
                     ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.detailTextLabel.text = [_results[indexPath.row] description];
    cell.textLabel.text = _codes[indexPath.row];
    
    return cell;
}

@end
