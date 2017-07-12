//
//  CurrentLocationViewController.m
//  Panda
//
//  Created by panda on 17/7/12.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "CurrentLocationViewController.h"

@interface CurrentLocationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *locTableView;

@end

@implementation CurrentLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutCurrentLocNav];
    [self layoutCurrentLocView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

- (void)layoutCurrentLocNav {
    
    self.navigationItem.title = @"定位当前地址";
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"panda_close"] style:UIBarButtonItemStyleDone target:self action:@selector(clostItemAction)];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    self.view.backgroundColor = kSET_COLOR_RBG(244, 245, 246, 1);
}

// MARK: -
- (void)layoutCurrentLocView {
    UILabel *currentLocLb = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 64.0f + 10.0f, 200, 15.0f)];
    currentLocLb.font = [UIFont systemFontOfSize:15];
    currentLocLb.textAlignment = NSTextAlignmentLeft;
    currentLocLb.textColor = kSET_COLOR_RBG(101, 102, 103, 1);
    currentLocLb.text = @"当前地址";
    [self.view addSubview:currentLocLb];
    
    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 64.0f + 10.0f + 15.0f + 10.0f, kXM_Width, 45)];
    locationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:locationView];
    
    UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kXM_Width * 0.6, 15)];
    
    CGFloat height = [self.currentLoc sizeWithFont:[UIFont systemFontOfSize:15.0f] withMaxSize:CGSizeMake(kXM_Width * 0.6, MAXFLOAT)].height;
    
    location.height = height;
    locationView.height = 30.0f + height;
    
    location.numberOfLines = 0;
    location.textColor = kSET_COLOR_RBG(51, 52, 53, 1);
    location.textAlignment = NSTextAlignmentLeft;
    location.font = [UIFont systemFontOfSize:15.0f];
    location.text = self.currentLoc;
    [locationView addSubview:location];
    
    UIButton *reLocate = [[UIButton alloc] initWithFrame:CGRectMake(kXM_Width - 90, 15, 80, 15)];
    [reLocate setTitle:@"\U0000e8a4 重新定位" forState:UIControlStateNormal];
    [reLocate setTitleColor:kSET_COLOR_RBG(26, 152, 252, 1) forState:UIControlStateNormal];
    reLocate.titleLabel.font = [UIFont fontWithName:@"iconfont" size:15.0];
    reLocate.contentHorizontalAlignment = NSTextAlignmentRight;
    [reLocate addTarget:self action:@selector(reLocateAction) forControlEvents:UIControlEventTouchUpInside];
    [locationView addSubview:reLocate];

    UILabel *nearbyLb = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(locationView.frame) + 10.0f, 200, 15)];
    nearbyLb.font = [UIFont systemFontOfSize:15];
    nearbyLb.textAlignment = NSTextAlignmentLeft;
    nearbyLb.textColor = kSET_COLOR_RBG(101, 102, 103, 1);
    nearbyLb.text = @"附近地址";
    [self.view addSubview:nearbyLb];
    
    // Table View
    self.locTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nearbyLb.frame) + 10.0f, kXM_Width, kXM_Height - CGRectGetMaxY(nearbyLb.frame)) style:UITableViewStylePlain];
    
    _locTableView.delegate = self;
    _locTableView.dataSource = self;
    [_locTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.view addSubview:_locTableView];
}

// MARK: -
- (void)clostItemAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reLocateAction {
    if ([_delegate respondsToSelector:@selector(xl_reposition)]) {
        [_delegate xl_reposition];
        [self clostItemAction];
    }
}

// MARK: -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = kSET_COLOR_RBG(51, 52, 53, 1);
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    AMapPOI *mapPOI = self.locationArray[indexPath.row];
    cell.textLabel.text = mapPOI.name;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(xl_currentLocation:)]) {
        [_delegate xl_currentLocation:self.locationArray[indexPath.row]];
        [self clostItemAction];
    }
}

@end
