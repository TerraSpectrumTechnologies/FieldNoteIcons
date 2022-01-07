//
//  ViewController.swift
//  FieldNoteIcons
//
//  Created by BreckClone on 01/06/2022.
//  Copyright (c) 2022 BreckClone. All rights reserved.
//

import UIKit
import FieldNoteIcons

class ViewController: UIViewController {

    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var customHexTextField: UITextField!
    @IBOutlet weak var customTextGoButton: UIButton!
    @IBOutlet weak var houseImageView: UIImageView!
    
    var houseColor = UIColor.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHouseColor()
    }

    func updateHouseColor() {
        let hexColor = colorToHexString(color: houseColor) //hexStringFromColor(color: houseColor)
        houseImageView.image = FieldNoteIcons.Icon(name: "Property_Home", size: CGSize(width: 400, height: 400), primaryColorHex: hexColor, secondaryColorHex: hexColor)
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        houseColor = colorWithHexString(hexString: customHexTextField.text ?? "000000")
        updateHouseColor()
    }
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        switch sender {
        case orangeButton :
            houseColor = .orange
            updateHouseColor()
        case greenButton :
            houseColor = .green
            updateHouseColor()
        case blueButton :
            houseColor = .blue
            updateHouseColor()
        case redButton :
            houseColor = .red
            updateHouseColor()
        default:
            houseColor = .black
            updateHouseColor()
        }
    }
    @IBAction func colorPickerButtonTapped(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = houseColor
        picker.delegate = self

        // Presenting the Color Picker
        self.present(picker, animated: true, completion: nil)
    }
    
    func colorToHexString(color: UIColor) -> String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(format: "#%02X%02X%02X", Int(red * 0xff), Int(green * 0xff), Int(blue * 0xff))
    }
    
    func colorWithHexString(hexString: String) -> UIColor {
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

    func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {

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

extension ViewController: UIColorPickerViewControllerDelegate {
    
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        houseColor = viewController.selectedColor
        updateHouseColor()
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            houseColor = viewController.selectedColor
        updateHouseColor()
    }
}

