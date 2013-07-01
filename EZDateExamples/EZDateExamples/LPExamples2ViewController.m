//
//  LPExamples2ViewController.m
//  EZDateExamples
//
//  Created by Lane Phillips on 6/29/13.
//  Copyright (c) 2013 Milk LLC. All rights reserved.
//

#import "LPExamples2ViewController.h"
#import "EZDate.h"

@interface LPExamples2ViewController ()

@property (nonatomic) NSArray* codes;
@property (nonatomic) NSArray* results;

@end

@implementation LPExamples2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _codes = @[
               @"[[EZDate date] year]",
               @"[[EZDate date] month]",
               @"[[EZDate date] day]",
               @"[[EZDate date] hour]",
               @"[[EZDate date] minute]",
               @"[[EZDate date] second]",
               @"[[EZDate date] era]",
               @"[[EZDate date] week]",
               @"[[EZDate date] weekday]",
               @"[[EZDate date] weekdayOrdinal]",
               @"[[EZDate date] quarter]",
               @"[[EZDate date] weekOfMonth]",
               @"[[EZDate date] weekOfYear]",
               @"[[EZDate date] yearForWeekOfYear]",
               @"[EZDate date][@\"EEEE, MMMM d, y\"]",
               @"[[EZDate date] stringWithDateFormat:@\"EEEE, MMMM d, y\"]",
               @"[[EZDate date] prettyString]",
               @"[[EZDate dateWithYear:2013 month:7 day:4] prettyElapsedTimeString]"
               ];
    _results = @[
                 @([[EZDate date] year]),
                 @([[EZDate date] month]),
                 @([[EZDate date] day]),
                 @([[EZDate date] hour]),
                 @([[EZDate date] minute]),
                 @([[EZDate date] second]),
                 @([[EZDate date] era]),
                 @([[EZDate date] week]),
                 @([[EZDate date] weekday]),
                 @([[EZDate date] weekdayOrdinal]),
                 @([[EZDate date] quarter]),
                 @([[EZDate date] weekOfMonth]),
                 @([[EZDate date] weekOfYear]),
                 @([[EZDate date] yearForWeekOfYear]),
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
