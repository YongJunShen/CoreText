//
//  ViewController.m
//  CoreText
//
//  Created by vincent on 2022/6/21.
//

#import "ViewController.h"
#import "CustomTextView.h"
#import "CustomTextImageView.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CustomTextView *customView = [CustomTextView new];
//    customView.text = @"CoreText是⽤于处理⽂字和字体的底层技术。它直接和Core Graphics(⼜被称为Quartz)打交道。Quartz是⼀个2D图形渲染引擎，能够处理OSX和iOS中图形显⽰问题。与其他UI组件相⽐，由于CoreText直接和Quartz来交互，所以它具有更⾼效的排版功能。";
//    customView.backgroundColor = [UIColor whiteColor];
//    customView.frame = CGRectMake(0, 100, 200, 200);
//    [self.view addSubview:customView];
    
    
    CustomTextImageView *customTextImageView = [CustomTextImageView new];
    customTextImageView.backgroundColor = [UIColor whiteColor];
    customTextImageView.text = @"CoreText是⽤于处理⽂字和字体的底层技术。它直接和Core Graphics(⼜被称为Quartz)打交道。Quartz是⼀个2D图形渲染引擎，能够处理OSX和iOS中图形显⽰问题。与其他UI组件相⽐，由于CoreText直接和Quartz来交互，所以它具有更⾼效的排版功能。";
    customTextImageView.frame = CGRectMake(0, 100, 200, 200);
    [self.view addSubview:customTextImageView];
    
}


@end
