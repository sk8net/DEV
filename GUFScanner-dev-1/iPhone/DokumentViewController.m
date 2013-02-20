//
//  DokumentViewController.m
//  BarcodeExample
//
//  Created by Matthias Lukjantschuk on 5/1/13.
//  Copyright (c) 2013 GundF. All rights reserved.
//

#import "DokumentViewController.h"

@interface DokumentViewController ()

@end

@implementation DokumentViewController

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
    
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    
   // NSURL *url = [NSURL URLWithString:@"http://192.168.2.10/Blueprint/Download?docId=27"];
        NSURL *url = [NSURL URLWithString:self.dokumentURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    
    [self.webView loadRequest:request];
    
	// Do any additional setup after loading the view.
}

#pragma mark UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismissWithError:@"Network error"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
