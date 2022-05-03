import Foundation
import UIKit

class CloudController {
    private static var accountKey = "qEpXWfVqRhFDvyLmrXfLZN/wNvMQ3ekdBF5ztrBGbpxmvTSkHuoNBRkZzmNYHe8bOYOLVRvElDNlri80x1ZiyQ=="
    private static var storageURL = URL(string: "https://fieldnotemedia.blob.core.windows.net")
    private static var storageName = "fieldnotemedia"
    
//    private static func getFile(url: URL, onUpdateProgress: ((Double) -> Void)? = nil) async throws -> Data? {
//        let (asyncBytes, response) = try await URLSession.shared.bytes(for: URLRequest(url: url))
//        let length = Int(response.expectedContentLength)
//        var data = Data()
//        data.reserveCapacity(length)
//
//        var fastRunningProgress: Double = 0
//        for try await byte in asyncBytes {
//            data.append(byte)
//            let currentProgress = Double(data.count) / Double(length)
//
//            if Int(fastRunningProgress * 100) != Int(currentProgress * 100) {
//                await MainActor.run { onUpdateProgress?(currentProgress * 100) }
//                fastRunningProgress = currentProgress
//            }
//        }
//
//        if data.count == length {
//            return data
//        }
//        return nil
//    }
//    private static func uploadFile(accountID: String, fileURL: URL, fileReferencePath: String) async throws {
//        let credentials = AZSStorageCredentials(accountName: storageName, accountKey: accountKey)
//        let account = try AZSCloudStorageAccount(credentials: credentials, useHttps: true)
//        let client = account.getBlobClient()
//        let container = client.containerReference(fromName: accountID)
//        
//        try await container.createContainerIfNotExists()
//        let blob = container.blockBlobReference(fromName: fileReferencePath)
//        try await blob.uploadFromFile(with: fileURL)
//    }
//    
//    static func uploadMedia(_ media: Media, imageURL: URL) async throws {
//        let photoPath = "\(media.templateType!)/\(media.recordID!)/\(media.fileName!)"
//        try await uploadFile(accountID: media.accountID, fileURL: imageURL, fileReferencePath: photoPath)
//    }
//    static func getMediaFile(_ media: Media, onUpdateProgress: ((Double) -> Void)? = nil) async throws -> Data? {
//        if let url = storageURL?.appendingPathComponent("\(media.accountID!)/\(media.templateType!)/\(media.recordID!)/\(media.fileName!)") {
//            return try await getFile(url: url, onUpdateProgress: onUpdateProgress)
//        }
//        return nil
//    }
//    static func getGISFile(accountID: String, fileName: String, onUpdateProgress: ((Double) -> Void)? = nil) async throws -> Data? {
//        if let url = storageURL?.appendingPathComponent("\(accountID)/GIS/\(fileName)") {
//            return try await getFile(url: url, onUpdateProgress: onUpdateProgress)
//        }
//        return nil
//    }
}
