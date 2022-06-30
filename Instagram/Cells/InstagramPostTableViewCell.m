//
//  InstagramPostTableViewCell.m
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/27/22.
//

#import "InstagramPostTableViewCell.h"
#import "DateTools.h"
#import "Likes.h"

@implementation InstagramPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizerImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizerImg];
    [self.profileImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *profileTapGestureRecognizerLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.userLabel addGestureRecognizer:profileTapGestureRecognizerLabel];
    [self.userLabel setUserInteractionEnabled:YES];
}

- (void)setLikeStatus {
    self.liked = NO;
    for (NSDictionary *dictionary in self.arrayOfLikedPosts) {
        NSString *likedPostID = dictionary[@"postID"];
        if ([self.post.objectId isEqualToString:likedPostID]){
            self.liked = YES;
        }
    }
    [self setLikeButtonImage];
}

- (void)setLikeButtonImage {
    if (self.liked == YES) {
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)tapGesture: (id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
}

- (void)setPost:(Post *)post {
    _post = post;
    self.photoImageView.file = post.image;
    self.captionLabel.text = post.caption;
    self.userLabel.text = post.author.username;
    NSString *likeCount = [NSString stringWithFormat:@"%@", self.post.likeCount];;
    self.likesLabel.text = [@"Liked by " stringByAppendingString:likeCount];
    NSString *date = [NSDate shortTimeAgoSinceDate:self.post.createdAt];
    NSString *dateFormated = [date stringByAppendingString:@" ago"];
    self.timestampLabel.text = dateFormated;
    [self.photoImageView loadInBackground];
    [self setProfileImage];
    [self setLikeStatus];
}

- (void)setProfileImage {
    self.profileImageView.userInteractionEnabled = YES;
    self.profileImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.layer.borderWidth = 0;
    self.profileImageView.clipsToBounds = YES;
    if (self.post.author[@"profileImage"]) {
        self.profileImageView.file = self.post.author[@"profileImage"];
        [self.profileImageView loadInBackground];
    }
}

-(void)didTapUserProfile:(UITapGestureRecognizer *)sender {
    [self.delegate postCell:self didTap:self.post];
}

- (IBAction)didTapLike:(id)sender {
    int likes = [self.post.likeCount intValue];
    if (self.liked == NO) {
        self.liked = YES;
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        Likes *likedPost = [Likes new];
        [likedPost setObject:self.post.objectId forKey:@"postID"];
        [likedPost setObject:PFUser.currentUser forKey:@"userThatLiked"];
        [likedPost saveInBackground];
        likes += 1;
    } else {
        self.liked = NO;
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        PFQuery *likesQuery = [Likes query];
        [likesQuery includeKey:@"postID"];
        [likesQuery includeKey:@"userThatLiked"];
        [likesQuery whereKey:@"userThatLiked" equalTo:PFUser.currentUser];
        [likesQuery whereKey:@"postID" equalTo:self.post.objectId];
        likes -= 1;
        [likesQuery findObjectsInBackgroundWithBlock:^(NSArray<Likes *> * _Nullable likes, NSError * _Nullable error) {
            if (likes.count > 0) {
                [likes[0] deleteEventually];
            }
            else {
                NSLog(@"Error deleting: %@", error.localizedDescription);
            }
        }];
    }
    self.post.likeCount = [NSNumber numberWithInt:likes];
    NSString *likeCount = [NSString stringWithFormat:@"%@", self.post.likeCount];;
    self.likesLabel.text = [@"Liked by " stringByAppendingString:likeCount];
    [self.post saveInBackground];
}

@end
