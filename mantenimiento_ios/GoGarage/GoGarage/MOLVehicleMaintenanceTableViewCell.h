//
//  MOLVehicleMaintenanceTableViewCell.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 22/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

@class MOLMaintenanceBook;
@class MOLService;

@interface MOLVehicleMaintenanceTableViewCell : UITableViewCell

- (void)drawCellWithMaintenance:(MOLMaintenanceBook *)maintenance
                        service:(MOLService *)service;

@end
