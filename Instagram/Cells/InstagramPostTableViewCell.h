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

@interface InstagramPostTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet PFImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) NSArray *arrayOfLikes;
@end

NS_ASSUME_NONNULL_END
