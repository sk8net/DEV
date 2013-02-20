//
//  ArtikelInformation.h
//  BarcodeExample
//
//  Created by Matthias Lukjantschuk on 3/1/13.
//  Copyright (c) 2013 GundF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Artikel;

@interface ArtikelInformation : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *artikelInfo;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UILabel *kundeLabel;
@property (retain, nonatomic) IBOutlet UILabel *artikelNummerLabel;
@property (retain, nonatomic) IBOutlet UILabel *bezeichnungLabel;
//@property (retain, nonatomic) IBOutlet UILabel *zeichnungsNummerLabel;
@property (retain, nonatomic) IBOutlet UILabel *materialLabel;
@property (retain, nonatomic) IBOutlet UILabel *laufendebestellungLabel;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;

@end
