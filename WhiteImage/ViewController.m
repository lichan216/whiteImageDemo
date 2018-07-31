//
//  ViewController.m
//  WhiteImage
//
//  Created by libertychen on 2018/7/19.
//  Copyright © 2018年 libertychen. All rights reserved.
//

#import "ViewController.h"

#define  CELL_ROW_HEIGHT       100
#define  CELL_IMAGEVIEW_TAG    1000
#define  IMAGE_DATA_COUNT      2
#define  ROW_IMAGE_COUNT       3

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UILabel *remindLabel;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, windowFrame.size.width - 20 *2, 60)];
    self.remindLabel.text = @"row 2 is showing colorful image, but decoded all white";
    self.remindLabel.numberOfLines = 0;
    [self.view addSubview:_remindLabel];
    
    CGRect frame = windowFrame;
    frame.origin.y += 100;
    frame.size.height -= (100 + 20);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        CGFloat imgViewMargin = 5;
        CGFloat imgViewWidth = ([UIScreen mainScreen].bounds.size.width - imgViewMargin * 2)/ROW_IMAGE_COUNT - imgViewMargin;
        for (NSUInteger i = 0; i < ROW_IMAGE_COUNT; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewMargin + (imgViewMargin + imgViewWidth) * i, imgViewMargin, imgViewWidth, (CELL_ROW_HEIGHT - imgViewMargin * 2))];
            imgView.clipsToBounds = YES;
            imgView.tag = CELL_IMAGEVIEW_TAG + i;
            imgView.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:imgView];
        }
    }
    
    NSString *resourceName = [NSString stringWithFormat:@"whiteData%zd", indexPath.row%IMAGE_DATA_COUNT];
    NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"heic"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // !!! when use whiteData1.heic, image is all white, but it is colorful in fact
    UIImage *image = [UIImage imageWithData:data];
    
    for (NSUInteger i = 0; i < ROW_IMAGE_COUNT; i++) {
        UIImageView *imgView = [cell.contentView viewWithTag:CELL_IMAGEVIEW_TAG + i];
        imgView.image = image;
    }
    return cell;
}
@end
