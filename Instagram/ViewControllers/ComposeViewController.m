//
//  ComposeViewController.m
//  Instagram
//
//  Created by Jose Castillo Guajardo on 6/27/22.
//

#import "ComposeViewController.h"
#import "Post.h"
#import "MBProgressHUD.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextView *captionField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (strong, nonatomic) UIImage *uploadImage;
@property (strong, nonatomic) NSArray *arrayOfLikes;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.captionField.delegate = self;
    self.imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    tapGesture1.numberOfTapsRequired = 1;
    tapGesture1.delegate = self;
    [self.imgView addGestureRecognizer:tapGesture1];
    self.arrayOfLikes = PFUser.currentUser[@"arrayOfLikes"];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)tapGesture: (id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera unavailable so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    [self.imgView setImage:editedImage];
    self.uploadImage = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    NSString *caption = self.captionField.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
    self.shareButton.enabled = false;
    [Post postUserImage:self.uploadImage withCaption:caption withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error posting: %@", error.localizedDescription);
        } else {
            NSLog(@"Successfully uploaded image");
            [self.delegate didPost];
            [self dismissViewControllerAnimated:YES completion:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.captionField.text = @"";
    self.captionField.textColor = [UIColor blackColor];
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
