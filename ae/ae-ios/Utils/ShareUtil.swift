//
//  ShareUtil.swift
//  ntrain-exthub
//
//  Created by Blaine Rothrock on 12/21/21.
//

import Foundation
import UIKit

class ShareUtil {
//    static func saveJSON<T: Codable>(from obj: T, fileName: String) -> URL? {
//        do {
//            let encoder = JSONEncoder()
//            encoder.dateEncodingStrategy = .millisecondsSince1970
//
//            let json = try encoder.encode(obj)
//            let jsonString = String(data: json, encoding: .utf8)
//
//            if let dbPath = DBManager.shared.dbFolderPath {
//                let path = dbPath.appendingPathComponent("\(fileName).json")
//
//                try jsonString?.write(
//                    to: path,
//                    atomically: true,
//                    encoding: .utf8
//                )
//
//                return path
//            }
//
//
//        } catch {
//            GeneralLogger.error("unable to save JSON for \(T.self): \(error.localizedDescription)")
//        }
//
//        return nil
//    }
    
    static func share(path: URL) {
        GeneralLogger.info("sharing \(path.absoluteString) from iOS")
            let av = UIActivityViewController(
                activityItems: [path],
                applicationActivities: nil
            )
            UIApplication
                .shared
                .windows.first?
                .rootViewController?
                .present(av, animated: true, completion: nil)
    }
}
