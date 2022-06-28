//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/27/22.
//

#import "HomeFeedViewController.h"
#import "InstagramPostTableViewCell.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "DetailsViewController.h"
#import <Parse/Parse.h>

@interface HomeFeedViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfPosts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self query];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(query) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)query {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"image"];
    [postQuery includeKey:@"caption"];
    [postQuery includeKey:@"createdAt"];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            NSLog(@"Succesfully retrieved posts");
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            NSLog(@"Error getting posts: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)logout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User logout successfully");
            SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            myDelegate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InstagramPostTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PhotoCell"
                                                                 forIndexPath:indexPath];
    Post *post = self.arrayOfPosts[indexPath.row];
    [cell setPost:post];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"details"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        DetailsViewController *detailsController = (DetailsViewController*)navigationController.topViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Post *dataToPass = self.arrayOfPosts[indexPath.row];
        detailsController.post = dataToPass;
    }
}

@end
