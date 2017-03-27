//
//  ViewController.m
//  TableViewRefresh
//
//  Created by ycl on 2017/3/27.
//  Copyright © 2017年 ycl. All rights reserved.
//

#import "ViewController.h"
#import "SCRefresh.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *contentView;

@property (nonatomic) NSUInteger size;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController


#pragma mark - initializer


#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.contentView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.contentView.delegate = self;
    self.contentView.dataSource = self;
    
    self.contentView.refresh.backgroundColor = [UIColor blueColor];
    self.contentView.refresh = [ SCRefresh refreshWithTarget:self HeaderAction:@selector(refresh) FooterAction:@selector(loadMore)];
    
    self.size = 20;
    [self modelChanged];
}


#pragma mark - UITableViewDelegate methods
#pragma mark - UITableViewDataSource methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell*) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}


#pragma mark - common methods

-(void) refresh{
    self.size = 20;
    NSLog(@" %s ", __func__);
    [self.dataSource removeAllObjects];
    __weak __typeof__(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [weakSelf modelChanged];
        [weakSelf.contentView.refresh endRefreshRefreshType:RefreshOptionHeader];
    });
//    [self modelChanged];
    
    
}

-(void) loadMore{
    self.size +=5;
    NSLog(@" %s ", __func__);
    __weak __typeof__(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf modelChanged];
        [weakSelf.contentView.refresh endRefreshRefreshType:RefreshOptionFooter];
    });
}

-(void) modelChanged{
    [self initDataSource];
    [self.contentView reloadData];
}

-(void) initDataSource{
    [self.dataSource removeAllObjects];
    for(int i =0; i<self.size; i++){
        [self.dataSource addObject: [NSString stringWithFormat:@"这是第%d行", i]];
    }
}

#pragma mark - properties


-(id) dataSource{
    if(_dataSource == nil){
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
