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
     Gets a SVG Icon Image

     - Parameters:
        - filePath: The local file path for the image
        - size: The requested size of the image
        - primaryColorHex: The primary color
        - secondaryColorHex: The secondary color (Defaults to black)
        - tertiaryColorHex: The tertiary color (Defaults to black)
        - pinFillColorHex: The pin background fill color (Defaults to white)

     - Returns: A UIImage for the requested icon
     */
    
    public static func icon(filePath: String, size: CGSize, primaryColor: UIColor, secondaryColor: UIColor = .black, tertiaryColor: UIColor = .black, pinFillColor: UIColor = .white) -> UIImage? {

        guard let svgImage = SVGKImage(contentsOfFile: filePath) else {
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
        
        return resize(image: svgImage.uiImage, to: size)
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
}
