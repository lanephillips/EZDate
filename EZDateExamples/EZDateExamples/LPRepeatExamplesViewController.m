//
//  LPRepeatExamplesViewController.m
//  EZDateExamples
//
//  Created by Lane Phillips on 7/1/13.
//  Copyright (c) 2013 Milk LLC. All rights reserved.
//

#import "LPRepeatExamplesViewController.h"
#import "EZDate.h"

typedef NS_ENUM(int, LPRepeat) {
    LPRepeatDaily,
    LPRepeatWeekly,
    LPRepeatMonthly,
    LPRepeatYearly
};

@interface LPRepeatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *repeatSeg;

@end

@interface LPStrideCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *strideLbl;
@property (weak, nonatomic) IBOutlet UIStepper *strideStep;

@end

@interface LPWeeklyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *sunBtn;
@property (weak, nonatomic) IBOutlet UIButton *monBtn;
@property (weak, nonatomic) IBOutlet UIButton *tueBtn;
@property (weak, nonatomic) IBOutlet UIButton *wedBtn;
@property (weak, nonatomic) IBOutlet UIButton *thuBtn;
@property (weak, nonatomic) IBOutlet UIButton *friBtn;
@property (weak, nonatomic) IBOutlet UIButton *satBtn;

@end

@interface LPMonthlyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *monthDaySeg;

@end

@interface LPRepeatExamplesViewController ()
{
    LPRepeat _repeatType;
    int _stride;
    int _weekdayMask;
    BOOL _repeatByDayOfWeek;
    EZDate* _startsOn;
    NSMutableArray* _dates;
}
@end

@implementation LPRepeatExamplesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // defaults
    _startsOn = [EZDate date];
    _repeatType = LPRepeatDaily;
    _stride = 1;
    _repeatByDayOfWeek = NO;
    _weekdayMask = 0;
    
    switch (_startsOn.weekday) {
        case 1: _weekdayMask = EZSunday; break;
        case 2: _weekdayMask = EZMonday; break;
        case 3: _weekdayMask = EZTuesday; break;
        case 4: _weekdayMask = EZWednesday; break;
        case 5: _weekdayMask = EZThursday; break;
        case 6: _weekdayMask = EZFriday; break;
        case 7: _weekdayMask = EZSaturday; break;
    }
    
    [self generateDates];
}

-(void)generateDates
{
    _dates = [NSMutableArray arrayWithCapacity:20];
    
    void (^block)(EZDate *date, BOOL *stop) = ^(EZDate *date, BOOL *stop) {
        [_dates addObject:date];
    };
    
    switch (_repeatType) {
        case LPRepeatDaily:
            [_startsOn repeatEvery:_stride daysEndingAfter:20 occurrencesUsingBlock:block];
            break;
        case LPRepeatWeekly:
            [_startsOn repeatEvery:_stride weeksOnWeekdays:_weekdayMask endingAfter:20 occurrencesUsingBlock:block];
            break;
        case LPRepeatMonthly:
            if (_repeatByDayOfWeek)
                [_startsOn repeatOrdinalEvery:_stride monthsEndingAfter:20 occurrencesUsingBlock:block];
            else
                [_startsOn repeatEvery:_stride monthsEndingAfter:20 occurrencesUsingBlock:block];
            break;
        case LPRepeatYearly:
            [_startsOn repeatEvery:_stride yearsEndingAfter:20 occurrencesUsingBlock:block];
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
        return _dates.count;
    
    if (/*_repeatType == LPRepeatWeekly ||*/ _repeatType == LPRepeatMonthly)    // TODO: 
        return 5;

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int xtra = (/*_repeatType == LPRepeatWeekly ||*/ _repeatType == LPRepeatMonthly)? 1 : 0;    // TODO: 
    
    if (indexPath.section == 1) {
        EZDate* d = _dates[indexPath.row];
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
        cell.textLabel.text = d.description;
        return cell;
    }
    
    if (indexPath.row == 0) {
        LPRepeatCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RepeatCell" forIndexPath:indexPath];
        cell.repeatSeg.selectedSegmentIndex = (int)_repeatType;
        return cell;
    }
    
    if (indexPath.row == 1) {
        LPStrideCell* cell = [tableView dequeueReusableCellWithIdentifier:@"StrideCell" forIndexPath:indexPath];
        cell.strideLbl.text = [NSString stringWithFormat:@"Every %d %@%@", _stride,
                               _repeatType == LPRepeatDaily? @"day" : (_repeatType == LPRepeatWeekly? @"week" : (_repeatType == LPRepeatMonthly? @"month" : @"year")),
                               _stride > 1? @"s" : @""];
        cell.strideStep.value = _stride;
        return cell;
    }
    
    // TODO: figure out why this isn't working
//    if (indexPath.row == 2 && _repeatType == LPRepeatWeekly) {
//        LPWeeklyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WeeklyCell" forIndexPath:indexPath];
//        cell.sunBtn.selected = (_weekdayMask & EZSunday);
//        cell.monBtn.selected = (_weekdayMask & EZMonday);
//        cell.tueBtn.selected = (_weekdayMask & EZTuesday);
//        cell.wedBtn.selected = (_weekdayMask & EZWednesday);
//        cell.thuBtn.selected = (_weekdayMask & EZThursday);
//        cell.friBtn.selected = (_weekdayMask & EZFriday);
//        cell.satBtn.selected = (_weekdayMask & EZSaturday);
//        cell.sunBtn.tag = EZSunday;
//        cell.monBtn.tag = EZMonday;
//        cell.tueBtn.tag = EZTuesday;
//        cell.wedBtn.tag = EZWednesday;
//        cell.thuBtn.tag = EZThursday;
//        cell.friBtn.tag = EZFriday;
//        cell.satBtn.tag = EZSaturday;
//        return cell;
//    }
    
    if (indexPath.row == 2 && _repeatType == LPRepeatMonthly) {
        LPMonthlyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MonthlyCell" forIndexPath:indexPath];
        cell.monthDaySeg.selectedSegmentIndex = _repeatByDayOfWeek? 1 : 0;
        return cell;
    }
    
    if (indexPath.row - xtra == 2) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"StartCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"Starts on: %@", _startsOn];
        return cell;
    }
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EndCell" forIndexPath:indexPath];
    return cell;
}

- (IBAction)changeRepeat:(id)sender
{
    _repeatType = [(UISegmentedControl*)sender selectedSegmentIndex];
    [self generateDates];
}

- (IBAction)changeStride:(id)sender
{
    _stride = [(UIStepper*)sender value];
    [self generateDates];
}

- (IBAction)changeWeekdayMask:(id)sender
{
    // TODO: figure out why this isn't working
//    UIButton* b = sender;
//    // mask was stored in the tag
//    _weekdayMask ^= b.tag;
//    [self generateDates];
}

- (IBAction)changeMonthDay:(id)sender
{
    _repeatByDayOfWeek = [(UISegmentedControl*)sender selectedSegmentIndex];
    [self generateDates];
}

@end

@implementation LPRepeatCell

@end

@implementation LPStrideCell

@end

@implementation LPWeeklyCell

@end

@implementation LPMonthlyCell

@end
