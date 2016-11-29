//
//  MOLVehicleDetailViewController.m
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 07/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLVehicleMaintenancesViewController.h"
#import "MOLPaginationManager.h"
#import "MOLNetworkManager.h"
#import "MOLLocal.h"
#import "MOLService.h"
#import "MOLImage.h"
#import "MOLMaintenanceBook.h"
#import "MOLMaintenanceBookDetails.h"
#import "MOLEditableModelTableViewController.h"
#import "MOLVehicleMaintenanceTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIScrollView+APParallaxHeader.h"

@interface MOLVehicleMaintenancesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) MOLPaginationManager *paginationObject;

@property (nonatomic, copy) NSArray *locals;
@property (nonatomic, copy) NSArray *services;

@end

@implementation MOLVehicleMaintenancesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    
    self.table.separatorColor = [UIColor clearColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.table registerNib:[UINib nibWithNibName:@"MOLVehicleMaintenanceTableViewCell" bundle:nil] forCellReuseIdentifier:@"vehicledetailCell"];

    if (self.vehicle.image) {
        [self.table addParallaxWithImage:self.vehicle.image andHeight:160];
    }
    
    self.title = self.vehicle.nick;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchDependencyData];
    NSString *filter = [NSString stringWithFormat:@"vehicle=%@", self.vehicle.objectId];
    self.paginationObject = [[MOLPaginationManager alloc] initWithClass:MOLMaintenanceBook.class pageSize:20 filters:@[filter]];
    
    self.table.tableFooterView = [self.paginationObject activityIndicatorView:self.view];
    [self nextPage];
}

#pragma mark - Network

- (void)fetchDependencyData {
    @weakify(self);
    [[MOLNetworkManager sharedInstance] objects:[MOLLocal class]
                                            pageSize:100
                                                page:1
                                             filters:nil
                                     completionBlock:^(NSError *error, NSArray *objects, NSUInteger nextPage, NSUInteger totalObjects)
     {
         @strongify(self);
         self.locals = objects.copy;
         [[MOLNetworkManager sharedInstance] objects:[MOLService class]
                                                 pageSize:100
                                                     page:1
                                                  filters:nil
                                          completionBlock:^(NSError *error, NSArray *objects, NSUInteger nextPage, NSUInteger totalObjects)
          {
              self.services = objects.copy;
              [self.table reloadData];
          }];
     }];
}

#pragma mark - UITableView Deletegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.paginationObject.results.count == 0) {
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.table.bounds.size.width, self.table.bounds.size.height)];
        messageLbl.text = @"No maintenances created yet. \n Please, tap on the plus button above.";;
        messageLbl.numberOfLines = 2;
        messageLbl.textAlignment = NSTextAlignmentCenter;
        [messageLbl sizeToFit];
        self.table.backgroundView = messageLbl;
    } else {
        self.table.backgroundView = nil;
    }
    
    return self.paginationObject.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MOLVehicleMaintenanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"vehicledetailCell"];

    MOLMaintenanceBook *maintenance = self.paginationObject.results[indexPath.row];
    MOLService *service = [MOLService searchObjectWithId:maintenance.serviceId array:self.services];
    [cell drawCellWithMaintenance:maintenance service:service];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"maintenanceDetails" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[MOLNetworkManager sharedInstance] deleteObject:self.paginationObject.results[indexPath.row] completionBlock:^(NSError *error) {
            if (!error) {
                [self.paginationObject.results removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.table.contentOffset.y >= (self.table.contentSize.height - self.table.bounds.size.height)) {
        if (self.paginationObject.results.count < self.paginationObject.totalObjects) {
            [self nextPage];
        } else {
            self.table.tableFooterView = nil;
        }
    }
}

#pragma mark - Pagination

- (void)nextPage {
    @weakify(self);
    [self.paginationObject nextPageWithBlock:^(NSError *error) {
        if (!error) {
            @strongify(self);
            [self.table reloadData];
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"vehicleDetail"]) {
        MOLEditableModelTableViewController *newVehicleVC = [segue destinationViewController];
        newVehicleVC.modelObject = self.vehicle;
        newVehicleVC.title = self.vehicle.nick;
    }
    
    if ([[segue identifier] isEqualToString:@"maintenanceDetails"]) {
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        MOLMaintenanceBook *maintenance = self.paginationObject.results[indexPath.row];
        
        [SVProgressHUD show];
        [[MOLNetworkManager sharedInstance] objectOfClass:MOLMaintenanceBookDetails.class withId:maintenance.objectId completionBlock:^(NSError *error, id<APIDrawableObject> object) {
            [SVProgressHUD dismiss];
            if (error) {
                NSLog(@"Error fetch maintenanceID %@: %@", maintenance.objectId, error.localizedDescription);
            } else {
                MOLEditableModelTableViewController *maintenanceDetailsVC = [segue destinationViewController];
                MOLMaintenanceBookDetails *maintenance = (MOLMaintenanceBookDetails *)object;
                
                if (!maintenance.local) {
                    maintenance.local = [[MOLLocal alloc] init];
                }
                
                if (!maintenance.service) {
                    maintenance.service = [[MOLService alloc] init];
                }
                
                
                maintenanceDetailsVC.title = @"Maintenance Details";
                maintenanceDetailsVC.modelObject = maintenance;
                [maintenanceDetailsVC reloadData];
            }
        }];
    }
    
    if ([[segue identifier] isEqualToString:@"newMaintenance"]) {
        MOLMaintenanceBookDetails *maintence = [[MOLMaintenanceBookDetails alloc] init];
        maintence.vehicle = self.vehicle;
        maintence.local = [[MOLLocal alloc] init];
        maintence.service = [[MOLService alloc] init];
        
        MOLEditableModelTableViewController *newMaintenanceVC = [segue destinationViewController];
        newMaintenanceVC.modelObject = maintence;
        newMaintenanceVC.title = [NSString stringWithFormat:@"New Maintenance"];
    }
}

#pragma mark - MOLVehicleDelegate

- (void)vehicleDidUpdate:(MOLVehicle *)vehicle {
    self.vehicle = vehicle;
}

@end
