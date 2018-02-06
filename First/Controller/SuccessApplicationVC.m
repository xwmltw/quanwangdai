//
//  SuccessApplicationVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/13.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "SuccessApplicationVC.h"
#import "DataDetailVC.h"
#import "RecommendViewController.h"
#import "AllDKViewController.h"
#import "RecommendTableViewCell.h"
#import "ProductDetailVC.h"
#import "PersonalTailorVC.h"


@interface SuccessApplicationVC ()
{
    NSString *copyStr;
}
@property (nonatomic, strong) QueryParamModel *query_param;
@end

@implementation SuccessApplicationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //talkingdata
    [TalkingData trackEvent:@"申请成功页面"];
    
    [self prepareDataWithCount:0];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(56));
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableHeaderView = [self creatHeader];
    
    
    UIButton *btnContinue = [[UIButton alloc]init];
    btnContinue.tag = 100;
    [btnContinue setTitle:@"继续申请" forState:UIControlStateNormal];
    [btnContinue setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnContinue addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnContinue];
    
    UIButton *btnBack = [[UIButton alloc]init];
    btnBack.tag = 101;
    [btnBack setTitle:@"返回首页" forState:UIControlStateNormal];
    [btnBack setBackgroundColor:XColorWithRGB(255, 255, 255)];
    [btnBack setTitleColor:XColorWithRGB(252, 93, 109) forState:UIControlStateNormal];
    [btnBack  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    [btnContinue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(AdaptationWidth(188));
        make.height.mas_equalTo(AdaptationWidth(56));
    }];
    
    [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(AdaptationWidth(188));
        make.height.mas_equalTo(AdaptationWidth(56));
    }];
    
}
#pragma mark - tableviewdelegate
- (UIView *)creatHeader{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(411))];
    
    UIImageView *image = [[UIImageView alloc]init];
    [view addSubview:image];
    
    UILabel *labTitle = [[UILabel alloc]init];
    if (self.errCode.integerValue == 33) {
        [labTitle setText:@"申请通过率极低"];
        [image setImage:[UIImage imageNamed:@"dataDetail_low"]];
    }else{
        [image setImage:[UIImage imageNamed:@"notData"]];
        [labTitle setText:@"恭喜, 申请成功！"];
    }
    
    [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:labTitle];
    
    UILabel *labDetail = [[UILabel alloc]init];
    if (self.errCode.integerValue == 33) {
        [labDetail setText:@"小贷掐指一算，您的资质申请以下产品更容易通过哦！"];
    }else{
        if (self.applyProductModel.contact_wechat_public.length > 0) {
            [labDetail setText:@"请保持手机通畅，稍后会有工作人员与您联系；您也可以主动添加对方微信 公众号进行联系。"];
        }else if (self.applyProductModel.contact_qq.length > 0) {
            [labDetail setText:@"请保持手机通畅，稍后会有工作人员与您联系；您也可以主动添加对方QQ进行联系。"];
        }else{
            [labDetail setText:@"请保持手机通畅，稍后会有工作人员与您联系。"];
        }
    }
    labDetail.numberOfLines = 0;
    [labDetail setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [labDetail setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [view addSubview:labDetail];
    
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(AdaptationWidth(64));
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
    }];
    
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(labTitle.mas_bottom).offset(AdaptationWidth(4));
    }];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labDetail.mas_bottom).offset(AdaptationWidth(32));
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(161));
    }];
    
    
    
    
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.applyProductModel.contact_qq.length || self.applyProductModel.contact_wechat_public.length) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 68;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    
    if (self.applyProductModel.contact_qq.length || self.applyProductModel.contact_wechat_public.length) {
        if (section == 0) {
            UILabel *labTitle = [[UILabel alloc]init];
            if (self.applyProductModel.contact_wechat_public.length) {
                [labTitle setText:[NSString stringWithFormat:@"微信公众号：%@",self.applyProductModel.contact_wechat_public]];
                copyStr = self.applyProductModel.contact_wechat_public;
            }else{
                [labTitle setText:[NSString stringWithFormat:@"QQ：%@",self.applyProductModel.contact_qq]];
                copyStr = self.applyProductModel.contact_qq;
            }
            
            [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(16)]];
            [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
            [view addSubview:labTitle];
            
            [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view).offset(AdaptationWidth(16));
                make.centerY.mas_equalTo(view);
            }];
            
            UIButton *btnCopy = [[UIButton alloc]init];
            btnCopy.tag = 102;
            [btnCopy.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
            [btnCopy setTitle:@"复制" forState:UIControlStateNormal];
            [btnCopy setBackgroundColor:XColorWithRGB(252, 93, 109)];
            [btnCopy setTitleColor:XColorWithRGB(255, 255, 255) forState:UIControlStateNormal];
            [btnCopy setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
            [btnCopy addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btnCopy];
            
            [btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
                make.width.mas_equalTo(58);
                make.centerY.mas_equalTo(view);
            }];
            
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = XColorWithRGB(233, 233, 235);
            [view addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(view);
                make.height.mas_equalTo(0.5);
            }];
            return view;
        }
    }

        UILabel *labTitle = [[UILabel alloc]init];
        [labTitle setText:@"和您资质相近的产品"];
        [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
        [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
        [view addSubview:labTitle];
        
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view).offset(AdaptationWidth(16));
            make.centerY.mas_equalTo(view);
        }];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.applyProductModel.contact_qq.length || self.applyProductModel.contact_wechat_public.length) {
        if (section < 1) {
            return 0;
        }
    }
    if (self.dataSourceArr.count > 3) {
        return 3;
    }
    return self.dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RecommendCell";
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"RecommendCell" owner:nil options:nil].lastObject;
    }
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
    cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
    cell.model =[ProductModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]] ;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    //是否名额已满
    NSInteger row = [self.dataSourceArr[indexPath.row][@"apply_is_full"]integerValue];
    if (row == 1) {
        [self setHudWithName:@"名额已满" Time:0.5 andType:3];
        return;
    }
    
    ProductDetailVC *vc = [[ProductDetailVC alloc]init];
    vc.loan_pro_id = self.dataSourceArr[indexPath.row][@"loan_pro_id"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - btn
- (void)btnOnClick:(UIButton *)btn{
    if (btn.tag == 100) {
        if (self.dataSourceArr.count > 3) {
            PersonalTailorVC *vc = [[PersonalTailorVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            AllDKViewController *vc = [[AllDKViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (btn.tag == 101) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (btn.tag == 102) {
        [self setHudWithName:@"复制成功" Time:1 andType:1];
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = copyStr;
    }
}
#pragma  mark - request
- (void)setRequestParams{
    self.cmd = XGetRecommendLoanProList;
    self.dict = [self.query_param mj_keyValues];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    self.dataSourceArr = response.content[@"loan_pro_list"];
    [self.tableView reloadData];
}
- (QueryParamModel *)query_param{
    if (!_query_param) {
        _query_param = [[QueryParamModel alloc]init];
    }
    return _query_param;
}
#pragma  mark - 刷新
- (void)headerRefresh{
    [self prepareDataWithCount:0];
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
