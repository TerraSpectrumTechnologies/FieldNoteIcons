//
//  FieldNoteIcons.swift
//  FieldNoteIcons
//
//  Created by Matthew Hollen on 1/6/22.
//

import Foundation
import SVGKit
import UIKit

/// Field Note Icons
public final class FieldNoteIcons {
    
    private static let nodeTypes: [String] = ["path","polygon","circle","ellipse","rect","polyline"]
    
    /**
    Gets a list of all available icon images

    - Returns: A list of all available images by name
    */
    
    public static func IconList() -> [String] {
        var iconList:[String] = []
        let fieldNoteIconsBundle = Bundle(for: Self.self)
        guard let resourceBundleURL = fieldNoteIconsBundle.url(forResource: "FieldNoteIcons", withExtension: "bundle") else {
            fatalError("FieldNoteIcons.bundle not found!")
        }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: resourceBundleURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for content in contents {
                
                let iconPathSplit = content.pathComponents.split(separator: "/").last
                if let iconName = iconPathSplit?.last?.replacingOccurrences(of: ".svg", with: "") {
                    let cleanedIconName = iconName.replacingOccurrences(of: "Pin_", with: "")
                    if !iconList.contains(where: { name in
                        name == cleanedIconName
                    }) {
                        iconList.append(cleanedIconName)
                    }
                    
                }
            }
        } catch {
            print(error)
        }
        
        return iconList
    }
    
    /**
     Gets a SVG Pin Icon Image

     - Parameters:
        - name: The name of the icon
        - size: The requested size of the image
        - primaryColorHex: The primary color as a hex value
        - secondaryColorHex: The secondary color as a hex value
        - tertiaryColorHex: The tertiary color as a hex value
        - pinFillColorHex: The pin background fill color as a hex value

     - Returns: A UIImage for the requested icon
     */
    
    public static func PinIcon(name: String, size: CGSize, primaryColorHex: String, secondaryColorHex: String, tertiaryColorHex: String, pinFillColorHex: String) -> UIImage? {
        return Icon(name: "Pin_" + name, size: size, primaryColorHex: primaryColorHex, secondaryColorHex: secondaryColorHex, tertiaryColorHex: tertiaryColorHex, pinFillColorHex: pinFillColorHex)
    }
    
    /**
     Gets a SVG Icon Image

     - Parameters:
        - name: The name of the icon
        - size: The requested size of the image
        - primaryColorHex: The primary color as a hex value
        - secondaryColorHex: The secondary color as a hex value
        - tertiaryColorHex: The tertiary color as a hex value
        - pinFillColorHex: The pin background fill color as a hex value (Defaults to white)

     - Returns: A UIImage for the requested icon
     */
    
    public static func Icon(name: String, size: CGSize, primaryColorHex: String, secondaryColorHex: String, tertiaryColorHex: String, pinFillColorHex: String = "000000") -> UIImage? {
        let fieldNoteIconsBundle = Bundle(for: Self.self)
        guard let resourceBundleURL = fieldNoteIconsBundle.url(forResource: "FieldNoteIcons", withExtension: "bundle") else {
            fatalError("FieldNoteIcons.bundle not found!")
        }
        
        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("Cannot access FieldNoteIcons.bundle!")
        }
        
        var matchingSVGName = ""
        
        if fieldNoteIconsBundle.path(forResource: name, ofType: "svg") != nil {
            matchingSVGName = name
        } else if fieldNoteIconsBundle.path(forResource: name.lowercased(), ofType: "svg") != nil {
            matchingSVGName = name.lowercased()
        } else if fieldNoteIconsBundle.path(forResource: name.capitalized, ofType: "svg") != nil {
            matchingSVGName = name.capitalized
        } else if fieldNoteIconsBundle.path(forResource: name.uppercased(), ofType: "svg") != nil {
            matchingSVGName = name.uppercased()
        } else {
            return nil
        }
            
        guard let svgImage = SVGKImage(named: matchingSVGName, in: resourceBundle) else {
            return nil
        }

        var nodeListArray: [NodeList] = []
        
        for nodeType in nodeTypes {
            if let nodeElement = svgImage.domDocument.getElementsByTagName(nodeType) {
                if nodeElement.length > 0 {
                    nodeListArray.append(nodeElement)
                }
            }
        }
        
        for nodeList in nodeListArray {
            fillElementNodeList(nodeList: nodeList, svgImage: svgImage, primaryColorHex: primaryColorHex, secondaryColorHex: secondaryColorHex, tertiaryColorHex: tertiaryColorHex, pinFillColorHex: pinFillColorHex)
        }
        
        return svgImage.uiImage
    }
    
    private static func fillElementNodeList(nodeList: NodeList, svgImage: SVGKImage, primaryColorHex: String, secondaryColorHex: String, tertiaryColorHex: String, pinFillColorHex: String) {
        for number in 0..<(nodeList.length) {
            if let nodeElement = nodeList.item(number) as? SVGElement {
                if nodeElement.getAttribute("class") == "primary" {
                    if let pathLayer = svgImage.layer(withIdentifier: nodeElement.identifier) as? CAShapeLayer {
                        pathLayer.fillColor = colorWithHexString(hexString: primaryColorHex).cgColor
                    }
                } else if nodeElement.getAttribute("class") == "secondary" {
                    if let pathLayer = svgImage.layer(withIdentifier: nodeElement.identifier) as? CAShapeLayer {
                        pathLayer.fillColor = colorWithHexString(hexString: secondaryColorHex).cgColor
                    }
                } else if nodeElement.getAttribute("class") == "tertiary" {
                    if let pathLayer = svgImage.layer(withIdentifier: nodeElement.identifier) as? CAShapeLayer {
                        pathLayer.fillColor = colorWithHexString(hexString: tertiaryColorHex).cgColor
                    }
                } else if nodeElement.getAttribute("class") == "pinFill" {
                    if let pathLayer = svgImage.layer(withIdentifier: nodeElement.identifier) as? CAShapeLayer {
                        pathLayer.fillColor = colorWithHexString(hexString: pinFillColorHex).cgColor
                    }
                }
            }
        }
    }
    
    private static func imageWithBackground(image:UIImage, color: UIColor, opaque: Bool = true) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, opaque, image.scale)
            
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = image.cgImage else { return image }
        defer { UIGraphicsEndImageContext() }
            
        let rect = CGRect(origin: .zero, size: image.size)
        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
        ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: image.size.height))
        ctx.draw(cgImage, in: rect)
            
        return UIGraphicsGetImageFromCurrentImageContext() ?? image
      }
    
    static private func colorWithHexString(hexString: String) -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()

        let alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
                        
    static private func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {

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
}
