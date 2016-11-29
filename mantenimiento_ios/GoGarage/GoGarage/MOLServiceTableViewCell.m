//
//  MOLServiceTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 22/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLServiceTableViewCell.h"
#import "MOLService.h"

@interface MOLServiceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *serviceType;
@property (weak, nonatomic) IBOutlet UILabel *serviceDescription;

@end

@implementation MOLServiceTableViewCell

- (void)drawCellWithService:(MOLService *)service {
    self.serviceType.text = service.type;
    self.serviceDescription.text = service.serviceDescription;
    self.serviceDescription.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
}

@end
