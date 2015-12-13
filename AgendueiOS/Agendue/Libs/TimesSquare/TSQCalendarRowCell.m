//
//  TSQCalendarRowCell.m
//  TimesSquare
//
//  Created by Jim Puls on 11/14/12.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "TSQCalendarRowCell.h"
#import "TSQCalendarView.h"


@interface TSQCalendarRowCell ()

@property (nonatomic, strong) NSArray *notThisMonthButtons;
@property (nonatomic, strong) DateButton *todayButton;
@property (nonatomic, strong) DateButton *selectedButton;

@property (nonatomic, assign) NSInteger indexOfTodayButton;
@property (nonatomic, assign) NSInteger indexOfSelectedButton;

@property (nonatomic, strong) NSDateFormatter *dayFormatter;
@property (nonatomic, strong) NSDateFormatter *accessibilityFormatter;

@property (nonatomic, strong) NSDateComponents *todayDateComponents;
@property (nonatomic) NSInteger monthOfBeginningDate;

@end


@implementation TSQCalendarRowCell

- (id)initWithCalendar:(NSCalendar *)calendar reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithCalendar:calendar reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)configureButton:(DateButton *)button;
{
    button.titleLabel.font = [UIFont boldSystemFontOfSize:19.f];
    button.titleLabel.shadowOffset = self.shadowOffset;
    button.adjustsImageWhenDisabled = NO;
    [button setTitleColor:self.textColor forState:UIControlStateNormal];
    [button setTitleShadowColor:UIColorFromRGB(0xddddddd) forState:UIControlStateDisabled];
    [button setTitleShadowColor: UIColorFromRGB(0xffab26) forState:UIControlStateSelected];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor: [UIColor whiteColor] forState:UIControlStateSelected];
}

- (void)createDayButtons;
{
    NSMutableArray *dayButtons = [NSMutableArray arrayWithCapacity:self.daysInWeek];
    for (NSUInteger index = 0; index < self.daysInWeek; index++) {
        DateButton *button = [[DateButton alloc] initWithFrame:self.contentView.bounds];
        [button addTarget:self action:@selector(dateButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [dayButtons addObject:button];
        [self.contentView addSubview:button];
        [self configureButton:button];
        [button setTitleColor:UIColorFromRGB(0xdddddd) forState:UIControlStateDisabled];
    }
    self.dayButtons = dayButtons;
}

- (void)createNotThisMonthButtons;
{
    NSMutableArray *notThisMonthButtons = [NSMutableArray arrayWithCapacity:self.daysInWeek];
    for (NSUInteger index = 0; index < self.daysInWeek; index++) {
        DateButton *button = [[DateButton alloc] initWithFrame:self.contentView.bounds];
        [notThisMonthButtons addObject:button];
        [self.contentView addSubview:button];
        [self configureButton:button];

        button.enabled = NO;
        [button setTitleColor:UIColorFromRGB(0xeeeeee) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xeeeeee) forState:UIControlStateDisabled];
        [button setTitleColor:UIColorFromRGB(0xeeeeee) forState:UIControlStateSelected];

    }
    self.notThisMonthButtons = notThisMonthButtons;
}

- (void)createTodayButton;
{
    self.todayButton = [[DateButton alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.todayButton];
    [self configureButton:self.todayButton];
    [self.todayButton addTarget:self action:@selector(todayButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    [self.todayButton setTitleColor:UIColorFromRGB(0x3692d5) forState:UIControlStateNormal];
    [self.todayButton setBackgroundImage:[self todayBackgroundImage] forState:UIControlStateNormal];

}

- (void)createSelectedButton;
{
    self.selectedButton = [[DateButton alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.selectedButton];
    [self configureButton:self.selectedButton];
    
    [self.selectedButton setAccessibilityTraits:UIAccessibilityTraitSelected|self.selectedButton.accessibilityTraits];
    
    self.selectedButton.enabled = NO;
    [self.selectedButton setTitleColor:UIColorFromRGB(0xffab26) forState:UIControlStateNormal];
    [self.selectedButton setBackgroundImage:[self selectedBackgroundImage] forState:UIControlStateNormal];
    [self.selectedButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.indexOfSelectedButton = -1;
}

- (void)setBeginningDate:(NSDate *)date;
{
    _beginningDate = date;
    
    if (!self.dayButtons) {
        [self createDayButtons];
        [self createNotThisMonthButtons];
        [self createTodayButton];
        [self createSelectedButton];
    }

    NSDateComponents *offset = [NSDateComponents new];
    offset.day = 1;

    self.todayButton.hidden = YES;
    self.indexOfTodayButton = -1;
    self.selectedButton.hidden = YES;
    self.indexOfSelectedButton = -1;
    
    for (NSUInteger index = 0; index < self.daysInWeek; index++) {
        NSString *title = [self.dayFormatter stringFromDate:date];
        NSString *accessibilityLabel = [self.accessibilityFormatter stringFromDate:date];
        [self.dayButtons[index] setDate:date];
        [self.dayButtons[index] setTitle:title forState:UIControlStateNormal];
        [self.dayButtons[index] setAccessibilityLabel:accessibilityLabel];
        [self.notThisMonthButtons[index] setDate:date];
        [self.notThisMonthButtons[index] setTitle:title forState:UIControlStateNormal];
        [self.notThisMonthButtons[index] setTitle:title forState:UIControlStateDisabled];
        [self.notThisMonthButtons[index] setAccessibilityLabel:accessibilityLabel];
        
        NSDateComponents *thisDateComponents = [self.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
        
        [self.dayButtons[index] setHidden:YES];
        [self.notThisMonthButtons[index] setHidden:YES];

        NSInteger thisDayMonth = thisDateComponents.month;
        if (self.monthOfBeginningDate != thisDayMonth) {
            [self.notThisMonthButtons[index] setHidden:NO];
        } else {

            if ([self.todayDateComponents isEqual:thisDateComponents]) {
                self.todayButton.hidden = NO;
                [self.todayButton setTitle:title forState:UIControlStateNormal];
                [self.todayButton setDate:date];
                [self.todayButton setAccessibilityLabel:accessibilityLabel];
                self.indexOfTodayButton = index;
            } else {
                DateButton *button = self.dayButtons[index];
                button.enabled = ![self.calendarView.delegate respondsToSelector:@selector(calendarView:shouldSelectDate:)] || [self.calendarView.delegate calendarView:self.calendarView shouldSelectDate:date];
                button.hidden = NO;
            }
        }

        date = [self.calendar dateByAddingComponents:offset toDate:date options:0];
    }
}

- (void)setBottomRow:(BOOL)bottomRow;
{
    UIImageView *backgroundImageView = (UIImageView *)self.backgroundView;
    if ([backgroundImageView isKindOfClass:[UIImageView class]] && _bottomRow == bottomRow) {
        return;
    }

    _bottomRow = bottomRow;
    
    self.backgroundView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    
    [self setNeedsLayout];
}

- (IBAction)dateButtonPressed:(id)sender;
{
    NSDateComponents *offset = [NSDateComponents new];
    offset.day = [self.dayButtons indexOfObject:sender];
    NSDate *selectedDate = [self.calendar dateByAddingComponents:offset toDate:self.beginningDate options:0];
    self.calendarView.selectedDate = selectedDate;
}

- (IBAction)todayButtonPressed:(id)sender;
{
    NSDateComponents *offset = [NSDateComponents new];
    offset.day = self.indexOfTodayButton;
    NSDate *selectedDate = [self.calendar dateByAddingComponents:offset toDate:self.beginningDate options:0];
    self.calendarView.selectedDate = selectedDate;
}

- (void)layoutSubviews;
{
    if (!self.backgroundView) {
        [self setBottomRow:NO];
    }
    
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
}

- (void)layoutViewsForColumnAtIndex:(NSUInteger)index inRect:(CGRect)rect;
{
    DateButton *dayButton = self.dayButtons[index];
    DateButton *notThisMonthButton = self.notThisMonthButtons[index];
    
    dayButton.frame = rect;
    notThisMonthButton.frame = rect;

    if (self.indexOfTodayButton == (NSInteger)index) {
        self.todayButton.frame = rect;
    }
    if (self.indexOfSelectedButton == (NSInteger)index) {
        self.selectedButton.frame = rect;
    }
}

- (void)selectColumnForDate:(NSDate *)date;
{
    if (!date && self.indexOfSelectedButton == -1) {
        return;
    }

    NSInteger newIndexOfSelectedButton = -1;
    if (date) {
        NSInteger thisDayMonth = [self.calendar components:NSMonthCalendarUnit fromDate:date].month;
        if (self.monthOfBeginningDate == thisDayMonth) {
            newIndexOfSelectedButton = [self.calendar components:NSDayCalendarUnit fromDate:self.beginningDate toDate:date options:0].day;
            if (newIndexOfSelectedButton >= (NSInteger)self.daysInWeek) {
                newIndexOfSelectedButton = -1;
            }
        }
    }

    self.indexOfSelectedButton = newIndexOfSelectedButton;
    
    if (newIndexOfSelectedButton >= 0) {
        self.selectedButton.hidden = NO;
        NSString *newTitle = [self.dayButtons[newIndexOfSelectedButton] currentTitle];
        [self.selectedButton setDate:date];
        [self.selectedButton setTitle:newTitle forState:UIControlStateNormal];
        [self.selectedButton setTitle:newTitle forState:UIControlStateDisabled];
        [self.selectedButton setAccessibilityLabel:[self.dayButtons[newIndexOfSelectedButton] accessibilityLabel]];
    } else {
        self.selectedButton.hidden = YES;
    }
    
    [self setNeedsLayout];
}

- (NSDateFormatter *)dayFormatter;
{
    if (!_dayFormatter) {
        _dayFormatter = [NSDateFormatter new];
        _dayFormatter.calendar = self.calendar;
        _dayFormatter.dateFormat = @"d";
    }
    return _dayFormatter;
}

- (NSDateFormatter *)accessibilityFormatter;
{
    if (!_accessibilityFormatter) {
        _accessibilityFormatter = [NSDateFormatter new];
        _accessibilityFormatter.calendar = self.calendar;
        _accessibilityFormatter.dateStyle = NSDateFormatterLongStyle;
    }
    return _accessibilityFormatter;
}

- (NSInteger)monthOfBeginningDate;
{
    if (!_monthOfBeginningDate) {
        _monthOfBeginningDate = [self.calendar components:NSMonthCalendarUnit fromDate:self.firstOfMonth].month;
    }
    return _monthOfBeginningDate;
}

- (void)setFirstOfMonth:(NSDate *)firstOfMonth;
{
    [super setFirstOfMonth:firstOfMonth];
    self.monthOfBeginningDate = 0;
}

- (NSDateComponents *)todayDateComponents;
{
    if (!_todayDateComponents) {
        self.todayDateComponents = [self.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    }
    return _todayDateComponents;
}

@end
