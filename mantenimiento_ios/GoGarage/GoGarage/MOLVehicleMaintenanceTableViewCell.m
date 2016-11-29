//
//  MOLVehicleMaintenanceTableViewCell.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 22/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLVehicleMaintenanceTableViewCell.h"
#import "MOLMaintenanceBook.h"
#import "MOLService.h"

@interface MOLVehicleMaintenanceTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *serviceType;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *kilometers;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end

@implementation MOLVehicleMaintenanceTableViewCell

- (void)drawCellWithMaintenance:(MOLMaintenanceBook *)maintenance
                        service:(MOLService *)service
{
    self.serviceType.text = service.type;
    self.price.text = [NSString stringWithFormat:@"%@ €", [[maintenance.class moneyFormatter] stringFromNumber:maintenance.price]];
    
    self.kilometers.text = [NSString stringWithFormat:@"%@ km", [[maintenance.class moneyFormatter] stringFromNumber:maintenance.kilometers]];
    self.date.text = [[MOLMaintenanceBook dateFormatter] stringFromDate:maintenance.date];
}

@end
