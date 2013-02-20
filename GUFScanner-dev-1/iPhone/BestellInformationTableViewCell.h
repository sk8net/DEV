//
//  BestellInformationTableViewCell.h
//  BarcodeExample
//
//  Created by Matthias Lukjantschuk on 2/1/13.
//  Copyright (c) 2013 GundF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BestellInformationTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *posLabel;
@property (retain, nonatomic) IBOutlet UILabel *artNrLabel;
@property (retain, nonatomic) IBOutlet UILabel *mengeLabel;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;

@end
