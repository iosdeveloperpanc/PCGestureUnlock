
#import <UIKit/UIKit.h>

@interface PCLockLabel : UILabel



/*
 *  普通提示信息
 */
-(void)showNormalMsg:(NSString *)msg;


/*
 *  警示信息
 */
-(void)showWarnMsg:(NSString *)msg;

/*
 *  警示信息(shake)
 */
-(void)showWarnMsgAndShake:(NSString *)msg;

@end
