//
//  MOLCarTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 22/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLVehicleTableViewCell.h"
#import "MOLVehicle.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface MOLVehicleTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *vehicleImage;
@property (weak, nonatomic) IBOutlet UILabel *vehicleNick;
@property (weak, nonatomic) IBOutlet UILabel *vehicleBrandModel;

@end

@implementation MOLVehicleTableViewCell

- (void)drawCellWithVehicle:(MOLVehicle *)vehicle {

    self.vehicleImage.layer.cornerRadius = 10;
    self.vehicleImage.layer.masksToBounds = YES;
    
    [self.vehicleImage sd_setImageWithURL:[vehicle URLfirstImage]
                     placeholderImage:[UIImage imageNamed:@"vehicle"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         vehicle.image = image;
     }];
    self.vehicleNick.text = vehicle.nick;
    self.vehicleBrandModel.text = [NSString stringWithFormat:@"%@, %@", vehicle.brand, vehicle.model];
    self.vehicleBrandModel.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.84 alpha:1];
}

@end
