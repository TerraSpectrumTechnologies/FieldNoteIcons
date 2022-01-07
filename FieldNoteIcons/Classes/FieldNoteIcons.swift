//
//  FieldNoteIcons.swift
//  FieldNoteIcons
//
//  Created by Matthew Hollen on 1/6/22.
//

import Foundation
import SVGKit

public final class FieldNoteIcons {
    
    public static func Icon(name: String, size: CGSize, primaryColorHex: String, secondaryColorHex: String) -> UIImage {
        //Troubleshooting bundle
//        let mainBundle = Bundle.main
//        let svgMainTest = mainBundle.url(forResource: "Property_Home", withExtension: "svg")
//        let jpgMainTest = mainBundle.url(forResource: "IMG_0518", withExtension: "jpg")
//        if let podBundle = Bundle(identifier: "org.cocoapods.FieldNoteIcons") {
//        if let podBundle = Bundle(identifier: "FieldNoteIcons.bundle") {
//            let imageTest = UIImage(named: "Icons_46x46_LightOrange_B", in: podBundle, with: nil)
//            let svgTest = podBundle.url(forResource: "Property_Home", withExtension: "svg")
//            let jpgTest = podBundle.url(forResource: "IMG_0518", withExtension: "jpg")
//           print("done")
//        }
        
        let svgImage: SVGKImage = SVGKImage(named: name)
        let nodeList:NodeList = svgImage.domDocument.getElementsByTagName("path")
        
        for number in 0..<(nodeList.length) {
            if let nodeElement = nodeList.item(number) as? SVGElement {
                if nodeElement.identifier.contains("primary") {
                    if let pathLayer = svgImage.layer(withIdentifier: nodeElement.identifier) as? CAShapeLayer {
                        pathLayer.fillColor = colorWithHexString(hexString: primaryColorHex).cgColor
                    }
                }
                if nodeElement.identifier.contains("secondary") {
                    if let pathLayer = svgImage.layer(withIdentifier: nodeElement.identifier) as? CAShapeLayer {
                        pathLayer.fillColor = colorWithHexString(hexString: secondaryColorHex).cgColor
                    }
                }
            }
        }
        
        return svgImage.uiImage
    }
    
    static func colorWithHexString(hexString: String) -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()

        print(colorString)
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
        print(floatValue)
        return floatValue
    }
}
