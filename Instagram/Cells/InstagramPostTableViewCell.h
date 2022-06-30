//
//  InstagramPostTableViewCell.h
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate;

@interface InstagramPostTableViewCell : UITableViewCell <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet PFImageView *photoImageView;
@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) NSArray *arrayOfLikedPosts;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) id<PostCellDelegate> delegate;
@property BOOL liked;
@end

@protocol PostCellDelegate
- (void)postCell:(InstagramPostTableViewCell *) postCell didTap: (Post *)post;
@end

NS_ASSUME_NONNULL_END
