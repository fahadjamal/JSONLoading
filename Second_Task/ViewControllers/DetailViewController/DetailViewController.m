//
//  DetailViewController.m
//  Second_Task
//
//

#import "DetailViewController.h"

@interface DetailViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *mainWebView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation DetailViewController

#pragma mark - Default Init Method -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:self.announcementTitleString];
    
    [self.mainWebView loadHTMLString:self.announcementString baseURL:nil];
}

#pragma mark - Class Instance Method -

-(void)showActivityLoaderView {
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.activityView.center = self.view.center;
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
}

-(void)hideActivityLoaderView {
    [self.activityView removeFromSuperview];
    self.activityView = nil;
}

#pragma mark - UIWebViewDelegate Method -

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showActivityLoaderView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideActivityLoaderView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"URL Error" message:@"Error Occured"
                                                        delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlert show];
}

#pragma mark - Default Init Method -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    self.mainWebView = nil;
    self.activityView = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
