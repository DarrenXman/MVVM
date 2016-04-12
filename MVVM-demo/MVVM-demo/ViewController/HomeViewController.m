//
//  HomeViewController.m
//  MVVM-demo
//
//  Created by shen_gh on 16/4/12.
//  Copyright © 2016年 申冠华. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableView.h"
#import "HomeTableViewCell.h"
#import "HomeViewModel.h"
#import "Define.h"

@interface HomeViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) HomeTableView *homeTableView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"iOS头条"];
    
    self.dataArr=[NSMutableArray array];
    
    //布局View
    [self setUpView];
    //数据处理
    [self dataAccess];
}

#pragma mark - setUpView
- (void)setUpView{
    [self.view addSubview:self.homeTableView];
}

- (HomeTableView *)homeTableView{
    if (!_homeTableView) {
        _homeTableView=[[HomeTableView alloc]initWithFrame:self.view.bounds];
        [_homeTableView setDelegate:self];
        [_homeTableView setDataSource:self];
        [_homeTableView setRowHeight:100.0];
    }
    return _homeTableView;
}

#pragma mark DataAccess
- (void)dataAccess{
    HomeViewModel *homeViewModel=[[HomeViewModel alloc]init];
    
    __WeakSelf__ wSelf=self;
    [homeViewModel handleDataWithSuccess:^(NSArray *arr) {
        
        [wSelf.dataArr removeAllObjects];
        [wSelf.dataArr addObjectsFromArray:arr];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [wSelf.homeTableView reloadData];
        });
        
    } failure:^(NSError *error) {
        NSLog(@"请求失败 error:%@",error.description);
    }];
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - UITableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"cellIde";
    HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
