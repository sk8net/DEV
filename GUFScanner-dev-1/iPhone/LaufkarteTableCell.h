//
//  LaufkarteTableCell.h
//  BarcodeExample
//
//  Created by Tom Jowett on 5/1/13.
//  Copyright (c) 2013 Mobilogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaufkarteTableCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *namePrependedToBezeichnungLabel;
@property (retain, nonatomic) IBOutlet UILabel *bemerkungLabel;

@property (retain, nonatomic) IBOutlet UIButton *toggleStatusButton;

@end
