
//  MOLBaseViewController.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 07/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLPaginationManager.h"
#import "MOLDataHelper.h"

@interface MOLPagginationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, copy) NSString *emptyTextLabel;
//@property (nonatomic, strong) MOLPaginationManager *paginationObject;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, strong) MOLDataHelper *dataHelper;

//- (void)nextPage;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@end
