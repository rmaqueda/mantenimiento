//
//  MOLLocalTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 22/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLLocalTableViewCell.h"
#import "MOLLocal.h"

@interface MOLLocalTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *contact;

@end

@implementation MOLLocalTableViewCell

- (void)drawCellWithLocal:(MOLLocal *)local {
    self.name.text = local.name;
    self.contact.text = [NSString stringWithFormat:@"Contact: %@", local.contact];
    self.contact.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
}

@end
