//
//  FieldNoteIcons.swift
//  FieldNoteIcons
//
//  Created by Matthew Hollen on 1/6/22.
//

import Foundation
import Macaw
import SwiftUI
import UIKit

/// Field Note Icons
public final class FieldNoteIcons {
    static var svgCache: NSCache<NSString, UIImage> = NSCache()
    
    /**
     Gets a SVG Icon Image

     - Parameters:
        - filePath: The local file path for the image
        - size: The requested size of the image
        - primaryColor: The primary color
        - secondaryColor: The secondary color (Defaults to black)
        - tertiaryColor: The tertiary color (Defaults to black)
        - pinFillColor: The pin background fill color (Defaults to white)

     - Returns: A UIImage for the requested icon
     */
    
    public static func icon(filePath: String, size: CGSize, primaryColor: UIColor, secondaryColor: UIColor = .black, tertiaryColor: UIColor = .black, pinFillColor: UIColor = .white) -> UIImage? {

        return icon(filePath: filePath, size: size, primaryColorHex: self.hexStringWithColor(color: primaryColor), secondaryColorHex: self.hexStringWithColor(color: secondaryColor), tertiaryColorHex: self.hexStringWithColor(color: tertiaryColor), pinFillColorHex: self.hexStringWithColor(color: pinFillColor))
    }
    
    /**
      Gets a SVG Icon Image

      - Parameters:
         - name: The name of the icon
         - size: The requested size of the image
         - primaryColorHex: The primary color as a hex value
         - secondaryColorHex: The secondary color as a hex value (Defaults to black)
         - tertiaryColorHex: The tertiary color as a hex value (Defaults to black)
         - pinFillColorHex: The pin background fill color as a hex value (Defaults to white)

      - Returns: A UIImage for the requested icon
      */

     public static func icon(filePath: String, size: CGSize, primaryColorHex: String, secondaryColorHex: String = "000000", tertiaryColorHex: String = "000000", pinFillColorHex: String = "FFFFFF") -> UIImage? {
         
         let styleMap = ["primary": primaryColorHex, "secondary": secondaryColorHex, "tertiary": tertiaryColorHex, "pinFillColor": pinFillColorHex]

         if let svgString = try? NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue) {
             let image = render(svgString: svgString as String, size: size, styleMap: styleMap)
             return image
         }

         return nil
     }
    
    
    /**
     Renders an SVG for a given string and size.
     - Parameter svgString: The SVG string
     - Parameter size: The size of the icon
     - Parameter styleMap: The style map with CSS fill colors to replace (as hex value)
     - Parameter contentMode: The mode how to fill available space
     - Parameter useCache: `true` if the rendered image should be cached, otherwise `false`
     - Returns: The rendered image
     */

    @objc public class func render(svgString: String,
                                   size: CGSize,
                                   styleMap: [String: String]? = nil,
                                   contentMode: UIView.ContentMode = .scaleAspectFit,
                                   useCache: Bool = true) -> UIImage? {
        var svgStringToRender = svgString
        if let styleMap = styleMap {
            svgStringToRender = manipulateStyle(svgString: &svgStringToRender, styleMap: styleMap)
        }

        if useCache, let cachedResult = FieldNoteIcons.svgCache.object(
            forKey: cacheKey(svgString: svgStringToRender, size: size)) {
            return cachedResult.copy() as? UIImage
        }

        let node = try? SVGParser.parse(text: svgStringToRender)
        let result = try? node?.toNativeImage(size: Size(w: size.width, h: size.height),
                                              layout: .of(contentMode: contentMode)) ?? nil

        if useCache, let result = result {
            FieldNoteIcons.svgCache.setObject(result, forKey: cacheKey(svgString: svgStringToRender, size: size))
        }

        return result
    }
    
    /**
     Manipulates an SVG string for a given style map.
     - Parameter svgString: The SVG string
     - Parameter styleMap: The style map with CSS fill colors to replace (as hex value)
     - Returns: The manipulated SVG string
     */

    private class func manipulateStyle(svgString: inout String, styleMap: [String: String]) -> String {
        var result = svgString
        styleMap.forEach { (key: String, value: String) in
            let pattern = "\\.\(key)\\{(.*)fill:#[0-9,a-f,A-F]{6};\\}"
            let fillStyle = ".\(key){fill:\(value);}"
            result = result.replacingOccurrences(of: pattern,
                                                 with: fillStyle,
                                                 options: .regularExpression)
        }

        return result
    }
    
    private static func resize(image: UIImage, to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            let hScale = newSize.height / image.size.height
            let vScale = newSize.width / image.size.width
            let scale = max(hScale, vScale) // scaleToFill
            let resizeSize = CGSize(width: image.size.width*scale, height: image.size.height*scale)
            var middle = CGPoint.zero
            if resizeSize.width > newSize.width {
                middle.x -= (resizeSize.width-newSize.width)/2.0
            }
            if resizeSize.height > newSize.height {
                middle.y -= (resizeSize.height-newSize.height)/2.0
            }
            
            return image.draw(in: CGRect(origin: middle, size: resizeSize))
        }
    }

    
    static func colorWithHexString(hexString: String) -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
        
        guard colorString.count <= 8 else {
            return .white
        }
        
        var alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)
        if colorString.count > 6 {
            alpha = self.colorComponentFrom(colorString: colorString, start: 6, length: 2)
        }

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
                        
    static func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {
        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt64 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt64(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        return floatValue
    }
    
    private static func hexStringWithColor(color: UIColor) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return "000000"
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    /**
     Returns a key to identify an image in the cache.
     - Parameter svgString: The SVG string
     - Parameter size: The size of the icon
     - Returns: The key to identify an image in the cache
     */

    fileprivate class func cacheKey(svgString: String, size: CGSize) -> NSString {
        "\(svgString.hashValue)_\(size.width)_\(size.height)" as NSString

    }
}
