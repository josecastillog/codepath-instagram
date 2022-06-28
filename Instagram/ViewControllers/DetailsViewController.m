//
//  DetailsViewController.m
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/28/22.
//

#import "DetailsViewController.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setPost];
}

- (IBAction)didTapLike:(id)sender {
    [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)setPost {
    self.userLabel.text = self.post.author.username;
    self.photoImageView.file = self.post.image;
    self.captionLabel.text = self.post.caption;
    NSString *date = [NSDate shortTimeAgoSinceDate:self.post.createdAt];
    NSString *dateFormated = [date stringByAppendingString:@" ago"];
    self.timestampLabel.text = dateFormated;
    [self.photoImageView loadInBackground];
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
