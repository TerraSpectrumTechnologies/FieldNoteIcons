//
//  ViewController.swift
//  FieldNoteIcons
//
//  Created by BreckClone on 01/06/2022.
//  Copyright (c) 2022 BreckClone. All rights reserved.
//

import UIKit
import FieldNoteIcons
import AZSClient

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
    
    private var accountKey = "cfJKt/URdIHOLYt8grT7Z6FV3Y/LrdHObgbp7+nzfx8Y9rRMee8im1bsc4N/kboTgMsWLAySkBhbMOOVLgd+Xw=="
    private var mediaAccountKey = "qEpXWfVqRhFDvyLmrXfLZN/wNvMQ3ekdBF5ztrBGbpxmvTSkHuoNBRkZzmNYHe8bOYOLVRvElDNlri80x1ZiyQ=="
    private static var storageURL = URL(string: "https://tsticons.blob.core.windows.net")
    private var storageName = "tsticons"
    private static var mediaStorageURL = URL(string: "https://fieldnotemedia.blob.core.windows.net")
    private var mediaStorageName = "fieldnotemedia"
    private var mediaAccountName = "8914ebe2-e960-4d08-a3fc-b703dd13ac05"
    
    var houseColor = UIColor.black
    var iconImages: [IconImage] = []
    var iconsNames = [String]()
    let flowLayout = UICollectionViewFlowLayout()
    var continuationToken: AZSContinuationToken?
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        let urlString = "https://tsticons.blob.core.windows.net/?comp=list"
        if let url = URL(string: urlString) {
            let defaultSession = URLSession(configuration: .default)
   
            let dataTask = defaultSession.dataTask(with: url, completionHandler: { data, response, error in
                print("stop")
            })
            
            dataTask.resume()
        }
          
        do {
            let credentials = AZSStorageCredentials(accountName: storageName, accountKey: accountKey)
            let mediaCredentials = AZSStorageCredentials(accountName: mediaStorageName, accountKey: mediaAccountKey)
            let account = try AZSCloudStorageAccount(credentials: credentials, useHttps: true)
            let mediaAccount = try AZSCloudStorageAccount(credentials: mediaCredentials, useHttps: true)
            let client = account.getBlobClient()
            let mediaClient = mediaAccount.getBlobClient()
            let container = client.containerReference(fromName: "icons")
            let mediaContainer = mediaClient.containerReference(fromName: mediaAccountName)
            mediaContainer.createContainerIfNotExists { error, created in
                
            }
            
            let blobGroup = DispatchGroup()
            let iconsDirectory = iconsDirectoryPath()
            container.createContainerIfNotExists { error, created in
                if error == nil {
                    let blobListingDetails = AZSBlobListingDetails(rawValue: 0)
                    container.listBlobsSegmented(with: self.continuationToken, prefix: nil, useFlatBlobListing: true, blobListingDetails: blobListingDetails, maxResults: 500) { error, resultSegment in
                        if error == nil {
                            if let blobs = resultSegment?.blobs {
                                for blob in blobs {
                                    blobGroup.enter()
                                    do {
                                        if let azsBlob = blob as? AZSCloudBlob {
                                            let iconName = azsBlob.blobName.replacingOccurrences(of: ".svg", with: "")
                                            let iconPath = iconsDirectory.appendingPathComponent(azsBlob.blobName)
                                            azsBlob.downloadToFile(with: iconPath, append: true) { error in
                                                if error == nil {
//                                                    print("*****" + iconName)
                                                    let cleanedIconName = iconName.replacingOccurrences(of: "pin_", with: "")
//                                                    print("***** Cleaned Icon Name:" + iconName)
                                                    if !self.iconsNames.contains(where: { name in
                                                        name == cleanedIconName
                                                    }) {
//                                                        DispatchQueue.main.async {
                                                            self.iconsNames.append(cleanedIconName)
                                                            
//                                                        }
                                                    }
                                                }
                                                blobGroup.leave()
                                            }
                                        }
                                    }
                                }
                                blobGroup.notify(queue: DispatchQueue.main) {
                                    self.updateImageCells()
                                }
                            }

                            self.continuationToken = resultSegment?.continuationToken
                        }
                        print("Stop")
                    }
                } else {
                    print("Error: \(String(describing: error))")
                }
            }
            

        } catch {
            print("Error")
        }
        
        imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImageCollectionViewCell")
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
        DispatchQueue.main.async {
            for iconName in self.iconsNames {
                if self.showPinSwitch.isOn {
                    let fullIconName = "pin_" + iconName + ".svg"
                    let iconFilePath = self.iconsDirectoryPath().appendingPathComponent(fullIconName)
                        let iconImage = FieldNoteIcons.icon(filePath: iconFilePath.path, size: self.flowLayout.itemSize, primaryColor: self.houseColor, secondaryColor: .white, tertiaryColor: .white, pinFillColor: .white)
                    self.iconImages.append(IconImage(image: iconImage ?? UIImage(), name: iconName))
                    

                } else {
                    let fullIconName = iconName + ".svg"
                    let iconFilePath = self.iconsDirectoryPath().appendingPathComponent(fullIconName)
                        let iconImage = FieldNoteIcons.icon(filePath: iconFilePath.path, size: self.flowLayout.itemSize, primaryColor: self.houseColor, secondaryColor: .white, tertiaryColor: .white, pinFillColor: .white)
                    self.iconImages.append(IconImage(image: iconImage ?? UIImage(), name: iconName))
                }
            }
            self.imageCollectionView.reloadData()
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
    
    func createIconsFolder() {
        var manager = FileManager.default

        let documentName = "test doc"
        let encoder = JSONEncoder.init()
        do {
            let rootFolderURL = try manager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

            let nestedFolderURL = rootFolderURL.appendingPathComponent("Icons")

            try manager.createDirectory(
                at: nestedFolderURL,
                withIntermediateDirectories: false,
                attributes: nil
            )

            let fileURL = nestedFolderURL.appendingPathComponent(documentName)
//            let data = try encoder.encode(object)
//            try data.write(to: fileURL)
        } catch {
            
        }

    }
    
        func iconList() -> [String] {
            var iconList:[String] = []
//            let fieldNoteIconsBundle = Bundle(for: Self.self)
//            guard let resourceBundleURL = fieldNoteIconsBundle.url(forResource: "FieldNoteIcons", withExtension: "bundle") else {
//                fatalError("FieldNoteIcons.bundle not found!")
//            }
    
            do {
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let contents = try FileManager.default.contentsOfDirectory(atPath: path?.absoluteString ?? "")
                for content in contents {
//                    print("Content \(content)")
                }
//                let contents = try FileManager.default.contentsOfDirectory(at: resourceBundleURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//                for content in contents {
//                    let iconPathSplit = content.pathComponents.split(separator: "/").last
//                    let iconFullName = iconPathSplit?.last ?? ""
//                    if !iconFullName.contains(".svg") {
//                        continue
//                    }
//
//                    let iconName = iconFullName.replacingOccurrences(of: ".svg", with: "")
//                    let cleanedIconName = iconName.replacingOccurrences(of: "Pin_", with: "")
//                    if !iconList.contains(where: { name in
//                        name == cleanedIconName
//                    }) {
//                        iconList.append(cleanedIconName)
//                    }
//                }
            } catch {
                print(error)
            }
    
            return iconList
        }
    
        func iconListFromProjectBundle() -> [String] {
            var iconList:[String] = []
            
            if let path = Bundle.main.path(forResource: "multiplepine", ofType: "svg") {
                print("Stop")
            }
            let applicationsDirectories = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true)
            let applicationsDirectoryPath = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true).first ?? ""
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//            guard let assetsURL = Bundle.main.url(forResource: "Assets", withExtension: "bundle") else {
//                fatalError("FieldNoteIcons.bundle not found!")Since
//            }
            let newPath = applicationsDirectoryPath + "/Assets"
            guard let newURL = URL(string: newPath) else {
                return []
            }
            do {
                
                let contents = try FileManager.default.contentsOfDirectory(at: newURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
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

