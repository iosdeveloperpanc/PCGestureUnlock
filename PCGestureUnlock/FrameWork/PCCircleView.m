
#import "PCCircleView.h"
#import "PCCircle.h"
#import "PCCircleViewConst.h"

@interface PCCircleView()

// 选中的圆的集合
@property (nonatomic, strong) NSMutableArray *circleSet;

// 当前点
@property (nonatomic, assign) CGPoint currentPoint;

// 数组清空标志
@property (nonatomic, assign) BOOL hasClean;

@end

@implementation PCCircleView

#pragma mark - 重写arrow的setter
- (void)setArrow:(BOOL)arrow
{
    _arrow = arrow;
    
    // 遍历子控件，改变其是否有箭头
    [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
        [circle setArrow:arrow];
    }];
}

- (NSMutableArray *)circleSet
{
    if (_circleSet == nil) {
        _circleSet = [NSMutableArray array];
    }
    return _circleSet;
}

#pragma mark - 初始化方法：初始化type、clip、arrow
/**
 *  初始化方法
 *
 *  @param type  类型
 *  @param clip  是否剪裁
 *  @param arrow 三角形箭头
 */
- (instancetype)initWithType:(CircleViewType)type clip:(BOOL)clip arrow:(BOOL)arrow
{
    if (self = [super init]) {
        // 解锁视图准备
        [self lockViewPrepare];
        
        self.type = type;
        self.clip = clip;
        self.arrow = arrow;
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        // 解锁视图准备
        [self lockViewPrepare];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        // 解锁视图准备
        [self lockViewPrepare];
    }
    return self;
}

#pragma mark - 解锁视图准备
/*
 *  解锁视图准备
 */
-(void)lockViewPrepare{
    
    [self setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - CircleViewEdgeMargin * 2, [UIScreen mainScreen].bounds.size.width - CircleViewEdgeMargin * 2)];
    [self setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, CircleViewCenterY)];
    
    // 默认剪裁子控件
    [self setClip:YES];
    
    // 默认有箭头
    [self setArrow:YES];
    
    self.backgroundColor = CircleBackgroundColor;
    
    for (NSUInteger i=0; i<9; i++) {
        
        PCCircle *circle = [[PCCircle alloc] init];
        circle.type = CircleTypeGesture;
        circle.arrow = self.arrow;
        [self addSubview:circle];
    }
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat itemViewWH = CircleRadius * 2;
    CGFloat marginValue = (self.frame.size.width - 3 * itemViewWH) / 3.0f;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        
        NSUInteger row = idx % 3;
        
        NSUInteger col = idx / 3;
        
        CGFloat x = marginValue * row + row * itemViewWH + marginValue/2;
        
        CGFloat y = marginValue * col + col * itemViewWH + marginValue/2;
        
        CGRect frame = CGRectMake(x, y, itemViewWH, itemViewWH);
        
        // 设置tag -> 密码记录的单元
        subview.tag = idx + 1;
        
        subview.frame = frame;
    }];
}

#pragma mark - touch began - moved - end
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self gestureEndResetMembers];
    
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(circle.frame, point)) {
            [circle setState:CircleStateSelected];
            [self.circleSet addObject:circle];
        }
    }];
    
    // 数组中最后一个对象的处理
    [self circleSetLastObjectWithState:CircleStateLastOneSelected];
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
        
        if (CGRectContainsPoint(circle.frame, point)) {
            if ([self.circleSet containsObject:circle]) {
                
            } else {
                [self.circleSet addObject:circle];
                
                // move过程中的连线（包含跳跃连线的处理）
                [self calAngleAndconnectTheJumpedCircle];

            }
        } else {
            
            self.currentPoint = point;
        }
    }];
    
    [self.circleSet enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {

        [circle setState:CircleStateSelected];

        // 如果是登录或者验证原手势密码，就改为对应的状态
        if (self.type != CircleViewTypeSetting) {
            [circle setState:CircleStateLastOneSelected];
        }
    }];

    // 数组中最后一个对象的处理
    [self circleSetLastObjectWithState:CircleStateLastOneSelected];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setHasClean:NO];
    
    NSString *gesture = [self getGestureResultFromCircleSet:self.circleSet];
    CGFloat length = [gesture length];
    
    if (length == 0) {
        return;
    }

    // 手势绘制结果处理
    switch (self.type) {
        case CircleViewTypeSetting:
            [self gestureEndByTypeSettingWithGesture:gesture length:length];
            break;
        case CircleViewTypeLogin:
            [self gestureEndByTypeLoginWithGesture:gesture length:length];
            break;
        case CircleViewTypeVerify:
            [self gestureEndByTypeVerifyWithGesture:gesture length:length];
            break;
        default:
            [self gestureEndByTypeSettingWithGesture:gesture length:length];
            break;
    }
    
    // 手势结束后是否错误回显重绘，取决于是否延时清空数组和状态复原
    [self errorToDisplay];
}

#pragma mark - 是否错误回显重绘
/**
 *  是否错误回显重绘
 */
- (void)errorToDisplay
{
    if ([self getCircleState] == CircleStateError || [self getCircleState] == CircleStateLastOneError) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kdisplayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self gestureEndResetMembers];
            
        });
        
    } else {
        
        [self gestureEndResetMembers];
    }
}

#pragma mark - 手势结束时的清空操作
/**
 *  手势结束时的清空操作
 */
- (void)gestureEndResetMembers
{
    @synchronized(self) { // 保证线程安全
        if (!self.hasClean) {
            
            // 手势完毕，选中的圆回归普通状态
            [self changeCircleInCircleSetWithState:CircleStateNormal];
            
            // 清空数组
            [self.circleSet removeAllObjects];
            
            // 清空方向
            [self resetAllCirclesDirect];
            
            // 完成之后改变clean的状态
            [self setHasClean:YES];
        }
    }
}

#pragma mark - 获取当前选中圆的状态
- (CircleState)getCircleState
{
    return [(PCCircle *)[self.circleSet firstObject] state];
}

#pragma mark - 清空所有子控件的方向
- (void)resetAllCirclesDirect
{
    [self.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setAngle:0];
    }];
}

#pragma mark - 对数组中最后一个对象的处理
- (void)circleSetLastObjectWithState:(CircleState)state
{
    [[self.circleSet lastObject] setState:state];
}

#pragma mark - 解锁类型：设置 手势路径的处理
/**
 *  解锁类型：设置 手势路径的处理
 */
- (void)gestureEndByTypeSettingWithGesture:(NSString *)gesture length:(CGFloat)length
{
    if (length < CircleSetCountLeast) {
        // 连接少于最少个数 （<4个）
        
        // 1.通知代理
        if ([self.delegate respondsToSelector:@selector(circleView:type:connectCirclesLessThanNeedWithGesture:)]) {
            [self.delegate circleView:self type:self.type connectCirclesLessThanNeedWithGesture:gesture];
        }
        
        // 2.改变状态为error
        [self changeCircleInCircleSetWithState:CircleStateError];
        
    } else {// 连接多于最少个数 （>=4个）
        
        NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];
        
        if ([gestureOne length] < CircleSetCountLeast) { // 接收并存储第一个密码
            // 记录第一次密码
            [PCCircleViewConst saveGesture:gesture Key:gestureOneSaveKey];
            
            // 通知代理
            if ([self.delegate respondsToSelector:@selector(circleView:type:didCompleteSetFirstGesture:)]) {
                [self.delegate circleView:self type:self.type didCompleteSetFirstGesture:gesture];
            }
            
        } else { // 接受第二个密码并与第一个密码匹配，一致后存储起来
            
            BOOL equal = [gesture isEqual:[PCCircleViewConst getGestureWithKey:gestureOneSaveKey]]; // 匹配两次手势
            
            // 通知代理
            if ([self.delegate respondsToSelector:@selector(circleView:type:didCompleteSetSecondGesture:result:)]) {
                
                [self.delegate circleView:self type:self.type didCompleteSetSecondGesture:gesture result:equal];
                
            }
            
            if (equal){
                // 一致，存储密码
                [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
                
            } else {
                // 不一致，重绘回显
                [self changeCircleInCircleSetWithState:CircleStateError];
            }
        }
        
    }
}

#pragma mark - 解锁类型：登陆 手势路径的处理
/**
 *  解锁类型：登陆 手势路径的处理
 */
- (void)gestureEndByTypeLoginWithGesture:(NSString *)gesture length:(CGFloat)length
{
    NSString *password = [PCCircleViewConst getGestureWithKey:gestureFinalSaveKey];
    
    BOOL equal = [gesture isEqual:password];
    
    if ([self.delegate respondsToSelector:@selector(circleView:type:didCompleteLoginGesture:result:)]) {
        [self.delegate circleView:self type:self.type didCompleteLoginGesture:gesture result:equal];
    }
    
    if (equal) {
        
    } else {

        [self changeCircleInCircleSetWithState:CircleStateError];
    }
}

#pragma mark - 解锁类型：验证 手势路径的处理
- (void)gestureEndByTypeVerifyWithGesture:(NSString *)gesture length:(CGFloat)length
{
    //    NSString *password = [CircleViewConst getGestureWithKey:gestureFinalSaveKey];
    //
    //    BOOL equal = [gesture isEqual:password];
    //
    //    if ([self.delegate respondsToSelector:@selector(circleView:type:didCompleteLoginGesture: result:)]) {
    //        [self.delegate circleView:self type:self.type didCompleteLoginGesture:gesture result:equal];
    //    }
    //
    //    if (equal) {
    //
    //    } else {
    //        [self changeCircleInCircleSetWithState:CircleStateError];
    //    }
    [self gestureEndByTypeLoginWithGesture:gesture length:length];
}

#pragma mark - 改变选中数组CircleSet子控件状态
- (void)changeCircleInCircleSetWithState:(CircleState)state
{
    [self.circleSet enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {

        [circle setState:state];

        // 如果是错误状态，那就将最后一个按钮特殊处理
        if (state == CircleStateError) {
            if (idx == self.circleSet.count - 1) {
                [circle setState:CircleStateLastOneError];
            }
        }

    }];
    
    [self setNeedsDisplay];
}

#pragma mark - 将circleSet数组解析遍历，拼手势密码字符串
- (NSString *)getGestureResultFromCircleSet:(NSMutableArray *)circleSet
{
    NSMutableString *gesture = [NSMutableString string];
    
    for (PCCircle *circle in circleSet) {
        // 遍历取tag拼字符串
        [gesture appendFormat:@"%@", @(circle.tag)];
    }
    
    return gesture;
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect
{
    // 如果没有任何选中按钮， 直接retrun
    if (self.circleSet == nil || self.circleSet.count == 0) return;
    
    UIColor *color;
    if ([self getCircleState] == CircleStateError) {
        color = CircleConnectLineErrorColor;
    } else {
        color = CircleConnectLineNormalColor;
    }
    
    // 绘制图案
    [self connectCirclesInRect:rect lineColor:color];
}

#pragma mark - 连线绘制图案(以设定颜色绘制)
/**
 *  将选中的圆形以color颜色链接起来
 *
 *  @param rect  图形上下文
 *  @param color 连线颜色
 */
- (void)connectCirclesInRect:(CGRect)rect lineColor:(UIColor *)color
{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加路径
    CGContextAddRect(ctx, rect);
    
    //是否剪裁
    [self clipSubviewsWhenConnectInContext:ctx clip:self.clip];
    
    //剪裁上下文
    CGContextEOClip(ctx);
    
    // 遍历数组中的circle
    for (int index = 0; index < self.circleSet.count; index++) {
        
        // 取出选中按钮
        PCCircle *circle = self.circleSet[index];
        
        if (index == 0) { // 起点按钮
            CGContextMoveToPoint(ctx, circle.center.x, circle.center.y);
        }else{
            CGContextAddLineToPoint(ctx, circle.center.x, circle.center.y); // 全部是连线
        }
    }
    
    // 连接最后一个按钮到手指当前触摸得点
    if (CGPointEqualToPoint(self.currentPoint, CGPointZero) == NO) {
        
        [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
            
            if ([self getCircleState] == CircleStateError || [self getCircleState] == CircleStateLastOneError) {
                // 如果是错误的状态下不连接到当前点
                
            } else {
                
                CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
                
            }
        }];
    }
    
    //线条转角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    // 设置绘图的属性
    CGContextSetLineWidth(ctx, CircleConnectLineWidth);
    
    // 线条颜色
    [color set];
    
    //渲染路径
    CGContextStrokePath(ctx);
}

#pragma mark - 是否剪裁
/**
 *  是否剪裁子控件
 *
 *  @param ctx  图形上下文
 *  @param clip 是否剪裁
 */
- (void)clipSubviewsWhenConnectInContext:(CGContextRef)ctx clip:(BOOL)clip
{
    if (clip) {
        
        // 遍历所有子控件
        [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
            
            CGContextAddEllipseInRect(ctx, circle.frame); // 确定"剪裁"的形状
        }];
    }
}

#pragma mark - 每添加一个圆，就计算一次方向
-(void)calAngleAndconnectTheJumpedCircle{
    
    if(self.circleSet == nil || [self.circleSet count] <= 1) return;
    
    //取出最后一个对象
    PCCircle *lastOne = [self.circleSet lastObject];
    
    //倒数第二个
    PCCircle *lastTwo = [self.circleSet objectAtIndex:(self.circleSet.count -2)];
    
    //计算倒数第二个的位置
    CGFloat last_1_x = lastOne.center.x;
    CGFloat last_1_y = lastOne.center.y;
    CGFloat last_2_x = lastTwo.center.x;
    CGFloat last_2_y = lastTwo.center.y;
    
    // 1.计算角度（反正切函数）
    CGFloat angle = atan2(last_1_y - last_2_y, last_1_x - last_2_x) + M_PI_2;
    [lastTwo setAngle:angle];
    
    // 2.处理跳跃连线
    CGPoint center = [self centerPointWithPointOne:lastOne.center pointTwo:lastTwo.center];
    
    PCCircle *centerCircle = [self enumCircleSetToFindWhichSubviewContainTheCenterPoint:center];
    
    if (centerCircle != nil) {
        
        // 把跳过的圆加到数组中，它的位置是倒数第二个
        if (![self.circleSet containsObject:centerCircle]) {
            [self.circleSet insertObject:centerCircle atIndex:self.circleSet.count - 1];
        }
    }
}

#pragma mark - 提供两个点，返回一个它们的中点
- (CGPoint)centerPointWithPointOne:(CGPoint)pointOne pointTwo:(CGPoint)pointTwo
{
    CGFloat x1 = pointOne.x > pointTwo.x ? pointOne.x : pointTwo.x;
    CGFloat x2 = pointOne.x < pointTwo.x ? pointOne.x : pointTwo.x;
    CGFloat y1 = pointOne.y > pointTwo.y ? pointOne.y : pointTwo.y;
    CGFloat y2 = pointOne.y < pointTwo.y ? pointOne.y : pointTwo.y;
    
    return CGPointMake((x1+x2)/2, (y1 + y2)/2);
}

#pragma mark - 给一个点，判断这个点是否被圆包含，如果包含就返回当前圆，如果不包含返回的是nil
/**
 *  给一个点，判断这个点是否被圆包含，如果包含就返回当前圆，如果不包含返回的是nil
 *
 *  @param point 当前点
 *
 *  @return 点所在的圆
 */
- (PCCircle *)enumCircleSetToFindWhichSubviewContainTheCenterPoint:(CGPoint)point
{
    PCCircle *centerCircle;
    for (PCCircle *circle in self.subviews) {
        if (CGRectContainsPoint(circle.frame, point)) {
            centerCircle = circle;
        }
    }
    
    if (![self.circleSet containsObject:centerCircle]) {
        // 这个circle的角度和倒数第二个circle的角度一致
        centerCircle.angle = [[self.circleSet objectAtIndex:self.circleSet.count - 2] angle];
    }
    
    return centerCircle; // 注意：可能返回的是nil，就是当前点不在圆内
}

@end
