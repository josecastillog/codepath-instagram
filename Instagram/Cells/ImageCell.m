//
//  ImageCell.m
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/28/22.
//

#import "ImageCell.h"

@implementation ImageCell

- (void)setPost:(Post *)post {
    _post = post;
    self.imgView.file = post.image;
    [self.imgView loadInBackground];
}

@end
