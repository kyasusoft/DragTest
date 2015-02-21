//
//  ViewController.h
//  dragTest
//
//  Created by kyasu on 2015/02/21.
//  Copyright (c) 2015年 kyasu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<
UIGestureRecognizerDelegate
>

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)pinch:(id)sender;
- (IBAction)rotation:(id)sender;
- (IBAction)pan:(id)sender;

@end

