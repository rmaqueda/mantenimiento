//
//  MOLCarTableViewCell.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 22/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

@class MOLVehicle;

@interface MOLVehicleTableViewCell : UITableViewCell

- (void)drawCellWithVehicle:(MOLVehicle *)vehicle;

@end
