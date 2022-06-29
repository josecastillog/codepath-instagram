//
//  InstagramPostTableViewCell.m
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/27/22.
//

#import "InstagramPostTableViewCell.h"
#import "DateTools.h"

@implementation InstagramPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profileImageView addGestureRecognizer:profileTapGestureRecognizer];
    [self.userLabel addGestureRecognizer:profileTapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)tapGesture: (id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    NSLog(@"Did tap");
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
    NSLog(@"DidTap");
    [self.delegate postCell:self didTap:self.post];
}

- (IBAction)didTapLike:(id)sender {
    NSLog(@"Tapped like");
    NSLog(@"%@", self.post.objectId);
    [self.arrayOfLikes arrayByAddingObject:self.post.objectId];
    
    int likes = [self.post.likeCount intValue];
    likes += 1;
    self.post.likeCount = [NSNumber numberWithInt:likes];
    [self.post saveInBackground];
    
    // [PFUser.currentUser setObject:self.arrayOfLikes forKey:@"arrayOfLikes"];
    // [PFUser.currentUser saveInBackground];
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
}

@end
