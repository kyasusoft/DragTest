//
//  ViewController.m
//  dragTest
//
//  Created by kyasu on 2015/02/21.
//  Copyright (c) 2015年 kyasu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    CGAffineTransform _currentTransform;
    float _angle;
    float _scale;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _angle = 0.0;
    _scale = 1.0;
}

// gesture delegate
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 複数ジェスチャーの同時使用可とする
    return YES;
}

// ピンチジェスチャー
- (IBAction)pinch:(UIPinchGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // ジェスチャ開始時
        _currentTransform = _imageView.transform;
    }
    // 拡大率取得
    _scale = gesture.scale;
    // アフィン変換を適用
    [self applyAffain];
}

// ローテーションジェスチャー
- (IBAction)rotation:(UIRotationGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // ジェスチャ開始時
        _currentTransform = _imageView.transform;
    }
    // 回転角度取得
    _angle = gesture.rotation;
    // アフィン変換を適用
    [self applyAffain];
}

// パンジェスチャー
- (IBAction)pan:(UIPanGestureRecognizer *)gesture {
    // baseViewのcenterポジションを移動させる
    CGPoint p = [gesture translationInView:_baseView];
    CGPoint b = _baseView.center;
    _baseView.center = CGPointMake(b.x + p.x, b.y + p.y);
    
    // ドラッグで移動した距離を初期化しておく
    [gesture setTranslation:CGPointZero inView:_baseView];
    
    // imageViewも移動
    _imageView.center = _baseView.center;
}

// アファイン変換を適用
- (void)applyAffain {

    CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformConcat(_currentTransform,
                                                                                  CGAffineTransformMakeRotation(_angle)),
                                                          CGAffineTransformMakeScale(_scale, _scale));
    self.imageView.transform = transform;
    
    // viewの大きさを更新
    _baseView.frame = _imageView.frame;
}

// 位置とtransformを保存
- (void)saveTransform {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // _baseViewの位置
    [ud setFloat:_baseView.center.x forKey:@"x"];
    [ud setFloat:_baseView.center.y forKey:@"y"];
    
    // _imageViewのtransform
    CGAffineTransform tr = _imageView.transform;
    [ud setFloat:tr.a  forKey:@"ta"];
    [ud setFloat:tr.b  forKey:@"tb"];
    [ud setFloat:tr.c  forKey:@"tc"];
    [ud setFloat:tr.d  forKey:@"td"];
    [ud setFloat:tr.tx forKey:@"tx"];
    [ud setFloat:tr.ty forKey:@"ty"];
}

// 位置とtransformを復元
- (void)loadTransform {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    // _baseViewの位置
    float x = [ud floatForKey:@"x"];
    float y = [ud floatForKey:@"y"];
    _baseView.center  = CGPointMake(x, y);
    _imageView.center = CGPointMake(x, y);
    
    // アフィン変換を初期化
    _imageView.transform = CGAffineTransformIdentity;
    // 保存した変換を再現
    CGAffineTransform tr;
    tr.a  = [ud floatForKey:@"ta"];
    tr.b  = [ud floatForKey:@"ta"];
    tr.c  = [ud floatForKey:@"ta"];
    tr.d  = [ud floatForKey:@"ta"];
    tr.tx = [ud floatForKey:@"tx"];
    tr.ty = [ud floatForKey:@"ty"];
    _imageView.transform =tr;
    
    // アフィン変換を適用
    [self applyAffain];
}

@end
