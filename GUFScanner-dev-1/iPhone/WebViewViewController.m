//
//  WebViewViewController.m
//  UIWebViewTutorial
//
//  Created by iOsDevGermany
//

#import "WebViewViewController.h"

@interface WebViewViewController ()

@end

@implementation WebViewViewController
@synthesize webView;
@synthesize loadingSign;
@synthesize websiteName=_websiteName;

-(void) webViewDidStartLoad:(UIWebView *)webView {
    [self.loadingSign startAnimating];
    self.loadingSign.hidden = NO;
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [self.loadingSign stopAnimating];
    self.loadingSign.hidden = YES;
}

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
    self.title = self.websiteName;
    NSString *fullURL = [NSString stringWithFormat:@"http://192.168.2.10/MitarbeiterZeiterfassungsMobile?Von=&Bis=&Mid=5", self.websiteName];
    NSURL *websiteURL = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:websiteURL];
    [webView loadRequest:requestObj];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setLoadingSign:nil];
    [self setWebView:nil];
    [self setWebView:nil];
    [self setLoadingSign:nil];
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [loadingSign release];
    [webView release];
    [super dealloc];
}
@end
