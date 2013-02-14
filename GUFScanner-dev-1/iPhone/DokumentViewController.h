//
//  DokumentViewController.h
//  BarcodeExample
//
//  Created by Tom Jowett on 5/1/13.
//  Copyright (c) 2013 Mobilogics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DokumentViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *dokumentURL;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
