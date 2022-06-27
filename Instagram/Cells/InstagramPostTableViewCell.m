//
//  InstagramPostTableViewCell.m
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/27/22.
//

#import "InstagramPostTableViewCell.h"

@implementation InstagramPostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    self.photoImageView.file = post[@"image"];
    self.captionLabel.text = post[@"caption"];
    [self.photoImageView loadInBackground];
}

@end
