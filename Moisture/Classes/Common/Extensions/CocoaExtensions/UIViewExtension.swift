import UIKit
import ObjectiveC.runtime


private var AddImage_Key: UInt8 = 0

private var GestureClosure_Key: Void?

public typealias CustomGestureClosure = (_ recognizer: UIGestureRecognizer) -> Void

public class GestureClosureWrapper: NSObject {
    public var closure: CustomGestureClosure
    public init(closure: @escaping CustomGestureClosure) {
        self.closure = closure
    }
}


// MARK: - 在View上下文添加Image图像

public extension UIView {
    
    /// Moisture： 在View上下文添加Image图像 / Add Image to UIView Context
    var addContextImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &AddImage_Key) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &AddImage_Key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                        
            // 将设置的图片展示在UIView上
            let layer = CALayer()
            layer.frame = self.bounds
            layer.contents = newValue?.cgImage
            self.layer.addSublayer(layer)
        }
    }
}


// MARK: - addsubview (添加子视图)

public extension UIView {
    
    /// Moisture: 添加单个视图 / Add a single view
    @discardableResult
    func add(subview: UIView) -> Self {
        addSubview(subview)
        return self
    }
    
    /// Moisture: 添加多个视图 / Adding Multiple Views
    func add(_ layers: UIView...) {
        layers.forEach { addSubview($0) }
    }
}


// MARK: - UIGestureRecognizer (自定义手势)

extension UIView: @retroactive UIGestureRecognizerDelegate {
    
    private struct AssociatedKeys {
        static var isAllowOutOfBounds = "isAllowOutOfBounds"
        static var swipeThreshold = "swipeThreshold"
    }

    
    /// 是否允许越界
    private var isAllowOutOfBounds: Bool {
        get {
            // 获取关联对象的值，如果没有设置，默认为 true
            return objc_getAssociatedObject(self, &AssociatedKeys.isAllowOutOfBounds) as? Bool ?? true
        }
        set {
            // 设置关联对象的值
            objc_setAssociatedObject(self, &AssociatedKeys.isAllowOutOfBounds, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 滑动临界值
    private var swipeThreshold: CGFloat {
        get {
            // 获取关联对象的值，如果没有设置，默认为 true
            return objc_getAssociatedObject(self, &AssociatedKeys.swipeThreshold) as? CGFloat ?? 0.0
        }
        set {
            // 设置关联对象的值
            objc_setAssociatedObject(self, &AssociatedKeys.swipeThreshold, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Moisture: 移除手势 / Remove Gesture
    @discardableResult
    public func removeGesture(_ recognizer: UIGestureRecognizer) -> Self {
        removeGestureRecognizer(recognizer)
        return self
    }
    
    /// Moisture: 移除手势组 / Remove a gesture group
    @discardableResult
    public func removeGestures(_ recognizers: [UIGestureRecognizer]) -> Self {
        for recognizer in recognizers {
            removeGestureRecognizer(recognizer)
        }
        return self
    }
    
    /// Moisture: 添加任意手势 / Add any gesture
    @discardableResult
    public func addGesture(_ recognizer: UIGestureRecognizer) -> Self {
        addGestureRecognizer(recognizer)
        return self
    }
    
    /*
     example:
     setGesture([UITapGestureRecognizer(), UILongPressGestureRecognizer()]) { sender in
     if sender is UITapGestureRecognizer {
        print("This is UITapGestureRecognizer")
     }else {
        print("This is UILongPressGestureRecognizer")
     }
     */
    /// Moisture: 设置自定义手势
    public func setGesture(recognizers: [UIGestureRecognizer] = [UITapGestureRecognizer()], action: @escaping CustomGestureClosure) {
        objc_setAssociatedObject(self, &GestureClosure_Key, GestureClosureWrapper(closure: action), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        for recognizer in recognizers {
            addGestureRecognizer(recognizer)
            recognizer.addTarget(self, action: #selector(handleGesture(sender:)))
        }
    }
    
    @objc func handleGesture(sender: UIGestureRecognizer) {
        (objc_getAssociatedObject(self, &GestureClosure_Key) as? GestureClosureWrapper)?.closure(sender)
    }
    
    /// Moisture: 添加滑动拖拽手势 (X轴)
    ///   - swipeThreshold: 临界值(滑动阈值)
    public func addSlideable_X(swipeThreshold: CGFloat = 210.0, _ slideHandle: ((SwipeDirection.horizontal) -> Void)?) {
        self.swipeThreshold = swipeThreshold
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.delegate = self // 添加此行以处理手势识别器冲突
        self.isUserInteractionEnabled = true
        
        // 初始化视图原始Center
        var initialCenter: CGPoint!
        
        self.setGesture(recognizers: [panGesture]) { recognizer in
            guard let targetView = recognizer.view else { return }

            if recognizer is UIPanGestureRecognizer {
                // 转换
                let panGestureRecognizer = recognizer as! UIPanGestureRecognizer
                
                if recognizer.state == .began {
                    // 获取手势开始时的视图Frame
                    initialCenter = targetView.center
                }
                
                // 获取手势的平移值(滑动距离)
                let translation = panGestureRecognizer.translation(in: targetView.superview)
                
                // 移动视图
                targetView.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)
                
                // 移动距离 - 是否超出临界值
                let distanceX = abs(targetView.center.x - initialCenter.x)
           
                if recognizer.state == .ended {
                    // 判断是否滑出视图
                    let velocity = panGestureRecognizer.velocity(in: self)
                    
                    if distanceX > swipeThreshold {
                        // 滑出视图
                        if velocity.x > 0 {
                            // 滑出视图 - 向右
                            slideHandle?(.right)
                        } else if velocity.x < 0 {
                            // 滑出视图 - 向左
                            slideHandle?(.left)
                        }
                    } else {
                        // 没有滑出视图，回到初始位置
                        UIView.animate(withDuration: 0.3) {
                            targetView.center = initialCenter
                        }
                    }
                    
                    // 重置手势识别器的状态，以便下一次使用
                    panGestureRecognizer.setTranslation(.zero, in: targetView.superview)
                }
            }
        }

    }
    
    /// Moisture: 添加滑动拖拽手势 (Y轴)
    ///   - swipeThreshold: 临界值(滑动阈值)
    public func addSlideable_Y(swipeThreshold: CGFloat = 336.0, _ slideHandle: ((SwipeDirection.vertical) -> Void)?) {
        self.swipeThreshold = swipeThreshold
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.delegate = self // 添加此行以处理手势识别器冲突
        self.isUserInteractionEnabled = true
        
        // 初始化视图原始Center
        var initialCenter: CGPoint!
        
        self.setGesture(recognizers: [panGesture]) { recognizer in
            guard let targetView = recognizer.view else { return }

            if recognizer is UIPanGestureRecognizer {
                // 转换
                let panGestureRecognizer = recognizer as! UIPanGestureRecognizer
                
                if recognizer.state == .began {
                    // 获取手势开始时的视图Frame
                    initialCenter = targetView.center
                }
                
                // 获取手势的平移值(滑动距离)
                let translation = panGestureRecognizer.translation(in: targetView.superview)
                
                // 移动视图
                targetView.center = CGPoint(x: initialCenter.x, y: initialCenter.y + translation.y)
                
                // 移动距离 - 是否超出临界值
                let distanceY = abs(targetView.center.y - initialCenter.y)
           
                if recognizer.state == .ended {
                    // 判断是否滑出视图
                    let velocity = panGestureRecognizer.velocity(in: self)
                    
                    if distanceY > swipeThreshold {
                        // 滑出视图
                        if velocity.y > 0 {
                            // 滑出视图 - 向下
                            slideHandle?(.down)
                        } else if velocity.y < 0 {
                            // 滑出视图 - 向上
                            slideHandle?(.up)
                        }
                    } else {
                        // 没有滑出视图，回到初始位置
                        UIView.animate(withDuration: 0.3) {
                            targetView.center = initialCenter
                        }
                    }
                    
                    // 重置手势识别器的状态，以便下一次使用
                    panGestureRecognizer.setTranslation(.zero, in: targetView.superview)
                }
            }
        }

    }
    
    
    /// Moisture: 添加拖拽跟随手势
    /// - Parameter allowOutOfBounds: 是否允许视图超出屏幕边界，默认为 true
    public func addDraggable(isAllowOutOfBounds: Bool = true) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanDragging(_:)))
        panGesture.delegate = self // 添加此行以处理手势识别器冲突
        self.addGestureRecognizer(panGesture)
        self.isUserInteractionEnabled = true
        self.isAllowOutOfBounds = isAllowOutOfBounds
    }

    @objc private func handlePanDragging(_ sender: UIPanGestureRecognizer) {
        guard let targetView = sender.view else { return }

        // 获取手势的平移值(滑动距离)
        let translation = sender.translation(in: targetView.superview)

        // 计算新的中心点
        var newX = targetView.center.x + translation.x
        var newY = targetView.center.y + translation.y

        // 如果不允许超出屏幕边界
        if !isAllowOutOfBounds {
            // 限制新的中心点在屏幕内
            newX = max(targetView.frame.width / 2, min(newX, targetView.superview!.bounds.width - targetView.frame.width / 2))
            newY = max(targetView.frame.height / 2, min(newY, targetView.superview!.bounds.height - targetView.frame.height / 2))
        }

        // 设置新的中心点
        targetView.center = CGPoint(x: newX, y: newY)

        // 重置手势的平移值
        sender.setTranslation(.zero, in: targetView.superview)
    }
    
    // Moisture: 解决手势冲突
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


// MARK: - CABasicAnimation基础动效 (keyPath)

public extension UIView {

    /*
     解释：为什么动画结束后返回原状态？
     首先我们需要搞明白一点的是，layer动画运行的过程是怎样的？
     其实在我们给一个视图添加layer动画时，真正移动并不是我们的视图本身，而是 presentation layer 的一个缓存。
     动画开始时 presentation layer开始移动，原始layer隐藏，动画结束时，presentation layer从屏幕上移除，原始layer显示。
     这就解释了为什么我们的视图在动画结束后又回到了原来的状态，因为它根本就没动过。
     Explanation: Why does the animation return to its original state after it finishes?
     First, we need to understand how the layer animation works.
     Actually, when we add a layer animation to a view, it’s not the view itself that moves, but a cached version of the presentation layer.
     When the animation starts, the presentation layer moves, and the original layer is hidden. When the animation ends, the presentation layer is removed from the screen, and the original layer is shown.
     This explains why the view returns to its original state after the animation finishes—it hasn't actually moved.
     */

    
    // MARK: - Basic Animation Single

    /// Moisture: 添加基本​​动画 / Add Basic Animation
    func addBasicAnimation(keyPath: String, fromValue: Any?, toValue: Any?, duration: TimeInterval, timingFunction: CAMediaTimingFunctionName, key: String, completion: (() -> Void)? = nil) {
        let animation = CABasicAnimation(keyPath: keyPath)
        // 动画初始值
        animation.fromValue = fromValue
        // 动画结束值
        animation.toValue = toValue
        // 动画持续时间
        animation.duration = duration
        // 速度变化
        /*
         缓动函数两种方法:
         1.CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),四个枚举
         linear：速度保持恒定。
         easeIn：开始时缓慢加速，后面加速度增加。
         easeOut：开始时加速度较大，后面逐渐减速。
         easeInOut：开始和结束时速度较慢，中间时速度较快。
         
         2.CAMediaTimingFunction(controlPoints: 0.25, 0.1, 0.25, 1.0),更精确的单独控制每一个缓动函数
         
         */
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        // 重复次数
        animation.repeatCount = 1

        layer.add(animation, forKey: key)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
    
    // MARK: - Keyframe Animation Single
    
    /// Moisture: 添加关键帧动画 / Add Keyframe Animation
    func addKeyframeAnimation(keyPath: String, values: [Any], keyTimes: [NSNumber], duration: TimeInterval, timingFunction: [CAMediaTimingFunctionName], key: String, completion: (() -> Void)? = nil) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        // 动画初始值
        animation.values = values
        // 动画结束值
        animation.keyTimes = keyTimes
        // 动画持续时间
        animation.duration = duration
        // 速度变化
        /*
         缓动函数两种方法:
         1.CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut),四个枚举
         linear：速度保持恒定。
         easeIn：开始时缓慢加速，后面加速度增加。
         easeOut：开始时加速度较大，后面逐渐减速。
         easeInOut：开始和结束时速度较慢，中间时速度较快。
         
         2.CAMediaTimingFunction(controlPoints: 0.25, 0.1, 0.25, 1.0),更精确的单独控制每一个缓动函数
         
         */
        animation.timingFunctions = timingFunction.map( {CAMediaTimingFunction(name: $0) })
        // 重复次数
        animation.repeatCount = 1

        layer.add(animation, forKey: key)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion?()
        }
    }
    
    // MARK: - Animation Group

    func animate(with key: String = UUID().uuidString, repeatCount: Float = 1, timingFunction: MediaTimingFunction = .easeInOut) -> AnimationPool {
        return AnimationPool(view: self, key: key, repeatCount: repeatCount, timingFunction: timingFunction)
    }
    
}

// 动画类型
public enum AnimationProcessType {
    case basic(fromValue: Any, toValue: Any)
    case keyframes(value: [Any], keyTimes: [NSNumber], timingFunction: [MediaTimingFunction])
}

public class AnimationPool {
    private let view: UIView
    private let key: String
    private let repeatCount: Float //HUGE 表示不停重复
    private let timingFunction: MediaTimingFunction
    private var animationPool: [CAAnimation] = []
    
    init(view: UIView, key: String, repeatCount: Float, timingFunction: MediaTimingFunction) {
        self.view = view
        self.key = key
        self.repeatCount = repeatCount
        self.timingFunction = timingFunction
    }
    
    /// Moisture: 添加动画到动画池 / Add animation to the animation pool
    @discardableResult
    func addAnimation(_ animation: CAAnimation) -> AnimationPool {
        animationPool.append(animation)
        return self
    }
    
    /// Moisture: 添加基本动画 / Add basic animation
    private func addAnimation(keyPath: String, animationType: AnimationProcessType, duration: TimeInterval) {
        switch animationType {
        case .basic(let fromValue, let toValue):
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = duration
            addAnimation(animation)
        case .keyframes(let values, let keyTimes, let timingFunction):
            let animation = CAKeyframeAnimation(keyPath: keyPath)
            animation.values = values
            animation.keyTimes = keyTimes
            animation.duration = duration
            animation.timingFunctions = timingFunction.map({ $0.media })
            addAnimation(animation)
        }
    }
    
    /// Moisture: 渐变效果 / Fade effect
    @discardableResult
    func gradient(animationType: AnimationProcessType, duration: TimeInterval) -> AnimationPool {
        addAnimation(keyPath: "opacity", animationType: animationType, duration: duration)
        return self
    }

    /// Moisture: 缩放效果 / Scaling effect
    @discardableResult
    func scale(animationType: AnimationProcessType, duration: TimeInterval) -> AnimationPool {
        addAnimation(keyPath: "transform.scale", animationType: animationType, duration: duration)
        return self
    }

    /// Moisture: 移动效果 / Position effect
    @discardableResult
    func position(animationType: AnimationProcessType, duration: TimeInterval) -> AnimationPool {
        addAnimation(keyPath: "position", animationType: animationType, duration: duration)
        return self
    }

    /// Moisture: 旋转效果 / Rotation effect
    @discardableResult
    func rotate(animationType: AnimationProcessType, duration: TimeInterval) -> AnimationPool {
        addAnimation(keyPath: "transform.rotation.z", animationType: animationType, duration: duration)
        return self
    }
    
    /// Moisture: 同时播放所有动画 / Play all animations concurrently
    @discardableResult
    func playConcurrency(completion: (() -> Void)? = nil) -> AnimationPool {
        play(animations: animationPool, completion: completion)
        return self
    }
    
    /// Moisture: 依次播放所有动画 / Play all animations sequentially
    @discardableResult
    func playSerial(completion: (() -> Void)? = nil) -> AnimationPool {
        play(animations: animationPool, sequentially: true, completion: completion)
        return self
    }
    
    // 播放动画，支持并行或串行播放 / Play animations, supporting concurrency or serial execution
    private func play(animations: [CAAnimation], sequentially: Bool = false, completion: (() -> Void)?) {
        let group = CAAnimationGroup()
        group.animations = animations
        group.timingFunction = timingFunction.media // 缓动函数，可根据需要修改
        group.repeatCount = repeatCount
        
        if sequentially {
            // 计算总持续时间，用于设置动画组的总时长
            let totalDuration = animations.reduce(0) { $0 + $1.duration }
            group.duration = totalDuration
            
            // 逐一设置动画的 beginTime
            var startTime: CFTimeInterval = 0
            for animation in animations {
                animation.beginTime = startTime
                startTime += animation.duration
            }
        } else {
            // 找出最长的动画时长，用于设置动画组的总时长
            if let maxDuration = animations.map({ $0.duration }).max() {
                group.duration = maxDuration
            }
        }
        
        view.layer.add(group, forKey: key)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + group.duration) {
            completion?()
        }
    }

}


// MARK: - CAMediaTimingFunctionName Enum (缓动函数)

public enum MediaTimingFunction {
    case linear
    case easeIn
    case easeOut
    case easeInOut
    case custom(c1x: Float, c1y: Float, c2x: Float, c2y: Float)
    
    public var media: CAMediaTimingFunction {
        switch self {
        case .linear:
            return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        case .custom(let c1x, let c1y, let c2x, let c2y):
            return CAMediaTimingFunction(controlPoints: c1x, c1y, c2x, c2y)
        }
    }
}


public extension UIView {
    
    /// Moisture: 添加圆角 / Add Round
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        layer.mask = maskLayer
    }
    
    /// Moisture: 添加边框 / Add Border
    func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    /// Moisture: 添加阴影 / Add Shadow
    func addShadow(color: UIColor, opacity: Float, radius: CGFloat, offset: CGSize) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }
    
    /// Moisture: 添加渐变 / Add Gradient
    func applyGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}


// MARK: - 绘制line

public extension UIView {
    
    /// Moisture: 划线 / Add Line
    func underline(_ direction: LineDirection, lineWidth: CGFloat, color: UIColor, inset: CGFloat, equal: LineEqualTo) {
        line(direction, lineWidth: lineWidth, color: color, inset: inset, equal: equal)
    }
    
    private func line(_ direction: LineDirection, lineWidth: CGFloat, color: UIColor, inset: CGFloat, equal: LineEqualTo) {
        let view = UIView()
        view.backgroundColor = color
        self.addSubview(view)
        var distance: CGFloat = 0 //距离
        switch equal {
        case .equalTo:
            break
        case .lessTo(let cGFloat):
            distance = cGFloat
        case .greaterTo(let cGFloat):
            distance = -cGFloat
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch direction {
        case .inTop:
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: distance),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -distance),
                view.bottomAnchor.constraint(equalTo: topAnchor, constant: -inset),
                view.heightAnchor.constraint(equalToConstant: lineWidth)
            ])
            
        case .inLeft:
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor, constant: distance),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -distance),
                view.trailingAnchor.constraint(equalTo: leftAnchor, constant: -inset),
                view.widthAnchor.constraint(equalToConstant: lineWidth)
            ])
            
        case .inRight:
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor, constant: distance),
                view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -distance),
                view.leadingAnchor.constraint(equalTo: rightAnchor, constant: inset),
                view.widthAnchor.constraint(equalToConstant: lineWidth)
            ])
            
        case .inBottom:
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: distance),
                view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -distance),
                view.topAnchor.constraint(equalTo: bottomAnchor, constant: inset),
                view.heightAnchor.constraint(equalToConstant: lineWidth)
            ])
        }
    }
}


// MARK: - 划线的方向

public enum LineDirection {
    case inTop                  // 在顶部
    case inLeft                 // 在左侧
    case inBottom               // 在底部
    case inRight                // 在右侧
}


// MARK: - 划线的相对长度

public enum LineEqualTo {
    case equalTo                // 等于
    case lessTo(CGFloat)        // 小于
    case greaterTo(CGFloat)     // 大于
}


// MARK: - 手势滑动方向

public enum SwipeDirection {
    public enum horizontal {
        case left
        case right
    }
    public enum vertical {
        case up
        case down
    }
}
