//
//  ViewController.h
//  Snapper
//
//  Created by Elymar Apao on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController : UIViewController <UINavigationControllerDelegate,
    UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UIImageView *imageView;
    UIActionSheet *picSheet;
    BOOL newMedia;

}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (strong, nonatomic) IBOutlet UIButton *takePicButton;
@property (strong, nonatomic) IBOutlet UIButton *takeGalPicButton;
@property (strong, nonatomic) IBOutlet UITextField *priceField;




- (IBAction)takePic:(id)sender;
- (IBAction)galPic:(id)sender;
- (IBAction)tweeetThis:(id)sender;

-(IBAction)done;


@end
