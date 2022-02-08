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
    
    private static let nodeTypes: [String] = ["path","rect","line","polygon","polyline","circle","ellipse"]
    
    /**
    Gets a list of all available icon images

    - Returns: A list of all available images by name
    */
    
    public static func iconList() -> [String] {
        var iconList:[String] = []
        let fieldNoteIconsBundle = Bundle(for: Self.self)
        guard let resourceBundleURL = fieldNoteIconsBundle.url(forResource: "FieldNoteIcons", withExtension: "bundle") else {
            fatalError("FieldNoteIcons.bundle not found!")
        }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: resourceBundleURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for content in contents {
                let iconPathSplit = content.pathComponents.split(separator: "/").last
                let iconFullName = iconPathSplit?.last ?? ""
                if !iconFullName.contains(".svg") {
                    continue
                }
                
                let iconName = iconFullName.replacingOccurrences(of: ".svg", with: "")
                let cleanedIconName = iconName.replacingOccurrences(of: "Pin_", with: "")
                if !iconList.contains(where: { name in
                    name == cleanedIconName
                }) {
                    iconList.append(cleanedIconName)
                }
            }
        } catch {
            print(error)
        }
        
        return iconList
    }
    
    /**
     Checks if the library has an icon available

     - Parameters:
        - name: The name of the icon
        
     - Returns: Bool indicating whether or not the icon exists
     */
    
    public static func iconExists(name: String) -> Bool {
        guard let resourceBundle = self.resourceBundle() else {
            fatalError("Resource Bundle not found!")
        }
        
        let fileName = name.lowercased()
        var fileExists = false
        do {
            let resourcePath = resourceBundle.url(forResource: fileName, withExtension: "svg")
            fileExists = try resourcePath?.checkResourceIsReachable() ?? false
        } catch {
            print(error)
        }
        
        return fileExists
    }
    
    /**
     Gets a SVG Pin Icon Image

     - Parameters:
        - name: The name of the icon
        - size: The requested size of the image
        - primaryColorHex: The primary color as a hex value
        - secondaryColorHex: The secondary color as a hex value (Defaults to black)
        - tertiaryColorHex: The tertiary color as a hex value (Defaults to black)
        - pinFillColorHex: The pin background fill color as a hex value (Defaults to white)

     - Returns: A UIImage for the requested icon
     */
    
    public static func pinIcon(name: String, size: CGSize, primaryColorHex: String, secondaryColorHex: String = "000000", tertiaryColorHex: String = "000000", pinFillColorHex: String = "FFFFFF") -> UIImage? {
        return icon(name: "pin_" + name, size: size, primaryColorHex: primaryColorHex, secondaryColorHex: secondaryColorHex, tertiaryColorHex: tertiaryColorHex, pinFillColorHex: pinFillColorHex)
    }
    
    /**
     Gets a SVG Pin Icon Image

     - Parameters:
        - name: The name of the icon
        - size: The requested size of the image
        - primaryColorHex: The primary color
        - secondaryColorHex: The secondary color (Defaults to black)
        - tertiaryColorHex: The tertiary color (Defaults to black)
        - pinFillColorHex: The pin background fill color (Defaults to white)

     - Returns: A UIImage for the requested icon
     */
    
    public static func pinIcon(name: String, size: CGSize, primaryColor: UIColor, secondaryColor: UIColor = .black, tertiaryColor: UIColor = .black, pinFillColor: UIColor = .white) -> UIImage? {
        return icon(name: "pin_" + name, size: size, primaryColor: primaryColor, secondaryColor: secondaryColor, tertiaryColor: tertiaryColor, pinFillColor: pinFillColor)
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
    
    public static func icon(name: String, size: CGSize, primaryColorHex: String, secondaryColorHex: String = "000000", tertiaryColorHex: String = "000000", pinFillColorHex: String = "FFFFFF") -> UIImage? {
        return icon(name: name, size: size, primaryColor: colorWithHexString(hexString: primaryColorHex), secondaryColor: colorWithHexString(hexString: secondaryColorHex), tertiaryColor: colorWithHexString(hexString: tertiaryColorHex), pinFillColor: colorWithHexString(hexString: pinFillColorHex))
    }
    
    /**
     Gets a SVG Icon Image

     - Parameters:
        - name: The name of the icon
        - size: The requested size of the image
        - primaryColorHex: The primary color
        - secondaryColorHex: The secondary color (Defaults to black)
        - tertiaryColorHex: The tertiary color (Defaults to black)
        - pinFillColorHex: The pin background fill color (Defaults to white)

     - Returns: A UIImage for the requested icon
     */
    
    public static func icon(name: String, size: CGSize, primaryColor: UIColor, secondaryColor: UIColor = .black, tertiaryColor: UIColor = .black, pinFillColor: UIColor = .white) -> UIImage? {
        guard let resourceBundle = self.resourceBundle() else {
            fatalError("Resource Bundle not found!")
        }
        
        let fileName = name.lowercased()
        let fileExists = iconExists(name: fileName)
        guard fileExists, let svgImage = SVGKImage(named: fileName, in: resourceBundle) else {
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
            fillElementNodeList(nodeList: nodeList, svgImage: svgImage, primaryColor: primaryColor, secondaryColor: secondaryColor, tertiaryColor: tertiaryColor, pinFillColor: pinFillColor)
        }
        
        return svgImage.uiImage
    }
    
    private static func resourceBundle() -> Bundle? {
        let fieldNoteIconsBundle = Bundle(for: Self.self)
        guard let resourceBundleURL = fieldNoteIconsBundle.url(forResource: "FieldNoteIcons", withExtension: "bundle") else {
            fatalError("FieldNoteIcons.bundle not found!")
        }
        
        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("Cannot access FieldNoteIcons.bundle!")
        }
        
        return resourceBundle
    }
    
    private static func fillElementNodeList(nodeList: NodeList, svgImage: SVGKImage, primaryColor: UIColor, secondaryColor: UIColor, tertiaryColor: UIColor, pinFillColor: UIColor) {
        for number in 0..<(nodeList.length) {
            if let nodeElement = nodeList.item(number) as? SVGElement {
                if nodeElement.getAttribute("class") == "primary" {
                    if let pathLayer = svgImage.layer(withIdentifier: nodeElement.identifier) as? CAShapeLayer {
                        pathLayer.fillColor = primaryColor.cgColor
                    }
                } else if nodeElement.getAttribute("class") == "secondary" {
                    if let pathLayer = svgImage.layer(withIdentifier: nodeElement.identifier) as? CAShapeLayer {
                        pathLayer.fillColor = secondaryColor.cgColor
                    }
                } else if nodeElement.getAttribute("class") == "tertiary" {
                    if let pathLayer = svgImage.layer(withIdentifier: nodeElement.identifier) as? CAShapeLayer {
                        pathLayer.fillColor = tertiaryColor.cgColor
                    }
                } else if nodeElement.getAttribute("class") == "pinFill" {
                    if let pathLayer = svgImage.layer(withIdentifier: nodeElement.identifier) as? CAShapeLayer {
                        pathLayer.fillColor = pinFillColor.cgColor
                    }
                }
            }
        }
    }
    
    static func colorWithHexString(hexString: String) -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
        
        guard colorString.count == 6 else {
            return .white
        }
        
        let alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)

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
}
