//
//  MOLEnterValueTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 12/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLEnterValueTableViewCell.h"

static CGFloat const ksuffixHeigh = 21.0;

@interface MOLEnterValueTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *suffixLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suffixWith;

@end

@implementation MOLEnterValueTableViewCell

+ (NSString *)reuseIndentifier {
    return @"EnterValue";
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField.delegate = self;
    self.suffixWith.constant = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.textField becomeFirstResponder];
    }
}

- (void)drawCell {
 
    NSNumber *value = [self.object valueForKey:self.property];
    NSString *valueString = [[self.object.class moneyFormatter] stringFromNumber:value];
    
    if (valueString.length) {
        self.suffixWith.constant = ksuffixHeigh;
    }

    self.label.text = NSLocalizedString(self.property, nil);
    
    self.textField.text = valueString;
    self.textField.placeholder = self.placeholder;
    
    self.suffixLabel.text = self.suffix;
    self.suffixLabel.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.suffixWith.constant = ksuffixHeigh;
    NSNumber *originalNumber = [[self.object.class moneyFormatter] numberFromString:textField.text];
    textField.text = [originalNumber stringValue];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!textField.text.length) {
        self.suffixWith.constant = 0;
    }
    NSNumber *number = [[self.object.class moneyFormatter] numberFromString:textField.text];
    textField.text = [[self.object.class moneyFormatter] stringFromNumber:number];
    
    NSNumber *roundedNumber = [[self.object.class moneyFormatter] numberFromString:textField.text];
    [self.object setValue:roundedNumber forKey:self.property];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSNumber *number = [[self.object.class moneyFormatter] numberFromString:newText];
    
    if (newText.length && !number) {
        return NO;
    } else {
        [self.object setValue:number forKey:self.property];
        return YES;
    }
}

@end
