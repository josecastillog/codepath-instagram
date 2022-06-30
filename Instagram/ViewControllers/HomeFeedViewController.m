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
#import "Likes.h"
#import "DetailsViewController.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface HomeFeedViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ComposeViewControllerDelegate, PostCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfPosts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *arrayOfLikedPosts;
@property BOOL isMoreDataLoading;
@property int initialQueryLimit;
@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.initialQueryLimit = 20;
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
    postQuery.limit = self.initialQueryLimit;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            NSLog(@"Succesfully retrieved posts");
            self.arrayOfPosts = posts;
            [self likedPostsQuery];
        }
        else {
            NSLog(@"Error getting posts: %@", error.localizedDescription);
        }
    }];
}

- (void)queryWithLimit:(int)limit {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"image"];
    [postQuery includeKey:@"caption"];
    [postQuery includeKey:@"createdAt"];
    postQuery.limit = limit;

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

- (void)likedPostsQuery {
    PFQuery *likesQuery = [Likes query];
    [likesQuery includeKey:@"postID"];
    [likesQuery includeKey:@"userThatLiked"];
    [likesQuery whereKey:@"userThatLiked" equalTo:PFUser.currentUser];

    // fetch data asynchronously
    [likesQuery findObjectsInBackgroundWithBlock:^(NSArray<Likes *> * _Nullable likes, NSError * _Nullable error) {
        if (likes) {
            self.arrayOfLikedPosts = likes;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            NSLog(@"Error getting liked posts: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTaplogout:(id)sender {
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
    cell.delegate = self;
    cell.arrayOfLikedPosts = self.arrayOfLikedPosts;
    [cell setPost:post];
    return cell;
}

- (void)didPost {
    [self query];
}

- (void)postCell:(InstagramPostTableViewCell *) postCell didTap: (Post *)post {
    [self performSegueWithIdentifier:@"profileSegue" sender:post];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading) {
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            self.initialQueryLimit += 20;
            [self queryWithLimit:self.initialQueryLimit];
        }
    }
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
    if ([[segue identifier] isEqualToString:@"compose"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"profileSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ProfileViewController *profileController = (ProfileViewController*)navigationController.topViewController;
        Post *dataToPass = sender;
        profileController.user = dataToPass.author;
    }
}

@end
