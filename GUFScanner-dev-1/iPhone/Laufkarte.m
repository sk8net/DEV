//
//  Laufkarte.m
//  BarcodeExample
//
//  Created by Tom Jowett on 3/1/13.
//  Copyright (c) 2013 Mobilogics. All rights reserved.
//

#import "Laufkarte.h"
#import "ArtikelInformation.h"
#import "LaufkarteTableCell.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface Laufkarte ()
@property (strong, nonatomic) NSMutableArray *kostenstelleScan;
@property NSInteger completedNetworkRequests;
@property NSInteger requiredNetworkRequests;
@end

@implementation Laufkarte

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.kostenstelleScan = [[NSMutableArray alloc] init];
    
    UINib *nib = [UINib nibWithNibName:@"LaufkarteTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Laufkarte Cell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.auftragsnummerLabel.text = [self.artikelInfo objectForKey:@"Auftragsnummer"];
    
    if ([[self.artikelLaufkart objectForKey:@"KostenstelleScan"] count] == 0) self.tableView.hidden = YES;
    
    NSMutableArray *mutable = [[NSMutableArray alloc] init];
    for (NSDictionary *scan in [self.artikelLaufkart objectForKey:@"KostenstelleScan"]) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:scan];
        [mutable addObject:tempDict];
    }
    
    [self.artikelLaufkart setObject:mutable forKey:@"KostenstellScan"];
    
    NSDictionary *artikelLaufkartCopy = [NSDictionary dictionaryWithDictionary:self.artikelLaufkart];
    NSInteger index = 0;
    
    [SVProgressHUD show];
    
    for (NSDictionary *kostenstellScan in [artikelLaufkartCopy objectForKey:@"KostenstelleScan"]) {
        [self checkKostenstellScanStatus:kostenstellScan atIndex:index];
        index++;
    }
    
    self.requiredNetworkRequests = [[self.artikelLaufkart objectForKey:@"KostenstelleScan"] count];
    self.completedNetworkRequests = 0;
}

- (void)checkKostenstellScanStatus:(NSDictionary *)kostenstellScan atIndex:(NSInteger)index {    

    NSURL *url = [NSURL URLWithString:@"http://192.168.2.10/Scan/GetZeitFertigungStatus"];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    
    client.parameterEncoding = AFJSONParameterEncoding;
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    //depending on what kind of response you expect.. change it if you expect XML
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //NSString *UDID = @"d867538104afd92064ffb6461f4a2f3887b2e17e";
   NSString *UDID = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            [kostenstellScan objectForKey:@"Id"], @"kostenstelle",
                            [self.artikelInfo objectForKey:@"Auftragsnummer"], @"Auftragsnummer",
                            [self.artikelInfo objectForKey:@"Artikelnummer"], @"Artikelnummer",
                            @"UDID", UDID, 
                            nil];
    
    [client getPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject objectForKey:@"code"]) {

            NSMutableDictionary *kostenstellScanToUpdate = [NSMutableDictionary dictionaryWithDictionary:kostenstellScan];
            
            NSMutableArray *arrayToUpdate = [NSMutableArray arrayWithArray:[self.artikelLaufkart objectForKey:@"KostenstelleScan"]];
            
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"1903"]) {
                [kostenstellScanToUpdate setObject:@"1903" forKey:@"code" ];
            } else {
                [kostenstellScanToUpdate  setObject:@"1904" forKey:@"code" ];
            }
            [arrayToUpdate replaceObjectAtIndex:index withObject:kostenstellScanToUpdate];
            [self.artikelLaufkart setObject:arrayToUpdate forKey:@"KostenstelleScan"];
        }
        self.completedNetworkRequests++;
        if (self.completedNetworkRequests == self.requiredNetworkRequests) [SVProgressHUD dismiss];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        
        self.completedNetworkRequests++;
        if (self.completedNetworkRequests == self.requiredNetworkRequests) [SVProgressHUD dismiss];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.artikelLaufkart objectForKey:@"KostenstelleScan"] count]; //self.kostenstelleScan.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Laufkarte Cell";
    
    LaufkarteTableCell *cell = (LaufkarteTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[LaufkarteTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    

    NSString *bemerkung;
    if ([[[self.artikelLaufkart objectForKey:@"KostenstelleScan"] objectAtIndex:indexPath.row] objectForKey:@"Bemerkung"] != [NSNull null]) {
        bemerkung = [NSString stringWithString:[[[self.artikelLaufkart objectForKey:@"KostenstelleScan"] objectAtIndex:indexPath.row] objectForKey:@"Bemerkung"]];
    } else {
        bemerkung = nil;
    }
    NSMutableArray *mutable = [[NSMutableArray alloc] init];
    [self.artikelLaufkart setObject:mutable forKey:@"KostenstellScan"];
    
    NSString *name;
    if ([[[self.artikelLaufkart objectForKey:@"KostenstelleScan"] objectAtIndex:indexPath.row] objectForKey:@"Name"] != [NSNull null]) {
        name = [NSString stringWithString:[[[self.artikelLaufkart objectForKey:@"KostenstelleScan"] objectAtIndex:indexPath.row] objectForKey:@"Name"]];
    } else {
        name = nil;
    }
    
    NSString *bezeichnung;
    if ([[[self.artikelLaufkart objectForKey:@"KostenstelleScan"] objectAtIndex:indexPath.row] objectForKey:@"Bezeichnung"] != [NSNull null]) {
        bezeichnung = [NSString stringWithString:[[[self.artikelLaufkart objectForKey:@"KostenstelleScan"] objectAtIndex:indexPath.row] objectForKey:@"Bezeichnung"]];
    } else {
        bezeichnung = nil;
    }
    
    if (bezeichnung && name) {
        cell.namePrependedToBezeichnungLabel.text = [NSString stringWithFormat:@"%@ %@", name, bezeichnung];
    } else {
        cell.namePrependedToBezeichnungLabel.text = nil;
    }
    cell.bemerkungLabel.text = bemerkung;

    if ([[[self.artikelLaufkart objectForKey:@"KostenstelleScan"] objectAtIndex:indexPath.row] objectForKey:@"code"] != [NSNull null]) {
        if ([[[[self.artikelLaufkart objectForKey:@"KostenstelleScan"] objectAtIndex:indexPath.row] objectForKey:@"code"] isEqualToString:@"1903"]) {
            [cell.toggleStatusButton setTitle:@"Start" forState:UIControlStateNormal];
        } else {
            [cell.toggleStatusButton setTitle:@"Stop" forState:UIControlStateNormal];
        }
            
    } else {
        bezeichnung = nil;
    }
    cell.toggleStatusButton.tag = indexPath.row;
    [cell.toggleStatusButton addTarget:self action:@selector(toggleStartStopForKostenstelleScan:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark Methods for this class

- (void)toggleStartStopForKostenstelleScan:(UIButton *)sender {
    NSMutableDictionary *kostenstellScanToUpdate = [[self.artikelLaufkart objectForKey:@"KostenstelleScan"] objectAtIndex:sender.tag];
    
    NSMutableArray *arrayToUpdate = [NSMutableArray arrayWithArray:[self.artikelLaufkart objectForKey:@"KostenstelleScan"]];
    
    NSString *currentCode = [kostenstellScanToUpdate objectForKey:@"code"];
    NSString *newCode;
    
    if ([currentCode isEqualToString:@"1904"]) {
        newCode = @"1903";
    } else {
        newCode = @"1904";
    }
    
    [SVProgressHUD show];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.2.10/Scan/UpdateZeitFertigung"];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    
    client.parameterEncoding = AFJSONParameterEncoding;
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    //depending on what kind of response you expect.. change it if you expect XML
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
     //   NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
       //                         [[UIDevice currentDevice] uniqueIdentifier], @"UDID",
         //                       nil];
    
    //NSString *UDID = @"d867538104afd92064ffb6461f4a2f3887b2e17e";
    
    NSString *UDID = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            [kostenstellScanToUpdate objectForKey:@"Id"], @"kostenstelle",
                            [self.artikelInfo objectForKey:@"Artikelnummer"], @"Artikelnummer",
                            [self.artikelInfo objectForKey:@"Auftragsnummer"], @"Auftragsnummer",
                            UDID , @"UDID", 
                            newCode, @"Barcode",
                            nil];
    
    [client postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"success POST %@\n", responseObject);        
        
        if (![[responseObject objectForKey:@"ms"] isEqualToString:@"error"]) {
         
            if ([newCode isEqualToString:@"1903"]) {
                [sender setTitle:@"Start" forState:UIControlStateNormal];
            } else {
                [sender setTitle:@"Stop" forState:UIControlStateNormal];
            }
            [kostenstellScanToUpdate setObject:newCode forKey:@"code"];
            [arrayToUpdate replaceObjectAtIndex:sender.tag withObject:kostenstellScanToUpdate];
            [self.artikelLaufkart setObject:arrayToUpdate forKey:@"KostenstelleScan"];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [SVProgressHUD dismissWithError:@"Update error"];
    }];
    
}

- (IBAction)finishPressed:(id)sender {

    [SVProgressHUD show];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.2.10/Scan/FinishZeitFertigung"];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    
    client.parameterEncoding = AFJSONParameterEncoding;
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    //depending on what kind of response you expect.. change it if you expect XML
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    //    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
    //                            [[UIDevice currentDevice] uniqueIdentifier], @"UDID",
    //                            nil];
    
 //   NSString *UDID = @"d867538104afd92064ffb6461f4a2f3887b2e17e";

   NSString *UDID = [[UIDevice currentDevice] uniqueIdentifier];
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            [self.artikelInfo objectForKey:@"Artikelnummer"], @"Artikelnummer",
                            [self.artikelInfo objectForKey:@"Auftragsnummer"], @"Auftragsnummer",                            
                            UDID , @"UDID", 
                            nil];
    
    [client postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success POST %@\n", responseObject);
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [SVProgressHUD dismissWithError: @"Artikel Lieferbereit"];
    }];

}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ArtikelInformation *destinationViewController = segue.destinationViewController;
    [destinationViewController setArtikelInfo:self.artikelInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
