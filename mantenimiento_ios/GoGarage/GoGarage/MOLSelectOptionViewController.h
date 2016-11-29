//
//  MOLSelectOptionViewController.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 13/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLMaintenanceBookDetails.h"
@class MOLSelectOptionViewController;

@protocol MOLSelectOptionViewControllerDelegate <NSObject>

-(void)selectOptionViewController:(MOLSelectOptionViewController *)viewController didSelect:(id)object;

@end


@interface MOLSelectOptionViewController : UITableViewController

@property (nonatomic, weak) id<MOLSelectOptionViewControllerDelegate>delegate;
@property (nonatomic, strong) id<APIDrawableObject> selectedObject;
@property (nonatomic, strong) NSArray *options;

@end
