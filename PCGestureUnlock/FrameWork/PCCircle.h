
#import <UIKit/UIKit.h>

/**
 *  单个圆的各种状态
 */
typedef enum{
    CircleStateNormal = 1,
    CircleStateSelected,
    CircleStateError,
    CircleStateLastOneSelected,
    CircleStateLastOneError
}CircleState;

/**
 *  单个圆的用途类型
 */
typedef enum
{
    CircleTypeInfo = 1,
    CircleTypeGesture
}CircleType;


/**
 *  方向
 */
typedef enum {
    
    //正上
    CircleDirectTop = 1,
    
    //右上1
    CircleDirectRightTopOne,
    
    //右上2
    CircleDirectRightTopTwo,
    
    //右上3
    CircleDirectRightTopThree,
    
    //右
    CircleDirectRight,
    
    //右下1
    CircleDirectRightBottomOne,
    
    //右下2
    CircleDirectRightBottomTwo,
    
    //右下3
    CircleDirectRightBottomThree,
    
    //下
    CircleDirectBottom,
    
    //左下1
    CircleDirectLeftBottomOne,
    
    //左下2
    CircleDirectLeftBottomTwo,
    
    //左下3
    CircleDirectLeftBottomThree,
    
    //左
    CircleDirectLeft,
    
    //左上1
    CircleDirectLeftTopOne,
    
    //左上2
    CircleDirectLeftTopTwo,
    
    //左上3
    CircleDirectLeftTopThree,
    
}CircleDirect;

@interface PCCircle : UIView

/**
 *  所处的状态
 */
@property (nonatomic, assign) CircleState state;

/**
 *  类型
 */
@property (nonatomic, assign) CircleType type;

/**
 *  是否有箭头 default is YES
 */
@property (nonatomic, assign) BOOL arrow;

/**
 *  箭头方向
 */
@property (nonatomic, assign) CircleDirect direct;

/** 角度 */
@property (nonatomic,assign) CGFloat angle;

@end
