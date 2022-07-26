//
//  UrlExporter.swift
//  VUCCI
//
//  Created by Jason bartley on 5/9/22.
//

import Foundation
import UIKit
import MediaPlayer

final class UrlExporter {
    
    static let shared = UrlExporter()
    
    func export(_ assetURL: URL, completionHandler: @escaping (_ fileURL: URL?, _ error: Error?) -> ()) {
        let asset = AVURLAsset(url: assetURL)
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completionHandler(nil, ExportError.unableToCreateExporter)
            return
        }

        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(NSUUID().uuidString)
            .appendingPathExtension("m4a")

        exporter.outputURL = fileURL
        exporter.outputFileType = .m4a
        
        exporter.exportAsynchronously {
            if exporter.status == .completed {
                completionHandler(fileURL, nil)
            } else {
                completionHandler(nil, exporter.error)
            }
        }
    }

    func exportUsage(with mediaItem: MPMediaItem) {
        if let assetURL = mediaItem.assetURL {
            export(assetURL) { fileURL, error in
                guard let fileURL = fileURL, error == nil else {
                    print("export failed")
                    return
                }

                // use fileURL of temporary file here
                print("\(fileURL)")
            }
        }
    }

    enum ExportError: Error {
        case unableToCreateExporter
    }
    
}
