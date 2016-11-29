//
//  MOLLocalsViewController.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 04/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLLocalViewController.h"
#import "MOLLocalTableViewCell.h"
#import "MOLPaginationManager.h"
#import "MOLLocal.h"
#import "MOLEditableModelTableViewController.h"
#import "MOLLocalTableViewCell.h"

@implementation MOLLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.table registerNib:[UINib nibWithNibName:@"MOLLocalTableViewCell" bundle:nil] forCellReuseIdentifier:@"localCell"];
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    self.emptyTextLabel = @"No locals created yet. \n Please, tap on the plus button above.";
    self.objects = [self.dataHelper objectsForClass:MOLLocal.class].mutableCopy;
    [self.table reloadData];
}

#pragma mark - UitableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MOLLocalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"localCell"];
    MOLLocal *local = self.objects[indexPath.row];
    [cell drawCellWithLocal:local];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"localDetails" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"localDetails"]) {
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        
        MOLEditableModelTableViewController *localDetail = [segue destinationViewController];
        localDetail.modelObject = self.objects[indexPath.row];
    }
    
    if ([[segue identifier] isEqualToString:@"newLocal"]) {
        MOLEditableModelTableViewController *newVehicleVC = [segue destinationViewController];
        newVehicleVC.modelObject = [[MOLLocal alloc] init];
    }
}

@end
