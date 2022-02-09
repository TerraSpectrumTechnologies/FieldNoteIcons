//
//  ViewController.swift
//  FieldNoteIcons
//
//  Created by BreckClone on 01/06/2022.
//  Copyright (c) 2022 BreckClone. All rights reserved.
//

import UIKit
import FieldNoteIcons

struct IconImage {
    var image: UIImage
    var name: String
}


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var customHexTextField: UITextField!
    @IBOutlet weak var customTextGoButton: UIButton!
    @IBOutlet weak var showPinSwitch: UISwitch!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var houseColor = UIColor.black
    var iconImages: [IconImage] = []
    let iconsNames = FieldNoteIcons.iconList().sorted()
    let flowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        setupCollectionView()
        refreshIconImages()
    }
    
    func setupCollectionView() {
        flowLayout.itemSize = CGSize(width: 100, height: 120)
        flowLayout.scrollDirection = .vertical
        imageCollectionView.collectionViewLayout = flowLayout
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.allowsSelection = false
    }
    
    func refreshIconImages() {
        iconImages.removeAll()
        for iconName in iconsNames {
            if showPinSwitch.isOn {
                if let iconImage = FieldNoteIcons.pinIcon(name: iconName, size: flowLayout.itemSize, primaryColor: houseColor, secondaryColor: .white, tertiaryColor: .white, pinFillColor: .white) {
                    iconImages.append(IconImage(image: iconImage, name: iconName))
                }
            } else {
                if let iconImage = FieldNoteIcons.icon(name: iconName, size: flowLayout.itemSize, primaryColor: houseColor, secondaryColor: .white, tertiaryColor: .white, pinFillColor: .white) {
                    iconImages.append(IconImage(image: iconImage, name: iconName))
                }
            }
        }
    }
    
    func updateImageCells() {
        refreshIconImages()
        imageCollectionView.reloadData()
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        houseColor = colorWithHexString(hexString: customHexTextField.text ?? "000000")
        updateImageCells()
    }
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        switch sender {
        case orangeButton :
            houseColor = .orange
            updateImageCells()
        case greenButton :
            houseColor = .green
            updateImageCells()
        case blueButton :
            houseColor = .blue
            updateImageCells()
        case redButton :
            houseColor = .red
            updateImageCells()
        default:
            houseColor = .black
            updateImageCells()
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
        updateImageCells()
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
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath as IndexPath) as! ImageCollectionViewCell
        
        let iconImage = iconImages[indexPath.row]
        cell.imageView.image = iconImage.image
        cell.imageNameLabel.text = iconImage.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        houseColor = viewController.selectedColor
        updateImageCells()
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            houseColor = viewController.selectedColor
        updateImageCells()
    }
}

