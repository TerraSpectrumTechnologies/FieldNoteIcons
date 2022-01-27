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
    @IBOutlet weak var showPinSwitch: UISwitch!
    
    var houseColor = UIColor.black
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icons = FieldNoteIcons.IconList()
        
        for icon in icons {
            let primaryHexColor = colorToHexString(color: houseColor)
            let whiteHex = colorToHexString(color: UIColor.white)
            if showPinSwitch.isOn {
                if let iconImage = FieldNoteIcons.PinIcon(name: icon, size: houseImageView.frame.size, primaryColorHex: primaryHexColor, secondaryColorHex: primaryHexColor, tertiaryColorHex: primaryHexColor, pinFillColorHex: whiteHex) {
                    images.append(iconImage)
                }
            } else {
                if let iconImage = FieldNoteIcons.Icon(name: icon, size: CGSize(width: 400, height: 400), primaryColorHex: primaryHexColor, secondaryColorHex: primaryHexColor, tertiaryColorHex: primaryHexColor, pinFillColorHex: whiteHex) {
                    images.append(iconImage)
                }
            }
        }
        

        
        houseImageView.layer.borderWidth = 1
        houseImageView.layer.borderColor = UIColor.gray.cgColor
        updateHouseColor()
    }

    func updateHouseColor() {
        let primaryHexColor = colorToHexString(color: houseColor)
        let whiteHex = colorToHexString(color: UIColor.white)
        let imageName = "Clock with calendar"
        if showPinSwitch.isOn {
            houseImageView.image = FieldNoteIcons.PinIcon(name: imageName, size: houseImageView.frame.size, primaryColorHex: primaryHexColor, secondaryColorHex: primaryHexColor, tertiaryColorHex: primaryHexColor, pinFillColorHex: whiteHex)
        } else {
            houseImageView.image = FieldNoteIcons.Icon(name: imageName, size: CGSize(width: 400, height: 400), primaryColorHex: primaryHexColor, secondaryColorHex: primaryHexColor, tertiaryColorHex: primaryHexColor, pinFillColorHex: whiteHex)
        }
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
    
    @IBAction func pinSwitchedToggled(_ sender: Any) {
        updateHouseColor()
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

