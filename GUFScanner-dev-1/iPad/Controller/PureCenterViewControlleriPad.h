//
//  PureCenterViewControlleriPad.h
//  Untitled
//
//  Created by mikimoto on 2011/1/21.
//  Copyright 2011 GundF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PureCenterViewControlleriPad : UIViewController<ReceiveCommandHandler, NotificationHandler> {
	IBOutlet UILabel *label;
	IBOutlet UISwitch *mySwitch;
}

-(IBAction)scan:(id)sender;
- (void)checkConnected;

@end
