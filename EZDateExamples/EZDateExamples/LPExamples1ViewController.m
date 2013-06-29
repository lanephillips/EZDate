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
                   @"[EZDate date]"
                   ];
    _results = @[
                     [EZDate date]
                     ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _codes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [_results[indexPath.row] description];
    cell.detailTextLabel.text = _codes[indexPath.row];
    
    return cell;
}

@end
