
#import "ViewController.h"
#import "GestureViewController.h"
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"

@interface ViewController ()<UIAlertViewDelegate>

- (IBAction)BtnClick:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"手势解锁";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (IBAction)BtnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
        {
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeSetting;
            [self.navigationController pushViewController:gestureVc animated:YES];
        }
            break;
        case 2:
        {
            if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]) {
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeLogin];
                [self.navigationController pushViewController:gestureVc animated:YES];
            } else {
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未设置手势密码，是否前往设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                [alerView show];
            }
        }
            break;
        case 3:
        {
            GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
            [self.navigationController pushViewController:gestureVerifyVc animated:YES];
        }
            break;
            
        case 4:
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        GestureViewController *gestureVc = [[GestureViewController alloc] init];
        gestureVc.type = GestureViewControllerTypeSetting;
        [self.navigationController pushViewController:gestureVc animated:YES];
    }
}

@end
