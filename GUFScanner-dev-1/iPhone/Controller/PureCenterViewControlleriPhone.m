//
//  PureCenterViewControlleriPhone.m
//  Untitled
//
//  Created by Neo on 2011/1/21.
//  Copyright 2011 Mobilogics. All rights reserved.
//

#import "PureCenterViewControlleriPhone.h"
#import "BestellInformationViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "WebViewViewController.h"



@interface PureCenterViewControlleriPhone()
@property (strong, nonatomic) NSString *urlFromSettings;
@property BOOL scannerConnected;
@property (strong, nonatomic) NSString *barcode;
@property (strong, nonatomic) UIToolbar *inputAccessoryView;
@property (strong, nonatomic) NSString *kommenURLString;
@property (strong, nonatomic) NSString *gehenURLString;
@property (strong, nonatomic) UIAlertView *chooseScanMethodAlertView;
@property (strong, nonatomic) UIAlertView *manualBarcodeEntryAlertView;
@property (strong, nonatomic) UIAlertView *willkommenAlertView;
@property (strong, nonatomic) NSString *statusCode;
@end
@interface YourCustomViewClass : UIViewController <UIAlertViewDelegate> {
}
@end

@implementation PureCenterViewControlleriPhone
@synthesize mitarbeiterID;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
  
	[[MLConnection sharedInstance] addAccessoryDidConnectNotification:self];
    [[MLConnection sharedInstance] addAccessoryDidDisconnectNotification:self];
    [[MLConnection sharedInstance] addReceiveCommandHandler:self];
        
    self.oderBarcodeEintippen.delegate = self;
    self.mitarbeiterID.delegate = self;
    
    [self checkKommenStatus];
}

- (void)checkKommenStatus {

    [SVProgressHUD show];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.2.10/Scan/GetKommenUndGehenStatus"];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    
    client.parameterEncoding = AFJSONParameterEncoding;
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    //depending on what kind of response you expect.. change it if you expect XML
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            [[UIDevice currentDevice] uniqueIdentifier], @"UDID",
                             nil];

   // NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
     //                       @"d867538104afd92064ffb6461f4a2f3887b2e17e", @"UDID",
       //                     nil];
    
    [client getPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject objectForKey:@"code"]) {
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"1901"]) {
                self.statusCode = @"1901";
                [self.updateStatusButton setTitle:@"Kommen" forState:UIControlStateNormal];
            } else {
                [self.updateStatusButton setTitle:@"Gehen" forState:UIControlStateNormal];
                self.statusCode = @"1902";                
            }
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
        [SVProgressHUD dismissWithError:@"Network Error"];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
  [self checkConnected];  
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setOderBarcodeEintippen:nil];
    [self setMitarbeiterID:nil];
    [self setGehenPressed:nil];
    [self setTextField:nil];
    [super viewDidUnload];
    [[MLConnection sharedInstance] removeAccessoryDidConnectNotification:self];
    [[MLConnection sharedInstance] removeAccessoryDidDisconnectNotification:self];
    [[MLConnection sharedInstance] removeReceiveCommandHandler:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_oderBarcodeEintippen release];
    [mitarbeiterID release];
    [super dealloc];
}

#pragma mark -
#pragma mark Methods for this class

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showBestellInformationViewController"]) {
        BestellInformationViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.UDID = [[UIDevice currentDevice] uniqueIdentifier];
        destinationViewController.barcode = self.barcode;

    
    } else if ([segue.identifier isEqualToString:@"showManualBestellInformationViewController"]) {
        BestellInformationViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.UDID = [[UIDevice currentDevice] uniqueIdentifier];
        destinationViewController.barcode = self.oderBarcodeEintippen.text;
        destinationViewController.mitarbeiterID = self.mitarbeiterID.text;
    }
}
//-(void) prepareForSegue2:(UIStoryboardSegue *)segue sender:(id)sender {


#pragma mark -
#pragma mark Barcode Framework Delegate

- (IBAction)manual:(id)sender {
    [self performSegueWithIdentifier:@"showManualBestellInformationViewController" sender:self];
}

-(IBAction)scan:(id)sender {
  if ([[MLConnection sharedInstance] isConnected]) {
    [[MLConnection sharedInstance] execute:[ScanShot sharedInstance]];
  } else {
      [self scanButtonTapped];
  }
}

-(void)connectNotify {
	[self checkConnected];
}

-(void)disconnectNotify {
	[self checkConnected];
}

- (void)checkConnected {
  if ([[MLConnection sharedInstance] isConnected]) {
      UIAlertView *scannerConnectedAlertView = [[UIAlertView alloc] initWithTitle:@"Scanner connected"
                                                                             message:@"The scanner is now connected"
                                                                            delegate:self
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
      [scannerConnectedAlertView show];
  } else {
      UIAlertView *scannerNotConnectedAlertView = [[UIAlertView alloc] initWithTitle:@"Scanner not connected"
                                                                             message:@"The scanner is not connected, please check the connection."
                                                                            delegate:self
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
      [scannerNotConnectedAlertView show];
  }
}

- (IBAction)kommen:(id)sender {
    [self sendKommenGehenWithCode:self.statusCode];
}

- (void)sendKommenGehenWithCode:(NSString *)code
{
    [SVProgressHUD show];
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.2.10/Scan/KommenUndGehen"];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    
    //depending on what kind of response you expect.. change it if you expect XML
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
  //NSString *UDID = @"d867538104afd92064ffb6461f4a2f3887b2e17e";
    NSString *UDID = [[UIDevice currentDevice] uniqueIdentifier];
    

   client.parameterEncoding = AFJSONParameterEncoding;
   [client setDefaultHeader:@"Accept" value:@"application/json"];
//    
//    // depending on what kind of response you expect.. change it if you expect XML
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            code, @"Barcode",
                            UDID, @"UDID",
                            self.mitarbeiterID.text, @"MitarbeiterID",
                            nil];
    
    [client postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *message = [NSString stringWithFormat:@"You scored %@ points",
//                             [counter2 text]];
//        NSString *message
//        NSString *message = [[NSString alloc] initWithFormat:(NSString *),responseObject];
//        NSLog(@"Request Successful, response '%@'", message);
        UIAlertView *willkommenAlertView = [[UIAlertView alloc] initWithTitle:@"..."
                                                                      message:[NSString stringWithFormat:@"%@", responseObject]
                                                                              delegate:self
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
        [willkommenAlertView show];
        [willkommenAlertView release];
        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"failure");
//    }];
//    
//    [self retrieveBestellInformation];
    
    

    
       
        NSLog(@"success POST %@", code);
        [SVProgressHUD dismiss];
        [self checkKommenStatus];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure POST %@", code);
        [SVProgressHUD dismissWithError:@"Network Error"];
    }];
}

-(BOOL)isHandler:(NSObject<CommandReceiver> *)command {
  if ([command isKindOfClass:[ScanShotReceiver class]]) {
    return TRUE;
  }
  return FALSE;
}

-(void)handleRequest:(NSObject<CommandReceiver> *)command {
    self.barcode = [command getReceiveString];
    [self performSegueWithIdentifier:@"showBestellInformationViewController" sender:self];
}

#pragma mark -
#pragma mark ZBar Delegate methods

- (IBAction) scanButtonTapped
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
          //  [scanner setSymbology: ZBAR_I25
                 //   config: ZBAR_CFG_ENABLE
                 //    to: 1];
    
    
    // present and release the controller
    [self presentModalViewController: reader animated: YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    self.barcode = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"showBestellInformationViewController" sender:self];
    }];
    
}

#pragma mark Drawing methods

//create custom toolbar for top of keyboard with 'done' button eg.
- (void)createInputAccessoryView {
    self.inputAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    self.inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    [self.inputAccessoryView setItems:[NSArray arrayWithObjects:spacer, done, nil]];
}

#pragma mark UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self createInputAccessoryView];
    [textField setInputAccessoryView:self.inputAccessoryView];
}

#pragma mark dismissKeyboard methods

- (void)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

@end
