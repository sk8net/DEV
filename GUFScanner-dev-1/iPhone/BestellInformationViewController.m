//
//  BestellInformationViewController.m
//  BarcodeExample
//
//  Created by Tom Jowett on 15/12/12.
//  Copyright (c) 2012 Mobilogics. All rights reserved.
//

#import "BestellInformationViewController.h"
#import "BestellInformationTableViewCell.h"
#import "Artikel.h"
#import "Laufkarte.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "ZBarSDK.h"
#import "SVProgressHUD.h"


@interface BestellInformationViewController ()
@property (strong, nonatomic) NSMutableArray *tableRows;
@property (strong, nonatomic) NSDictionary *response;
@property (strong, nonatomic) NSString *bestellNummer;
@property (strong, nonatomic) NSString *auftragsNummer;
@end

@implementation BestellInformationViewController

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
    
    self.tableRows = [[NSMutableArray alloc] init];

    UINib *nib = [UINib nibWithNibName:@"BestellInformationTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BestellInformation Cell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    
    [SVProgressHUD show];
    
  NSURL *url = [NSURL URLWithString:@"http://192.168.2.10/Scan/KommenUndGehen"];
 AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    
    client.parameterEncoding = AFJSONParameterEncoding;
   [client setDefaultHeader:@"Accept" value:@"application/json"];
    
 // depending on what kind of response you expect.. change it if you expect XML
   [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
            
   NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            self.UDID, @"UDID",
                           self.barcode ,@"Barcode",
                           nil];
    
   [client postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"success POST %@\n", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"failure");
   }];
    
    [self retrieveBestellInformation];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableRows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BestellInformation Cell";
    
    BestellInformationTableViewCell *cell = (BestellInformationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[BestellInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *artikelNSDict = [self.tableRows objectAtIndex:indexPath.row];
    
    NSString *posLabelString = [artikelNSDict objectForKey:@"ID"];
    cell.posLabel.text = posLabelString;
    
    NSString *artikelNummerString = [artikelNSDict objectForKey:@"Artikelnummer"];
    cell.artNrLabel.text = artikelNummerString;
    
    NSString *mengeLabelText = [artikelNSDict objectForKey:@"Menge"];
    cell.mengeLabel.text = mengeLabelText;
    
    NSString *statusLabelText = [artikelNSDict objectForKey:@"Status"];
    cell.statusLabel.text = statusLabelText;
    
    return cell;
}

- (void)retrieveBestellInformation
{
    __weak BestellInformationViewController *weakSelf = self;
    
    NSString *code = self.barcode;
    NSURL *url = [NSURL URLWithString:@"http://192.168.2.10/Scan/GetByBestellnummerOrAuftragsnummer/"];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];

    client.parameterEncoding = AFJSONParameterEncoding;
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    //depending on what kind of response you expect.. change it if you expect XML
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            code, @"code",
                            nil];
        
    [client getPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BestellInformationViewController *strongSelf = weakSelf;
        
        NSDictionary *response = [NSDictionary dictionaryWithDictionary:responseObject];
        strongSelf.response = [NSDictionary dictionaryWithDictionary:response];
        
        NSString *kunde = [[[responseObject objectForKey:@"Bestellinformation"] objectForKey:@"Kopfbereich"] objectForKey:@"Kunde"];
        if (![kunde isEqual:[NSNull null]]) {
            [strongSelf.kundeLabel setText:kunde];
        }

        NSString *bestellNummer = [[[responseObject objectForKey:@"Bestellinformation"] objectForKey:@"Kopfbereich"] objectForKey:@"Bestellnummer"];
        if (![bestellNummer isEqual:[NSNull null]]) {
            [strongSelf.bestellNummerLabel setText:bestellNummer];
            self.bestellNummer = bestellNummer;
        }
        
        NSString *auftragsNummer = [[[responseObject objectForKey:@"Bestellinformation"] objectForKey:@"Kopfbereich"] objectForKey:@"Auftragsnummer"];
        if (![auftragsNummer isEqual:[NSNull null]]) {
            [strongSelf.auftragsnummerLabel setText:auftragsNummer];
            self.auftragsNummer = auftragsNummer;
        }
        
        NSString *LT = [[[responseObject objectForKey:@"Bestellinformation"] objectForKey:@"Kopfbereich"] objectForKey:@"LT"];
        if (![LT isEqual:[NSNull null]]) {
            [strongSelf.LTLabel setText:LT];
        }
        
        NSArray *artikelArray = [[responseObject objectForKey:@"Artikelinformation"] objectForKey:@"Artikel"];
        for (NSDictionary *artikelDict in artikelArray) {
            NSMutableDictionary *artikelNSDict = [NSMutableDictionary dictionaryWithDictionary:artikelDict];

            for (NSDictionary *artikelLaufkart in [[self.response objectForKey:@"Laufkarte"] objectForKey:@"ArtikelLaufkart"]) {
                if ([[artikelLaufkart objectForKey:@"Artikelnummer"] isEqualToString:[artikelNSDict objectForKey:@"Artikelnummer"]]) {
                    NSString *menge = [artikelLaufkart objectForKey:@"BMenge"];
                    [artikelNSDict setObject:menge forKey:@"Menge"];
                }
            }
            
            [strongSelf.tableRows addObject:artikelNSDict];
        }
        
        

        [strongSelf.tableView reloadData];
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [SVProgressHUD dismissWithError:@"Network Error"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_kundeLabel release];
    [_bestellNummerLabel release];
    [_auftragsnummerLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"showLaufkarteViewController" sender:indexPath];
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *indexPath = sender;
    
    for (NSDictionary *artikelLaufkart in [[self.response objectForKey:@"Laufkarte"] objectForKey:@"ArtikelLaufkart"]) {

        if ([[artikelLaufkart objectForKey:@"Artikelnummer"] isEqualToString:[(NSDictionary *)[self.tableRows objectAtIndex:indexPath.row] objectForKey:@"Artikelnummer"]]) {
            
            NSMutableDictionary *artikelInfo = [NSMutableDictionary dictionaryWithDictionary:[self.tableRows objectAtIndex:indexPath.row]];
            
            NSMutableDictionary *artikelLaufkartDict = [NSMutableDictionary dictionaryWithDictionary:artikelLaufkart];
            
            [artikelInfo setObject:self.bestellNummer forKey:@"Bestellnummer"];
            [artikelInfo setObject:self.auftragsNummer forKey:@"Auftragsnummer"];
            
            Laufkarte *destinationViewController = segue.destinationViewController;
            [destinationViewController setArtikelLaufkart:artikelLaufkartDict];
            [destinationViewController setArtikelInfo:artikelInfo];
            break;
        }
    }
}

@end
