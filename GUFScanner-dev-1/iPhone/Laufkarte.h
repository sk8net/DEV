//
//  Laufkarte.h
//  BarcodeExample
//
//  Created by Tom Jowett on 3/1/13.
//  Copyright (c) 2013 Mobilogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Artikel;

@interface Laufkarte : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *artikelLaufkart;
@property (strong, nonatomic) NSMutableDictionary *artikelInfo;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UILabel *auftragsnummerLabel;

- (IBAction)finishPressed:(id)sender;

@end
