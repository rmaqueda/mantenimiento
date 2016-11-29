//
//  MOLSelectDateTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 11/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLSelectDateTableViewCell.h"

@interface MOLSelectDateTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, getter=isVisible) BOOL visible;

@end

@implementation MOLSelectDateTableViewCell

+ (NSString *)reuseIndentifier {
    return @"SelectOption";
}

- (void)awakeFromNib {
    NSDate *date = [self.object valueForKey:self.property];
    if (date) {
        self.datePicker.date = date;
    }

    [self.datePicker addTarget:self action:@selector(dateDidChenged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        
        if (self.isVisible) {
            [[self myTableview] reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.contentViewHeight.constant = 0;
            self.visible = NO;
        } else {
            self.contentViewHeight.constant = 197;
            self.visible = YES;
        }

    } else {
        self.contentViewHeight.constant = 0;
    }
}

- (void)drawCell {
    self.label.text = NSLocalizedString(self.property, nil);
    
    if ([self.object valueForKey:self.property]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.detail.text = [dateFormatter stringFromDate:[self.object valueForKey:self.property]];
        self.detail.textColor = [UIColor blackColor];
    } else {
        self.detail.text = self.placeholder;
    }
    self.detail.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
}

- (void)dateDidChenged:(id)sender {
    UIDatePicker *piker = sender;
    [self.object setValue:piker.date forKey:self.property];
    [self drawCell];
}

@end
