//
//  Extension.swift
//  B+Com U
//
//  Created by Ha Nguyen Thai on 5/22/19.
//  Copyright © 2019 Cloud 9. All rights reserved.
//

import Foundation
import UIKit
import ImageIO

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

extension Int {
    var toUIColor: UIColor {
        let r = (CGFloat)(((self & 0xFF0000) >> 16)) / 255.0
        let g = (CGFloat)(((self & 0x00FF00) >> 08)) / 255.0
        let b = (CGFloat)(((self & 0x0000FF) >> 00)) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension String {
    
    var isValidCharacters: Bool {
        return self.count <= 12
    }
    
    var isValidName: Bool {
        let regex = "(?!^ +$)^.+$"
        let predi = NSPredicate(format: "SELF MATCHES %@", regex)
        return predi.evaluate(with: self) as Bool && isValidCharacters
    }
    
    func dataFromHexadecimalString() -> Data? {
        let trimmedString = self.trimmingCharacters(in: CharacterSet(charactersIn: "<> ")).replacingOccurrences(of: " ", with: "")
        
        // make sure the cleaned up string consists solely of hex digits, and that we have even number of them
        
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]*$", options: .caseInsensitive)
        
        let found = regex.firstMatch(in: trimmedString, options: [], range: NSMakeRange(0, trimmedString.count))
        if found == nil || found?.range.location == NSNotFound || trimmedString.count % 2 != 0 {
            return nil
        }
        
        // everything ok, so now let's build NSData
        
        let data = NSMutableData(capacity: trimmedString.count / 2)
        
        var index = trimmedString.startIndex
        while index < trimmedString.endIndex {
            let byteString = trimmedString.substring(with: (index ..< trimmedString.index(after: trimmedString.index(after: index))))
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data?.append([num] as [UInt8], length: 1)
            index = trimmedString.index(after: trimmedString.index(after: index))
        }
        
        return data as Data?
    }
    
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var urlEncoding: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    var timeInterval: Int64 {
        let format = DateFormatter()
        format.dateFormat = "yyyy-mm-dd HH:mm:ss"
        return format.date(from: self)!.millisecondsSince1970
    }

}

extension Data {
    var contentTypeForImageData: String {
        
        var c: UInt8! = UInt8()
        (self as NSData).getBytes(&c, length: 1)
        
        switch c {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x49, 0x4D:
            return "image/tif"
        default: return ""
        }
    }
    
    var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
    
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}

extension UIImage {
    
    /* This to fix incorrect image orientation after uploading */
    func normalizedImage() -> UIImage {
        
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    func toBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 0.2) else { return nil }
        return "data:image/png;base64," + imageData.base64EncodedString()
    }
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
}

extension Date {
    
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func getTimeAgoString() -> String? {
        // Update calendar into kind of "gregorian"
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()
        let earlyDate = now < self ? now : self
        let laterDate = now >= self ? now : self
        let components = calendar.dateComponents([.second, .minute, .hour, .day, .weekOfYear, .month, .year], from: earlyDate, to: laterDate)
        
        var hourString = ""
        var minuteString = ""
        
        if components.hour! >= 2 {
            hourString = "\(components.hour!) hours"
        } else if components.hour! == 1 {
            hourString = "1 hour"
        }
        
        if components.minute! >= 2 {
            minuteString = "\(components.minute!) minutes"
        } else if components.minute! == 1 {
            minuteString = "1 minute"
        } else {
            if hourString.isEmpty {
                minuteString = "0 minute"
            }
        }
        
        return hourString + " " + minuteString
    }
}

extension NSObject {
    
    func parseDoubleFrom(_ data: AnyObject?, defaultValue: Double = 0) -> Double {
        return (data as? Double) ?? (data as? NSString)?.doubleValue ?? defaultValue
    }
    
    func parseIntFrom(_ data: AnyObject?, defaultValue: Int = 0) -> Int {
        if let value = data as? Int {
            return value
        } else {
            return defaultValue
        }
    }
    
    func parseStringFrom(_ data: AnyObject?, defaultValue: String = "") -> String {
        if let value = data as? String, value != "" {
            return value
        } else {
            return defaultValue
        }
    }
    
    func parseFloatFrom(_ data: AnyObject?, defaultValue: Float = 0) -> Float {
        if let value = data as? Float {
            return value
        } else {
            return defaultValue
        }
    }
    
    func parseBoolFrom(_ data: AnyObject?, defaultValue: Bool = false) -> Bool {
        if let value = data as? Bool {
            return value
        } else {
            return defaultValue
        }
    }
    
    func parseDictFrom(_ data: AnyObject? , defaultValue: Dictionary<String, AnyObject>? = nil) -> Dictionary<String, AnyObject>? {
        if let value = data as? Dictionary<String, AnyObject> {
            return value
        } else {
            return defaultValue
        }
    }
    
    func parseDictArrayFrom(_ data: AnyObject? , defaultValue: [Dictionary<String, AnyObject>]? = nil) -> [Dictionary<String, AnyObject>]? {
        if let value = data as? [Dictionary<String, AnyObject>] {
            return value
        } else {
            return defaultValue
        }
    }
    
    func getLocalizedMessageAndTitleFromObject(_ data: Dictionary<NSObject, AnyObject>) -> [String?] {
        let localizedCode = self.getLanguageCode()
        var message = data["message_\(localizedCode)" as NSObject] as? String
        var title = data["title_\(localizedCode)" as NSObject] as? String
        if message == nil {
            message = data["message" as NSObject] as? String
        }
        if title == nil {
            title = data["title" as NSObject] as? String
        }
        return [message, title]
    }
    
    func getLocalizedMessageFromObject(_ data: Dictionary<NSObject, AnyObject>) -> String? {
        return data["message_\(self.getLanguageCode())" as NSObject] as? String
    }
    
    func getLanguageCode() -> String {
        if let languageCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as? String {
            return languageCode.lowercased()
        }
        return "en"
    }
    
    func getLanguageCodeDisplayName() -> String {
        if let displayName = (Locale.current as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: self.getLanguageCode()) {
            return displayName
        }
        return "N/A"
    }
    
    func getRegionCode() -> String {
        if let regionCode = (Locale.current as NSLocale).object(forKey: NSLocale.Key.identifier) as? String {
            return regionCode
        }
        return "N/A"
    }
    
    func callNumber(_ phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber.replacingOccurrences(of: " ", with: ""))") {
            let application = UIApplication.shared
            if application.canOpenURL(phoneCallURL) {
                application.openURL(phoneCallURL)
            }
        }
    }
    
}

extension Dictionary {
    func parseStringForKey(forKey key: Key, defaultValue: String = "") -> String {
        if let data = self[key] as? String {
            return data
        }
        return defaultValue
    }
    
    func parseStringArrayForKey(forKey key: Key, defaultValue: [String] = []) -> [String]? {
        if let data = self[key] as? [String] {
            return data
        }
        return defaultValue
    }
    
    func parseIntForKey(forKey key: Key, defaultValue: Int = -1) -> Int {
        if let data = self[key] as? Int {
            return data
        }
        return defaultValue
    }
    
    func parseIntArrayForKey(forKey key: Key, defaultValue: [Int] = []) -> [Int]? {
        if let data = self[key] as? [Int] {
            return data
        }
        return defaultValue
    }
    
    func parseDoubleForKey(forKey key: Key, defaultValue: Double = 0) -> Double {
        if let data = self[key] as? Double {
            return data
        }
        return defaultValue
        
    }
    
    func parseFloatForKey(forKey key: Key, defaultValue: Float = 0) -> Float {
        if let data = self[key] as? Float {
            return data
        }
        return defaultValue
    }
    
    func parseCGFloatForKey(forKey key: Key, defaultValue: CGFloat = -1) -> CGFloat {
        if let data = self[key] as? CGFloat {
            return data
        }
        return defaultValue
    }
    
    
    func parseBoolForKey(forKey key: Key, defaultValue: Bool = false) -> Bool {
        if let data = self[key] as? Bool {
            return data
        }
        return defaultValue
    }
    
    func parseDictForKey(forKey key: Key, defaultValue: Dictionary<String, AnyObject>? = nil) -> Dictionary<String, AnyObject>? {
        if let data = self[key] as? Dictionary<String, AnyObject> {
            return data
        }
        return defaultValue
    }
    
    func parseDictArrayForKey(forKey key: Key, defaultValue: [Dictionary<String, AnyObject>]? = nil) -> [Dictionary<String, AnyObject>]? {
        if let data = self[key] as? [Dictionary<String, AnyObject>] {
            return data
        }
        return defaultValue
    }
    
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
    
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // Shadow
    /// The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    
    func stopAnimation() {
        self.layer.removeAllAnimations()
    }
    
    func startAnimation(with rotations: CGFloat,duration: CFTimeInterval = 1.0, repeatCount: Float = .infinity , completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = rotations
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount = repeatCount
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func roundCorner() {
        roundCorner(UIColor.clear, borderWidth: 0.0)
    }
    
    func roundCorner(_ borderColor: UIColor, borderWidth: Float) {
        self.roundCorner(borderColor, borderWidth: borderWidth, cornerRadius: self.bounds.size.height / 7)
    }
    
    func roundCorner(_ borderColor: UIColor, borderWidth: Float, cornerRadius: CGFloat) {
        self.layer.cornerRadius  = cornerRadius
        self.layer.borderWidth   = CGFloat(borderWidth)
        self.layer.borderColor   = borderColor.cgColor
        self.layer.masksToBounds = true
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addMatchParentConstraintForSubview(_ subview: UIView) {
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: subview, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
    }
    
    func fadeIn(_ duration: TimeInterval = 1.5, delay: TimeInterval = 0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.5, delay: TimeInterval = 0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UILabel {
    
    func setLineSpacing(spaceLine: CGFloat = 5.0, alignment: NSTextAlignment = .center) {
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = spaceLine // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        // *** Set Attributed String to your label ***
        self.attributedText = attributedString
    }
    
    func calculateExpectHeightForLabel(width: CGFloat) -> CGFloat {
        let alignment = NSTextAlignment.center
        let attributedString = NSMutableAttributedString(string: self.text ?? "")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = 5.0
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let sampleLabel = UILabel()
        sampleLabel.numberOfLines = 0
        sampleLabel.attributedText = attributedString
        
        let fixedSize = sampleLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return fixedSize.height
    }
}






