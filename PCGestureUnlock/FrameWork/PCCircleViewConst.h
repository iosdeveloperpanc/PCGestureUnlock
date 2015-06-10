
#import <Foundation/Foundation.h>

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

/**
 *  单个圆背景色
 */
#define CircleBackgroundColor [UIColor clearColor]

/**
 *  解锁背景色
 */
#define CircleViewBackgroundColor rgba(13,52,89,1)

/**
 *  普通状态下外空心圆颜色
 */
#define CircleStateNormalOutsideColor rgba(241,241,241,1)

/**
 *  选中状态下外空心圆颜色
 */
#define CircleStateSelectedOutsideColor rgba(34,178,246,1)

/**
 *  错误状态下外空心圆颜色
 */
#define CircleStateErrorOutsideColor rgba(254,82,92,1)

/**
 *  普通状态下内实心圆颜色
 */
#define CircleStateNormalInsideColor [UIColor clearColor]

/**
 *  选中状态下内实心圆颜色
 */
#define CircleStateSelectedInsideColor rgba(34,178,246,1)

/**
 *  错误状态内实心圆颜色
 */
#define CircleStateErrorInsideColor rgba(254,82,92,1)

/**
 *  普通状态下三角形颜色
 */
#define CircleStateNormalTrangleColor [UIColor clearColor]

/**
 *  选中状态下三角形颜色
 */
#define CircleStateSelectedTrangleColor rgba(34,178,246,1)

/**
 *  错误状态三角形颜色
 */
#define CircleStateErrorTrangleColor rgba(254,82,92,1)

/**
 *  三角形边长
 */
#define kTrangleLength 10.0f

/**
 *  普通时连线颜色
 */
#define CircleConnectLineNormalColor rgba(34,178,246,1)

/**
 *  错误时连线颜色
 */
#define CircleConnectLineErrorColor rgba(254,82,92,1)

/**
 *  连线宽度
 */
#define CircleConnectLineWidth 1.0f

/**
 *  单个圆的半径
 */
#define CircleRadius 30.0f

/**
 *  单个圆的圆心
 */
#define CircleCenter CGPointMake(CircleRadius, CircleRadius)

/**
 *  空心圆圆环宽度
 */
#define CircleEdgeWidth 1.0f

/**
 *  九宫格展示infoView 单个圆的半径
 */
#define CircleInfoRadius 5

/**
 *  内部实心圆占空心圆的比例系数
 */
#define CircleRadio 0.4

/**
 *  整个解锁View居中时，距离屏幕左边和右边的距离
 */
#define CircleViewEdgeMargin 30.0f

/**
 *  整个解锁View的Center.y值 在当前屏幕的3/5位置
 */
#define CircleViewCenterY kScreenH * 3/5

/**
 *  连接的圆最少的个数
 */
#define CircleSetCountLeast 4

/**
 *  错误状态下回显的时间
 */
#define kdisplayTime 1.0f

/**
 *  最终的手势密码存储key
 */
#define gestureFinalSaveKey @"gestureFinalSaveKey"

/**
 *  第一个手势密码存储key
 */
#define gestureOneSaveKey @"gestureOneSaveKey"

/**
 *  普通状态下文字提示的颜色
 */
#define textColorNormalState rgba(241,241,241,1)

/**
 *  警告状态下文字提示的颜色
 */
#define textColorWarningState rgba(254,82,92,1)

/**
 *  绘制解锁界面准备好时，提示文字
 */
#define gestureTextBeforeSet @"绘制解锁图案"

/**
 *  设置时，连线个数少，提示文字
 */
#define gestureTextConnectLess [NSString stringWithFormat:@"最少连接%d个点，请重新输入", CircleSetCountLeast]

/**
 *  确认图案，提示再次绘制
 */
#define gestureTextDrawAgain @"再次绘制解锁图案"

/**
 *  再次绘制不一致，提示文字
 */
#define gestureTextDrawAgainError @"与上次绘制不一致，请重新绘制"

/**
 *  设置成功
 */
#define gestureTextSetSuccess @"设置成功"

/**
 *  请输入原手势密码
 */
#define gestureTextOldGesture @"请输入原手势密码"

/**
 *  密码错误
 */
#define gestureTextGestureVerifyError @"密码错误"

@interface PCCircleViewConst : NSObject

/**
 *  偏好设置：存字符串（手势密码）
 *
 *  @param gesture 字符串对象
 *  @param key     存储key
 */
+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key;

/**
 *  偏好设置：取字符串手势密码
 *
 *  @param key key
 *
 *  @return 字符串对象
 */
+ (NSString *)getGestureWithKey:(NSString *)key;

@end
