//
//  ViewController.m
//  XXLinkLabelDemo
//
//  Created by 王旭 on 2017/1/17.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "ViewController.h"
#import "XXLinkLabel.h"
#import "DemoTabelView.h"
#import "Masonry.h"
#import "XXLazyKitHeader.h"

@interface ViewController ()<UITextViewDelegate,DemoTabelViewDelegate>

@property (nonatomic , strong ) UITextView *textView;
@property (nonatomic , strong ) DemoTabelView *tabelView;
@property (nonatomic , strong ) UISegmentedControl *segment;
@property (nonatomic , strong ) XXLinkLabel *showLabel;


@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self segmentClick:self.segment];
    });
    
}


- (void)test {
    
    self.textView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.segment.backgroundColor = [UIColor whiteColor];
    
    
    self.tabelView.hidden = YES;
    self.tabelView.demoDelegate = self;
    self.showLabel.messageModels = [self getTestMessages];

    
    [self addColorButtons];
    [self addRegulerButtons];
    [self setupUI];
    
    
    _showLabel.numberOfLines = 0;
 
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];;
}

- (void)tabelViewMessageDidChanged:(NSArray<XXLinkLabelModel *> *)messageModels {
    self.showLabel.messageModels = messageModels;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.showLabel.text = textView.text;
}

- (void)labelImageClickLinkInfo:(XXLinkLabelModel *)linkInfo {
    NSLog(@"点击了图片对应的文字-------%@",linkInfo.message);
}

- (void)labelLinkClickLinkInfo:(XXLinkLabelModel *)linkInfo linkUrl:(NSString *)linkUrl {
    
    NSLog(@"点击了链接,链接地址为-------%@",linkUrl);
}

- (void)labelLinkLongPressLinkInfo:(XXLinkLabelModel *)linkInfo linkUrl:(NSString *)linkUrl {
    
    NSLog(@"长按了(点击)-----%@",linkUrl);
}

- (void)labelRegexLinkClickWithclickedString:(NSString *)clickedString {
    
    NSLog(@"点击了文字-------%@",clickedString);
}


- (void)setupUI {
    
    self.segment.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_segment]-40-|" options:0 metrics:nil views:@{@"_segment": _segment}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_segment(==30)]" options:0 metrics:nil views:@{@"_segment": _segment}]];
    
    
    
    
    
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_textView]-10-|" options:0 metrics:nil views:@{@"_textView": _textView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[_textView(==100)]" options:0 metrics:nil views:@{@"_textView": _textView}]];
    
    [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.textView);
    }];
    
//    [self.showLabel setPreferredMaxLayoutWidth:[UIScreen mainScreen].bounds.size.width - 20];
    self.showLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_showLabel]-10-|" options:0 metrics:nil views:@{@"_showLabel": _showLabel}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_showLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:260]];
    
}

- (void)buttonClick:(UIButton *)button {
    if (button.tag) {
        button.selected = !button.selected;
        self.showLabel.regularType = self.showLabel.regularType ^ button.tag;
    }else {
        self.showLabel.linkTextColor = button.backgroundColor;
    }
    
    if (self.tabelView.hidden) {
        self.showLabel.text = self.textView.text;
    }else {
        self.showLabel.messageModels = self.tabelView.messageModels;
    }
}

- (void)addColorButtons {
    NSArray *colors = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]];
    NSInteger count = colors.count;
    for (int i = 0; i < count; i++) {
        UIColor *color = colors[i];
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button.backgroundColor = color;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.width.equalTo(@20);
            make.top.equalTo(self.view).offset(80 + 20 * i);
            make.height.equalTo(@18);
        }];
    }
}

- (void)addRegulerButtons {
    NSArray *regulers = @[@"@xxx",@"#xxx#",@"http://"];
    NSInteger count = regulers.count;
    for (int i = 0; i < count; i++) {
        NSString *reguler = regulers[i];
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button.tag = 1<<i;
        [button setTitle:reguler forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(50);
            make.width.equalTo(@50);
            make.top.equalTo(self.view).offset(80 + 20 * i);
            make.height.equalTo(@18);
        }];
        if (random() % 2 == 0) {
            [self buttonClick:button];
        }
    }
}

- (void)segmentClick:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        self.textView.hidden = NO;
        self.tabelView.hidden = YES;
        self.showLabel.text = self.textView.text;
    }else {
        self.textView.hidden = YES;
        self.tabelView.hidden = NO;
        self.showLabel.messageModels = self.tabelView.messageModels;
    };
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        [self.view addSubview:_textView];
        _textView.delegate = self;
        _textView.text = @"#KINGLabel#This is a @KINGLabel Demo, access http://github.com/PittWong/KINGLabel can get the demo project. Follow @PittWong to get more information. 地lala图那时候is回家覅都是解放路口的设计方老师音乐hjkhjkdhshfdsfdskfdshjfkdsjkfjdsklfsd";
    }
    return _textView;
}


- (UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc]initWithItems:@[@"文本方式",@"model方式"]];
        [_segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex = 0;
        [self.view addSubview:_segment];
        
    }
    return _segment;
}
- (XXLinkLabel *)showLabel {
    if (!_showLabel) {
        XXLinkLabel *label = [[XXLinkLabel alloc]init];
        label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];

        label.font = [UIFont systemFontOfSize:15];
        label.delegate = self;
        
        label.imageClickBlock = ^(XXLinkLabelModel *linkInfo) {
            NSLog(@"block点击了图片对应的文字-------%@",linkInfo.message);
        };
        label.linkClickBlock = ^(XXLinkLabelModel *linkInfo, NSString *linkUrl) {
            NSLog(@"block点击了链接,链接地址为-------%@",linkUrl);
        };
        label.linkLongPressBlock = ^(XXLinkLabelModel *linkInfo, NSString *linkUrl) {
            NSLog(@"block长按了(点击)-----%@",linkUrl);
        };
        label.regularLinkClickBlock = ^(NSString *clickedString) {
            NSLog(@"block点击了文字-------%@",clickedString);
        };
//        label.regularType = XXLinkLabelRegularTypeAboat | XXLinkLabelRegularTypeTopic | XXLinkLabelRegularTypeUrl;
        _showLabel = label;
        [self.view addSubview:label];
    }
    return _showLabel;
}
XXLazyAnyView(DemoTabelView, tabelView, self.view)

- (NSArray *)getTestMessages {
    NSArray *arr = @[@"随便的一点文字",@"https://www.syswin.com http://192.168.1.1",@"不知道高点啥abc:994",@"就这么牛逼吧",@"can get the demo project. Follow @PittWong to get more information"];
    
    NSMutableArray *models = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        XXLinkLabelModel *messageModel = [[XXLinkLabelModel alloc]init];
        NSInteger number = i % 4;
        messageModel.message = number == 0 ? @"照片" : number == 1 ? @"地图" : arr[random() % 5];
        if ([messageModel.message isEqualToString:@"照片"]) {
            messageModel.imageName = @"111.jpg";
        }else if ([messageModel.message isEqualToString:@"地图"]) {
            messageModel.imageName = @"222.jpg";
            
        }
        [models addObject:messageModel];
    }
    return models;
}

@end
