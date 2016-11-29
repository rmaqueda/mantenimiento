//
//  MOLEnterTextTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 11/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLEnterTextTableViewCell.h"

@interface MOLEnterTextTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation MOLEnterTextTableViewCell

+ (NSString *)reuseIndentifier {
    //TODO: Constante en superclase y intentar subirlo
    return @"EnterText";
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        [self.textField becomeFirstResponder];
    }
}

- (void)drawCell {
    self.label.text = NSLocalizedString(self.property, nil);
    self.textField.text = [self.object valueForKey:self.property];
    self.textField.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
    self.textField.placeholder = self.placeholder;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:charSet];
    if ([trimmedString isEqualToString:@""]) {
        textField.text = nil;
        [self.object setValue:nil forKey:self.property];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self.object setValue:newText forKey:self.property];

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {    
    id cell = [[self myTableview] cellForRowAtIndexPath:[NSIndexPath indexPathForItem:self.indexPath.row + 1 inSection:self.indexPath.section]];
    if ([cell isKindOfClass:[MOLEnterTextTableViewCell class]] ) {
        MOLEnterTextTableViewCell *entercel = cell;
        [entercel.textField becomeFirstResponder];
    }
    
    return YES;
}

@end
