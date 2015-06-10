
#import "PCCircle.h"
#import "PCCircleViewConst.h"

@interface PCCircle()

/**
 *  外环颜色
 */
@property (nonatomic, strong) UIColor *outCircleColor;

/**
 *  实心圆颜色
 */
@property (nonatomic, strong) UIColor *inCircleColor;

/**
 *  三角形颜色
 */
@property (nonatomic, strong) UIColor *trangleColor;

@end

@implementation PCCircle

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = CircleBackgroundColor;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = CircleBackgroundColor;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat radio;
    CGRect circleRect = CGRectMake(CircleEdgeWidth, CircleEdgeWidth, rect.size.width - 2 * CircleEdgeWidth, rect.size.height - 2 * CircleEdgeWidth);
    
    if (self.type == CircleTypeGesture) {
        radio = CircleRadio;
    } else if (self.type == CircleTypeInfo) {
        radio = 1;
    }
    
    /**
     *  上下文旋转
     */
    [self transFormCtx:ctx rect:rect];
    
    // 画圆环
    [self drawEmptyCircleWithContext:ctx rect:circleRect color:self.outCircleColor];
    
    // 画实心圆
    [self drawSolidCircleWithContext:ctx rect:rect radio:radio color:self.inCircleColor];
 
    if (self.arrow) {

        // 画三角形箭头
        [self drawTrangleWithContext:ctx topPoint:CGPointMake(rect.size.width/2, 10) length:kTrangleLength color:self.trangleColor];
    }
}

- (void)drawEmptyCircleWithContext:(CGContextRef)ctx rect:(CGRect)rect color:(UIColor *)color
{
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    CGPathAddEllipseInRect(circlePath, NULL, rect);

    CGContextAddPath(ctx, circlePath);
    
    [color set];

    CGContextStrokePath(ctx);

    CGPathRelease(circlePath);
}


- (void)drawSolidCircleWithContext:(CGContextRef)ctx rect:(CGRect)rect radio:(CGFloat)radio color:(UIColor *)color
{
    //新建路径
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    //绘制一个
    CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(rect.size.width/2 * (1 - radio) + CircleEdgeWidth, rect.size.height/2 * (1 - radio) + CircleEdgeWidth, rect.size.width * radio - CircleEdgeWidth * 2, rect.size.height * radio - CircleEdgeWidth * 2));
    
    [color set];
    
    //将路径添加到上下文中
    CGContextAddPath(ctx, circlePath);
    
    //绘制圆环
    CGContextFillPath(ctx);
    
    //释放路径
    CGPathRelease(circlePath);
}

- (void)drawTrangleWithContext:(CGContextRef)ctx topPoint:(CGPoint)point length:(CGFloat)length color:(UIColor *)color
{
    //新建路径：三角形
    CGMutablePathRef trianglePathM = CGPathCreateMutable();
    
    CGPathMoveToPoint(trianglePathM, NULL, point.x, point.y);
    
    //添加左边点
    CGPathAddLineToPoint(trianglePathM, NULL, point.x - length/2, point.y + length/2);
    
    //右边的点
    CGPathAddLineToPoint(trianglePathM, NULL, point.x + length/2, point.y + length/2);
    
    //将路径添加到上下文中
    CGContextAddPath(ctx, trianglePathM);
    
    [color set];
    
    //绘制圆环
    CGContextFillPath(ctx);
    
    //释放路径
    CGPathRelease(trianglePathM);
}

/*
 *  上下文旋转
 */
-(void)transFormCtx:(CGContextRef)ctx rect:(CGRect)rect{
    
    if(self.direct == 0) return;
    
    CGFloat translateXY = rect.size.width * .5f;
    
    //平移
    CGContextTranslateCTM(ctx, translateXY, translateXY);
    
    CGContextRotateCTM(ctx, self.angle);
    
    //再平移回来
    CGContextTranslateCTM(ctx, -translateXY, -translateXY);
}

/**
 *  圆环绘制颜色的getter
 */
- (UIColor *)outCircleColor
{
    UIColor *color;
    switch (self.state) {
        case CircleStateNormal:
            color = CircleStateNormalOutsideColor;
            break;
        case CircleStateSelected:
            color = CircleStateSelectedOutsideColor;
            break;
        case CircleStateError:
            color = CircleStateErrorOutsideColor;
            break;
        case CircleStateLastOneSelected:
            color = CircleStateSelectedOutsideColor;
            break;
        case CircleStateLastOneError:
            color = CircleStateErrorOutsideColor;
            break;
        default:
            color = CircleStateNormalOutsideColor;
            break;
    }
    return color;
}

/**
 *  实心圆绘制颜色的getter
 */
- (UIColor *)inCircleColor
{
    UIColor *color;
    switch (self.state) {
        case CircleStateNormal:
            color = CircleStateNormalInsideColor;
            break;
        case CircleStateSelected:
            color = CircleStateSelectedInsideColor;
            break;
        case CircleStateError:
            color = CircleStateErrorInsideColor;
            break;
        case CircleStateLastOneSelected:
            color = CircleStateSelectedInsideColor;
            break;
        case CircleStateLastOneError:
            color = CircleStateErrorInsideColor;
            break;
        default:
            color = CircleStateNormalInsideColor;
            break;
    }
    return color;
}

/**
 *  三角形颜色的getter
 */
- (UIColor *)trangleColor
{
    UIColor *color;
    switch (self.state) {
        case CircleStateNormal:
            color = CircleStateNormalTrangleColor;
            break;
        case CircleStateSelected:
            color = CircleStateSelectedTrangleColor;
            break;
        case CircleStateError:
            color = CircleStateErrorTrangleColor;
            break;
        case CircleStateLastOneSelected:
            color = CircleStateNormalTrangleColor;
            break;
        case CircleStateLastOneError:
            color = CircleStateNormalTrangleColor;
            break;
        default:
            color = CircleStateNormalTrangleColor;
            break;
    }
    return color;
}

/**
 *  重写direct Setter
 */
- (void)setDirect:(CircleDirect)direct
{
    _direct = direct;
    
    self.angle = (M_PI_4/2) * (direct -1);
    
    [self setNeedsDisplay];
}

/**
 *  重写state Setter
 */
- (void)setState:(CircleState)state
{
    _state = state;
    
    [self setNeedsDisplay];
}


@end
