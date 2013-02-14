//
//  BestellInformationViewController.h
//  BarcodeExample
//
//  Created by Tom Jowett on 15/12/12.
//  Copyright (c) 2012 Mobilogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BestellInformationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *UDID;
@property (strong, nonatomic) NSString *barcode;
@property (strong, nonatomic) NSString *mitarbeiterID;
@property (retain, nonatomic) IBOutlet UILabel *kundeLabel;
@property (retain, nonatomic) IBOutlet UILabel *bestellNummerLabel;
@property (retain, nonatomic) IBOutlet UILabel *auftragsnummerLabel;
@property (retain, nonatomic) IBOutlet UILabel *LTLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
