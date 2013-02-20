    //
//  PureCenterViewControlleriPad.m
//  Untitled
//
//  Created by mikimoto on 2011/1/21.
//  Copyright 2011 GundF. All rights reserved.
//

#import "PureCenterViewControlleriPad.h"


@implementation PureCenterViewControlleriPad

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
-(void)viewDidLoad {
  [super viewDidLoad];
  
	[[MLConnection sharedInstance] addAccessoryDidConnectNotification:self];
  [[MLConnection sharedInstance] addAccessoryDidDisconnectNotification:self];
  [[MLConnection sharedInstance] addReceiveCommandHandler:self];
}

-(void)viewDidAppear:(BOOL)animated {
  [self checkConnected];  
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
  [super viewDidUnload];
	[[MLConnection sharedInstance] removeAccessoryDidConnectNotification:self];
  [[MLConnection sharedInstance] removeAccessoryDidDisconnectNotification:self];
  [[MLConnection sharedInstance] removeReceiveCommandHandler:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Barcode Framework Delegate

-(IBAction)scan:(id)sender {
  if ([[MLConnection sharedInstance] isConnected]) {
    [[MLConnection sharedInstance] execute:[ScanShot sharedInstance]];
  }
}

-(void)connectNotify {
	[self checkConnected];
}

-(void)disconnectNotify {
	[self checkConnected];
  [label setText:@""];
}

- (void)checkConnected {
  if ([[MLConnection sharedInstance] isConnected]) {
		[mySwitch setOn:YES animated:YES];
  } else {
		[mySwitch setOn:NO animated:YES];
  }  
}

-(BOOL)isHandler:(NSObject<CommandReceiver> *)command {
  if ([command isKindOfClass:[ScanShotReceiver class]]) {
    return TRUE;
  }
  return FALSE;
}

-(void)handleRequest:(NSObject<CommandReceiver> *)command {
  [label setText:[command getReceiveString]];
}

@end
