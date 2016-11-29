//
//  MOLServicesViewController.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 04/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLServicesViewController.h"
#import "MOLEditableModelTableViewController.h"
#import "MOLPaginationManager.h"
#import "MOLService.h"
#import "MOLServiceTableViewCell.h"

@implementation MOLServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.table registerNib:[UINib nibWithNibName:@"MOLServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"serviceCell"];
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    self.emptyTextLabel = @"No services created yet. \n Please, tap on the plus button above.";
    self.objects = [self.dataHelper objectsForClass:MOLService.class].mutableCopy;
    [self.table reloadData];
}

#pragma mark - UitableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MOLServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serviceCell"];
    MOLService *service = self.objects[indexPath.row];
    [cell drawCellWithService:service];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"serviceDetails" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"serviceDetails"]) {
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];

        MOLEditableModelTableViewController *newServiceVC = [segue destinationViewController];
        newServiceVC.modelObject = self.objects[indexPath.row];
    }
    
    if ([[segue identifier] isEqualToString:@"newService"]) {
        MOLEditableModelTableViewController *newVehicleVC = [segue destinationViewController];
        newVehicleVC.modelObject = [[MOLService alloc] init];
    }
}

@end
