//
//  MOLEnterDescriptionTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 11/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLEnterDescriptionTableViewCell.h"

@interface MOLEnterDescriptionTableViewCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@end

@implementation MOLEnterDescriptionTableViewCell

+ (NSString *)reuseIndentifier {
    return @"EnterDescription";
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.descriptionText.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.descriptionText becomeFirstResponder];
    }
}

- (void)drawCell {
    self.label.text = NSLocalizedString(self.property, nil);
    NSString *valueDescription = [self.object valueForKey:self.property];
    
    if (valueDescription.length) {
        self.descriptionText.text = valueDescription;
        self.descriptionText.textColor = [UIColor blackColor];
    } else {
        self.descriptionText.text = self.placeholder;
        self.descriptionText.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
    }
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:self.placeholder]) {
        [self performSelector:@selector(setCursorToBeginning:) withObject:textView afterDelay:0.0];
    }
}

- (void)setCursorToBeginning:(UITextView *)textView {
    textView.selectedRange = NSMakeRange(0, 0);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self.descriptionText.text isEqualToString:self.placeholder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (!self.descriptionText.text.length) {
        textView.text = self.placeholder;
        textView.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
    }
    
    if (![self.descriptionText.text isEqualToString:self.placeholder]) {
         [self.object setValue:textView.text forKey:self.property];
    }
}

@end
