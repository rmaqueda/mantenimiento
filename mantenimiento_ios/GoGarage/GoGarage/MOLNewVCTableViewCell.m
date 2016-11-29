//
//  MOLNewVCTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 13/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLNewVCTableViewCell.h"

@interface MOLNewVCTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *selectedOption;

@end

@implementation MOLNewVCTableViewCell

#pragma mark - MOLDrawableCellDataSource Protocol

+ (NSString *)reuseIndentifier {
    return @"NewVC";
}

- (void)drawCell {
    self.label.text = NSLocalizedString(self.property, nil);
    id<APIDrawableObject> selectedObject = [self.object valueForKey:self.property];
    if (selectedObject) {
        self.selectedOption.text = selectedObject.title;
        self.selectedOption.textColor = [UIColor blackColor];
    } else {
        self.selectedOption.text = self.placeholder;
        self.selectedOption.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
    }
}

#pragma mark - Cell Options

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        UITableViewController *tableViewController = (UITableViewController *)[self myTableview].delegate;
        [tableViewController performSegueWithIdentifier:@"selectOption" sender:self];
    }
}

@end
