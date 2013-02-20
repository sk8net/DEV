//
//  ArtikelInformation.m
//  BarcodeExample
//
//  Created by Matthias Lukjantschuk on 3/1/13.
//  Copyright (c) 2013 GundF. All rights reserved.
//

#import "ArtikelInformation.h"
#import "Artikel.h"
#import "ArtikelInformationTableViewCell.h"
#import "DokumentViewController.h"

@interface ArtikelInformation ()

@end

@implementation ArtikelInformation

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
       
    UINib *nib = [UINib nibWithNibName:@"ArtikelInformationTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ArtikelInformation Cell"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    if ([[self.artikelInfo objectForKey:@"BlueprintScan"] count] == 0) self.tableView.hidden = YES;
    
    if ([self.artikelInfo objectForKey:@"Kunde"]) {
        self.kundeLabel.text = [self.artikelInfo objectForKey:@"Kunde"];
    }
    
    if ([self.artikelInfo objectForKey:@"Artikelnummer"]) {
        self.artikelNummerLabel.text = [self.artikelInfo objectForKey:@"Artikelnummer"];
    }
    
    if ([self.artikelInfo objectForKey:@"Bezeichnung"]) {
        self.bezeichnungLabel.text = [self.artikelInfo objectForKey:@"Bezeichnung"];
    }

    if ([self.artikelInfo objectForKey:@"Material"]) {
        self.materialLabel.text = [self.artikelInfo objectForKey:@"Material"];
    }
    
    if ([self.artikelInfo objectForKey:@"Bestellnummer"]) {
        self.laufendebestellungLabel.text = [self.artikelInfo objectForKey:@"Bestellnummer"];
    }
    
    if ([self.artikelInfo objectForKey:@"Status"]) {
        self.statusLabel.text = [self.artikelInfo objectForKey:@"Status"];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.artikelInfo objectForKey:@"BlueprintScan"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArtikelInformation Cell";
    
    ArtikelInformationTableViewCell *cell = (ArtikelInformationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ArtikelInformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSString *dokumentURL = [[[self.artikelInfo objectForKey:@"BlueprintScan"] objectAtIndex:indexPath.row] objectForKey:@"Dokument"];
    cell.dokumentLabel.text = dokumentURL;
    
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDokumentViewController" sender:indexPath];
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    DokumentViewController *destinationViewController = segue.destinationViewController;
    NSString *dokumentURL = [[[self.artikelInfo objectForKey:@"BlueprintScan"] objectAtIndex:indexPath.row] objectForKey:@"Dokument"];
    [destinationViewController setDokumentURL:dokumentURL];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_kundeLabel release];
    [_artikelNummerLabel release];
    [_bezeichnungLabel release];
   // [_zeichnungsNummerLabel release];
    [_materialLabel release];
    [_laufendebestellungLabel release];
    [_statusLabel release];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setKundeLabel:nil];
    [self setArtikelNummerLabel:nil];
    [self setBezeichnungLabel:nil];
//    [self setZeichnungsNummerLabel:nil];
    [self setMaterialLabel:nil];
    [self setLaufendebestellungLabel:nil];
    [self setStatusLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
