//
//  MOLSelectImageTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 11/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLSelectImageTableViewCell.h"
#import "MOLImagePicker.h"

@interface MOLSelectImageTableViewCell () <MOLImagePickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *miniImage;
@property (nonatomic, getter=isVisible) BOOL visible;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *miniImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *miniImageTrailing;

@end

@implementation MOLSelectImageTableViewCell

+ (NSString *)reuseIndentifier {
    return @"SelectImage";
}

- (void)awakeFromNib {
    if ([self.object valueForKey:self.property]) {
        self.hasImage = YES;
        self.miniImageWidth.constant = 24;
        self.miniImageTrailing.constant = 8;
        self.image.image = [self.object valueForKey:self.property];
        self.miniImage.image = [self.object valueForKey:self.property];
    } else {
        self.miniImageWidth.constant = 0;
        self.miniImageTrailing.constant = 0;
    }
    
    self.contentViewHeight.constant = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        
        if (![self.object valueForKey:self.property]) {
            [self showImagePicker];
        } else {
            
            if (self.isVisible) {
                self.contentViewHeight.constant = 0;
                self.image.hidden = YES;
                self.visible = NO;
                [[self myTableview] reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                self.visible = YES;
                self.hasImage = YES;
                self.contentViewHeight.constant = 191;
                self.image.hidden = NO;
                [self showImagePicker];
            }
        }
    } else {
        self.contentViewHeight.constant = 0;
    }
}

- (void)drawCell {
    self.label.text = NSLocalizedString(self.property, nil);
    
    if ([self.object valueForKey:self.property]) {
        self.hasImage = YES;
        self.image.image = [self.object valueForKey:self.property];
        self.miniImage.image = [self.object valueForKey:self.property];
        self.miniImageTrailing.constant = 8;
        self.miniImageWidth.constant = 24;
        self.detail.text = NSLocalizedString(@"Tap to change", nil);
    } else {
        self.detail.text = self.placeholder;
    }
    
    self.detail.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
}

- (void)showImagePicker {
    MOLImagePicker *imagepicker = [[MOLImagePicker alloc] init];
    imagepicker.delegate = self;
    
    UITableViewController *tableViewController = (UITableViewController *)[self myTableview].delegate;
    
    [tableViewController addChildViewController:imagepicker];
    [tableViewController.view addSubview:imagepicker.view];
}

- (void)imagePikerDelegate:(MOLImagePicker *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker.view removeFromSuperview];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    self.hasImage = YES;
    self.image.image = image;
    self.miniImage.image = image;
    self.miniImageTrailing.constant = 8;
    self.miniImageWidth.constant = 24;
    
    [self.object setValue:image forKey:self.property];
    [[self myTableview] reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)imagePickerControllerDidCancel:(MOLImagePicker *)picker {
    [picker.view removeFromSuperview];
}

@end
