import Flutter
import UIKit
import QuickLookThumbnailing

public class SwiftFilePreviewPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "file_preview", binaryMessenger: registrar.messenger())
        let instance = SwiftFilePreviewPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getThumnail") {
            var filePath = call.arguments as! String
            if #available(iOS 13.0, *) {
                print("file path: \(filePath)")
                
                filePath = filePath.replacingOccurrences(of: " ", with: "%20")
                
                let request = QLThumbnailGenerator.Request(fileAt: URL(string: "file://" + filePath)!, size: CGSize(width: 320, height: 400), scale: UIScreen.main.scale, representationTypes: .thumbnail)
                QLThumbnailGenerator.shared.generateRepresentations(for: request) {
                    (thumbnail, type, error) in
                    DispatchQueue.main.async {
                        if thumbnail == nil || error != nil {
                            print("error: \(error.debugDescription)")
                        } else {
                            print("thumbnail has been generated")
                            result(FlutterStandardTypedData(bytes:(thumbnail?.uiImage.jpegData(compressionQuality: 1.0))!))
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
            
        }
    }
}
