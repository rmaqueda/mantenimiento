//
//  MOLLocalTableViewCell.h
//  GoGarage
//
//  Created by Ricardo Maqueda Martinez on 22/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

@class MOLLocal;

@interface MOLLocalTableViewCell : UITableViewCell

- (void)drawCellWithLocal:(MOLLocal *)local;

@end
