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

    // パンジェスチャーをビューに登録
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(pan:)];
    pan.delegate = (id)self;
    [_baseView addGestureRecognizer:pan];
    
    // 回転ジェスチャをビューに登録
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(rotationGesture:)];
    rotation.delegate = (id)self;
    [_baseView addGestureRecognizer:rotation];
    
    // ピンチジェスチャをビューに登録
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(pinchGesture:)];
    pinch.delegate = (id)self;
    [_baseView addGestureRecognizer:pinch];
    
    _scale = 1.0f;
    _angle = 0.0f;
}

// gesture delegate
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 複数ジェスチャーの同時使用可とする
    return YES;
}

// 移動
- (void)pan:(UIPanGestureRecognizer *)pgr {
    
    // ドラッグで移動した距離を取得する
    CGPoint p = [pgr translationInView:_baseView];
    // centerポジションを移動させる
    CGPoint movedPoint = CGPointMake(_baseView.center.x + p.x, _baseView.center.y + p.y);
    _baseView.center = movedPoint;
    // ドラッグで移動した距離を初期化しておく
    [pgr setTranslation:CGPointZero inView:_baseView];

    // imageViewも移動
    _imageView.center = _baseView.center;
}

// 回転
- (void)rotationGesture:(UIRotationGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // ジェスチャ開始時
        _currentTransform = _imageView.transform;
    }
    // 回転角度取得
    _angle = gesture.rotation;
    // アフィン変換を適用
    [self applyAffain];
}

// 拡大・縮小
- (void)pinchGesture: (UIPinchGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // ジェスチャ開始時
        _currentTransform = _imageView.transform;
    }
    
    // 拡大率取得
    _scale = gesture.scale;
    // アフィン変換を適用
    [self applyAffain];
}

// アファイン変換適用
- (void)applyAffain {
    // アフィン変換を適用
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
