//
//  EditableModelTableViewController.h
//  Table Editable Model
//
//  Created by Ricardo Maqueda Martinez on 14/01/16.
//  Copyright © 2016 Ricardo Maqueda Martinez. All rights reserved.
//

#import "MOLBaseModel.h"


@interface MOLEditableModelTableViewController : UITableViewController

@property (nonatomic, strong) NSObject<APIDrawableObject> *modelObject;

//TODO: Evitar esto, lo puse ya que la descarga de datos en el segue es asincrona.
- (void)reloadData;

@end
