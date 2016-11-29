//
//  MOLVehicleViewController.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 04/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLVehicleViewController.h"
#import "MOLVehicleMaintenancesViewController.h"
#import "MOLVehicle.h"
#import "MOLImage.h"
#import "MOLPaginationManager.h"
#import "MOLNetworkManager.h"
#import "MOLEditableModelTableViewController.h"
#import "MOLVehicleTableViewCell.h"

@implementation MOLVehicleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.table registerNib:[UINib nibWithNibName:@"MOLVehicleTableViewCell" bundle:nil] forCellReuseIdentifier:@"vehicleCell"];
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    self.emptyTextLabel = @"No vehicles created yet. \n Please, tap on the plus button above.";
    self.objects = [self.dataHelper objectsForClass:MOLVehicle.class].mutableCopy;
    [self.table reloadData];
}

#pragma mark - UitableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MOLVehicleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vehicleCell"];
    MOLVehicle *vehicle = self.objects[indexPath.row];
    [cell drawCellWithVehicle:vehicle];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"vehicleDetails" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"vehicleDetails"]) {
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        MOLVehicle *vehicle = self.objects[indexPath.row];
        
        MOLVehicleMaintenancesViewController *vehicleDetailVC = [segue destinationViewController];
        vehicleDetailVC.vehicle = vehicle;
        vehicleDetailVC.title = [NSString stringWithFormat:@"Maintenances"];
    }
    
    if ([[segue identifier] isEqualToString:@"newVehicle"]) {
        MOLEditableModelTableViewController *newVehicleVC = [segue destinationViewController];
        newVehicleVC.modelObject = [[MOLVehicle alloc] init];
        newVehicleVC.title = @"New Vehicle";
    }
}

@end
