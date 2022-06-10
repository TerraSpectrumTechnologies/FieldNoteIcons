//
//  ViewController.swift
//  FieldNoteIcons
//
//  Created by BreckClone on 01/06/2022.
//  Copyright (c) 2022 BreckClone. All rights reserved.
//

import UIKit
import FieldNoteIcons

class IconImage {
    var image: UIImage?
    var name: String
    
    init(image: UIImage?, name: String) {
        self.image = image
        self.name = name
    }
}


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, XMLParserDelegate {
    @IBOutlet weak var orangeButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var customHexTextField: UITextField!
    @IBOutlet weak var customTextGoButton: UIButton!
    @IBOutlet weak var showPinSwitch: UISwitch!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    private var accountKey = "cfJKt/URdIHOLYt8grT7Z6FV3Y/LrdHObgbp7+nzfx8Y9rRMee8im1bsc4N/kboTgMsWLAySkBhbMOOVLgd+Xw=="
    private var mediaAccountKey = "qEpXWfVqRhFDvyLmrXfLZN/wNvMQ3ekdBF5ztrBGbpxmvTSkHuoNBRkZzmNYHe8bOYOLVRvElDNlri80x1ZiyQ=="
    private static var storageURL = URL(string: "https://tsticons.blob.core.windows.net")
    private var storageName = "tsticons"
    private static var mediaStorageURL = URL(string: "https://fieldnotemedia.blob.core.windows.net")
    private var mediaStorageName = "fieldnotemedia"
    private var mediaAccountName = "8914ebe2-e960-4d08-a3fc-b703dd13ac05"
    private let iconBlobDirectory = "https://tsticons.blob.core.windows.net/icons/"
    
    var houseColor = UIColor.black
    var iconImages: [IconImage] = []
    var pinIconImages: [IconImage] = []
    var iconsNames = [String]()
    let flowLayout = UICollectionViewFlowLayout()
//    var continuationToken: AZSContinuationToken?
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        if let getAllURL = URL(string: "https://tsticons.blob.core.windows.net/icons?restype=container&comp=list") {
            let getAllBlobsRequest = URLRequest(url: getAllURL)
            URLSession.shared.dataTask(with: getAllBlobsRequest) { data, response, error in
                if error == nil {
                    if let data = data {
                        do {
                            let parser = XMLParser(data: data)
                            parser.delegate = self
                            parser.parse()
                            print("Success")
                        }
                    }
                } else {
                    print("Error: \(String(describing: error))")
                }
            }.resume()
        }
          
//        do {
//            let credentials = AZSStorageCredentials(accountName: storageName, accountKey: accountKey)
//            let mediaCredentials = AZSStorageCredentials(accountName: mediaStorageName, accountKey: mediaAccountKey)
//            let account = try AZSCloudStorageAccount(credentials: credentials, useHttps: true)
//            let mediaAccount = try AZSCloudStorageAccount(credentials: mediaCredentials, useHttps: true)
//            let client = account.getBlobClient()
//            let mediaClient = mediaAccount.getBlobClient()
//            let container = client.containerReference(fromName: "icons")
//            let mediaContainer = mediaClient.containerReference(fromName: mediaAccountName)
//            mediaContainer.createContainerIfNotExists { error, created in
//
//            }
//
//            let iconsDirectory = iconsDirectoryPath()
//            container.createContainerIfNotExists { error, created in
//                if error == nil {
//                    let blobListingDetails = AZSBlobListingDetails(rawValue: 0)
//                    container.listBlobsSegmented(with: self.continuationToken, prefix: nil, useFlatBlobListing: true, blobListingDetails: blobListingDetails, maxResults: 0) { error, resultSegment in
//                        if error == nil {
//                            if let blobs = resultSegment?.blobs {
//                                blobs.forEach { blob in
//                                    if let azsBlob = blob as? AZSCloudBlob {
//                                        let iconName = azsBlob.blobName.replacingOccurrences(of: ".svg", with: "")
//                                        if iconName.contains("pin_") {
//                                            self.pinIconImages.append(IconImage(image: nil, name: iconName))
//                                        } else {
//                                            self.iconImages.append(IconImage(image: nil, name: iconName))
//                                        }
//                                    }
//                                }
                                
//                                DispatchQueue.main.async {
//                                    self.imageCollectionView.reloadData()
//                                }
//
//                                for blob in blobs {
//                                    do {
//                                        if let azsBlob = blob as? AZSCloudBlob {
//                                            let iconName = azsBlob.blobName.replacingOccurrences(of: ".svg", with: "")
//                                            let iconPath = iconsDirectory.appendingPathComponent(azsBlob.blobName)
//                                            try? FileManager.default.removeItem(at: iconPath)
//                                            azsBlob.downloadToFile(with: iconPath, append: true) { error in
//                                                if error == nil {
//                                                    if azsBlob.blobName.contains("pin_") {
//                                                        let iconImage = self.pinIconImages.filter { iconImage in
//                                                            return iconImage.name == iconName
//                                                        }.first
//                                                        let iconFilePath = self.iconsDirectoryPath().appendingPathComponent(iconImage?.name.appending(".svg") ?? "")
//                                                        iconImage?.image = FieldNoteIcons.icon(filePath: iconFilePath.path, size: self.flowLayout.itemSize, primaryColorHex: self.houseColor.hexString ?? "000000", secondaryColorHex: UIColor.white.hexString ?? "000000", tertiaryColorHex: UIColor.white.hexString ?? "000000", pinFillColorHex: UIColor.white.hexString ?? "000000")
//                                                        DispatchQueue.main.async {
//                                                            if self.showPinSwitch.isOn {
//                                                                self.imageCollectionView.reloadData()
//                                                            }
//                                                        }
//                                                    } else {
//                                                        let iconImage = self.iconImages.filter { iconImage in
//                                                            return iconImage.name == iconName
//                                                        }.first
//                                                        let iconFilePath = self.iconsDirectoryPath().appendingPathComponent(iconImage?.name.appending(".svg") ?? "")
//                                                        iconImage?.image = FieldNoteIcons.icon(filePath: iconFilePath.path, size: self.flowLayout.itemSize, primaryColorHex: self.houseColor.hexString ?? "000000", secondaryColorHex: UIColor.white.hexString ?? "000000", tertiaryColorHex: UIColor.white.hexString ?? "000000", pinFillColorHex: UIColor.white.hexString ?? "000000")
//                                                        DispatchQueue.main.async {
//                                                            if !self.showPinSwitch.isOn {
//                                                                self.imageCollectionView.reloadData()
//                                                            }
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                            }

//                            self.continuationToken = resultSegment?.continuationToken
//                        }
//                        print("Stop")
//                    }
//                } else {
//                    print("Error: \(String(describing: error))")
//                }
//            }
            

//        } catch {
//            print("Error")
//        }
        
    }

    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if string.contains(".svg") && !string.contains("https") {
            let iconName = string.replacingOccurrences(of: ".svg", with: "")
            if iconName.contains("pin_") {
                self.pinIconImages.append(IconImage(image: nil, name: iconName))
            } else {
                self.iconImages.append(IconImage(image: nil, name: iconName))
            }
            print("Found Characters \(string)")
            DispatchQueue.main.async {
                self.imageCollectionView.reloadData()
            }
            
            let iconsDirectory = iconsDirectoryPath()
            let localIconPath = iconsDirectory.appendingPathComponent(string)
            
            if let svgURL = URL(string: iconBlobDirectory.appending(string)) {
                let svgRequest = URLRequest(url: svgURL)
                URLSession.shared.downloadTask(with: svgRequest) { tempURL, response, error in
                    if error == nil {
                        do {
                            if let tempURL = tempURL {
                                if FileManager.default.fileExists(atPath: localIconPath.path) {
                                    try FileManager.default.removeItem(at: localIconPath)
                                }
                                
                                try FileManager.default.copyItem(at: tempURL, to: localIconPath)
                                if string.contains("pin_") {
                                    let iconImage = self.pinIconImages.filter { iconImage in
                                        return iconImage.name == iconName
                                    }.first
                                    let iconFilePath = self.iconsDirectoryPath().appendingPathComponent(iconImage?.name.appending(".svg") ?? "")
                                    iconImage?.image = FieldNoteIcons.icon(filePath: iconFilePath.path, size: self.flowLayout.itemSize, primaryColorHex: self.houseColor.hexString ?? "000000", secondaryColorHex: UIColor.white.hexString ?? "000000", tertiaryColorHex: UIColor.white.hexString ?? "000000", pinFillColorHex: UIColor.white.hexString ?? "000000")
                                    DispatchQueue.main.async {
                                        if self.showPinSwitch.isOn {
                                            self.imageCollectionView.reloadData()
                                        }
                                    }
                                } else {
                                    let iconImage = self.iconImages.filter { iconImage in
                                        return iconImage.name == iconName
                                    }.first
                                    let iconFilePath = self.iconsDirectoryPath().appendingPathComponent(iconImage?.name.appending(".svg") ?? "")
                                    iconImage?.image = FieldNoteIcons.icon(filePath: iconFilePath.path, size: self.flowLayout.itemSize, primaryColorHex: self.houseColor.hexString ?? "000000", secondaryColorHex: UIColor.white.hexString ?? "000000", tertiaryColorHex: UIColor.white.hexString ?? "000000", pinFillColorHex: UIColor.white.hexString ?? "000000")
                                    DispatchQueue.main.async {
                                        if !self.showPinSwitch.isOn {
                                            self.imageCollectionView.reloadData()
                                        }
                                    }
                                }
                            }
                        } catch {
                            print("Error \(error)")
                        }
                    } else {
                        print("Error: \(String(describing: error))")
                    }
                }.resume()
            }

        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Done")
    }
    
    func iconsDirectoryPath() -> URL {
        let DocumentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let DirPath = DocumentDirectory.appendingPathComponent("Icons")
        do
        {
            try FileManager.default.createDirectory(atPath: DirPath.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            print("Unable to create directory \(error.debugDescription)")
        }
        
        return DirPath
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
        if self.showPinSwitch.isOn {
            self.pinIconImages.forEach { iconImage in
                let iconFilePath = self.iconsDirectoryPath().appendingPathComponent(iconImage.name.appending(".svg"))
                iconImage.image = FieldNoteIcons.icon(filePath: iconFilePath.path, size: self.flowLayout.itemSize, primaryColorHex: self.houseColor.hexString ?? "000000", secondaryColorHex: UIColor.white.hexString ?? "000000", tertiaryColorHex: UIColor.white.hexString ?? "000000", pinFillColorHex: UIColor.white.hexString ?? "000000")
                
            }
        } else {
            self.iconImages.forEach { iconImage in
                let iconFilePath = self.iconsDirectoryPath().appendingPathComponent(iconImage.name.appending(".svg"))
                iconImage.image = FieldNoteIcons.icon(filePath: iconFilePath.path, size: self.flowLayout.itemSize, primaryColorHex: self.houseColor.hexString ?? "000000", secondaryColorHex: UIColor.white.hexString ?? "000000", tertiaryColorHex: UIColor.white.hexString ?? "000000", pinFillColorHex: UIColor.white.hexString ?? "000000")
                
            }
        }
    }

    
    func updateImageCells() {
        DispatchQueue.main.async {
            self.refreshIconImages()
            self.imageCollectionView.reloadData()
        }
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
        return self.showPinSwitch.isOn ? pinIconImages.count : iconImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath as IndexPath) as! ImageCollectionViewCell
        
        let images = self.showPinSwitch.isOn ? pinIconImages : iconImages
        let iconImage = images[indexPath.row]
        if let image = iconImage.image {
            cell.spinner.stopAnimating()
            cell.imageView.isHidden = false
            cell.imageView.image = image
        } else {
            cell.imageView.isHidden = true
        }
        
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

