//
//  HomeViewController.m
//  PCGestureUnlock
//
//  Created by panchao on 2017/6/21.
//  Copyright © 2017年 coderMonkey. All rights reserved.
//

#import "HomeViewController.h"
#import "GestureViewController.h"
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeSetting;
            [self.navigationController pushViewController:gestureVc animated:YES];
        }
            break;
        case 1:
        {
            if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]) {
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeLogin];
                [self.navigationController pushViewController:gestureVc animated:YES];
            } else {

                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂未设置手势密码，是否前往设置？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *set = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    GestureViewController *gestureVc = [[GestureViewController alloc] init];
                    gestureVc.type = GestureViewControllerTypeSetting;
                    [self.navigationController pushViewController:gestureVc animated:YES];
                }];
                [alertVc addAction:cancel];
                [alertVc addAction:set];
                [self presentViewController:alertVc animated:YES
                                 completion:nil];
            }
        }
            break;
        case 2:
        {
            GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
            [self.navigationController pushViewController:gestureVerifyVc animated:YES];
        }
            break;

        case 3:
        {
            GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
            gestureVerifyVc.isToSetNewGesture = YES;
            [self.navigationController pushViewController:gestureVerifyVc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
