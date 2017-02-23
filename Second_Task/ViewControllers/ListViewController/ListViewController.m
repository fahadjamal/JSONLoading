//
//  ViewController.m
//  Second_Task
//
//

#import "ListViewController.h"
#import "CustomListTableCell.h"

#import "DetailViewController.h"
#import "DataManager.h"

#import "Constants.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *listTableView;

@property (nonatomic, strong) NSMutableArray *listItemsArray;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation ListViewController

#pragma mark - Default Init Method -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationItem setTitle:@"List of Items"];
    
    [self showActivityLoaderView];
    
    NSURL *serverURL = [NSURL URLWithString:SERVER_URL];
    [[DataManager sharedInstance] loadData:serverURL withCompletion:^(NSArray *itemListArray, NSError *error) {
        if (error != nil) {
            [self hideActivityLoaderView];
            
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Server Error" message:@"Unable to fetch Data from Server" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
        else {
            self.listItemsArray = [[NSMutableArray alloc] initWithArray:itemListArray];
            dispatch_sync(dispatch_get_main_queue(),^{
                [self.listTableView reloadData];
                [self hideActivityLoaderView];
            });
        }
    }];
}

#pragma mark - UITableViewDataSource Method -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listItemsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CustomListTableCell";
    
    CustomListTableCell *cell = (CustomListTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *itemDictionary = [self.listItemsArray objectAtIndex:indexPath.row];
    NSLog(@"itemDictionary is %@", [itemDictionary description]);
    
    cell.announcementLabel.text = [NSString stringWithFormat:@"Title : %@", [itemDictionary valueForKey:@"ANNOUNCEMENT_TITLE"]];
    cell.announcementDate.text = [NSString stringWithFormat:@"Date: %@", [itemDictionary valueForKey:@"ANNOUNCEMENT_DATE"]];
    return cell;
}

#pragma mark - UITableViewDelegate Method -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *selectedItemDictionary = [self.listItemsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"DetailViewController" sender:selectedItemDictionary];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        NSDictionary *selectedItemDictionary = (NSDictionary *)sender;
        
        DetailViewController *detailViewController = (DetailViewController *)[segue destinationViewController];
        detailViewController.announcementString = [selectedItemDictionary objectForKey:@"ANNOUNCEMENT_HTML"];
        detailViewController.announcementTitleString = [selectedItemDictionary objectForKey:@"ANNOUNCEMENT_TITLE"];
    }
}

#pragma mark - Default Init Method -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    self.listTableView =  nil;
    self.listItemsArray = nil;
    
    self.activityView = nil;
}

@end
