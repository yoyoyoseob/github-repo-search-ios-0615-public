//
//  FISReposTableViewController.m
//
//
//  Created by Joe Burgess on 5/5/14.
//
//

#import "FISReposTableViewController.h"
#import "FISReposDataStore.h"
#import "FISGithubRepository.h"
#import "FISGithubAPIClient.h"

@interface FISReposTableViewController ()
@property (strong, nonatomic) FISReposDataStore *dataStore;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

@end

@implementation FISReposTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.accessibilityLabel=@"Repo Table View";
    self.tableView.accessibilityIdentifier=@"Repo Table View";
    
    self.tableView.accessibilityIdentifier = @"Repo Table View";
    self.tableView.accessibilityLabel=@"Repo Table View";
    
    self.dataStore = [FISReposDataStore sharedDataStore];
    [self.dataStore getRepositoriesWithCompletion:^(BOOL success) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
            self.searchButton.enabled = YES;
        }];
    }];

    
    //    [FISGithubAPIClient checkIfStarred:@"yoyoyoseob/whack-a-doge" withCompletion:^(BOOL starred) {
    //        if (starred)
    //            NSLog(@"YES");
    //    }];
    
    //    [FISGithubAPIClient toggleStarForRepo:@"yoyoyoseob/whack-a-doge" withCompletion:^(BOOL starred) {
    //        NSLog(@"In the completion Block! isNowStarred: %d", starred);
    //    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataStore.repositories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];
    
    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    cell.textLabel.text = repo.fullName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FISGithubRepository *repo = self.dataStore.repositories[indexPath.row];
    NSString *repoName = repo.fullName;
    
    [FISGithubAPIClient toggleStarForRepo:repoName withCompletion:^(BOOL starred) {
        [self displayStarToggleAlert:starred repo:repoName];
    }];
}

-(void)displayStarToggleAlert:(BOOL)starred repo:(NSString *)repoName
{
    NSString *alertMessage;
    
    if (starred)
    {
        alertMessage = [NSString stringWithFormat:@"%@ is now starred!", repoName];
    }
    else
    {
        alertMessage = [NSString stringWithFormat:@"%@ is now unstarred!", repoName];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success!" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Gotcha" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)searchButtonTapped:(id)sender
{
    [self displaySearchAlert];
}

-(void)updateRepoListWithSearch:(NSString *)search
{
    [self.dataStore getSearchResultsWithName:search withCompletion:^(BOOL found) {
        if (found)
        {
            NSLog(@"Found!");
            NSLog(@"%@", self.dataStore.repositories);
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
//            }];
        }
    }];
}

-(void)displaySearchAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Search for a repo" message:@"Enter the name of the repo you would like to search" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Search keyword";
        [textField addTarget:self action:@selector(alertTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    UIAlertAction *searchAction = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *search = alert.textFields.firstObject;
        
        [self updateRepoListWithSearch:search.text];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:alert completion:nil];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:searchAction];
    
    searchAction.enabled = NO;
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alert = (UIAlertController *)self.presentedViewController;
    if (alert)
    {
        UITextField *searchField = alert.textFields.firstObject;
        UIAlertAction *searchAction = alert.actions.lastObject;
        searchAction.enabled = searchField.text.length >= 1;
    }
}

@end
