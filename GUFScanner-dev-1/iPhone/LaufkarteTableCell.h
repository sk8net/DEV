//
//  LaufkarteTableCell.h
//  BarcodeExample
//
//  Created by Matthias Lukjantschuk on 5/1/13.
//  Copyright (c) 2013 GundF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaufkarteTableCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *namePrependedToBezeichnungLabel;
@property (retain, nonatomic) IBOutlet UILabel *bemerkungLabel;

@property (retain, nonatomic) IBOutlet UIButton *toggleStatusButton;

@end
