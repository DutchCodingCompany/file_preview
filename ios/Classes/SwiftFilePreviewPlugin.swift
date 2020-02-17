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
        if (call.method == "getThumbnail") {
            var filePath = call.arguments as! String
            if #available(iOS 13.0, *) {
                filePath = filePath.replacingOccurrences(of: " ", with: "%20")
                if let url = URL(string: "file://\(filePath)") {
                    let size =  CGSize(width: 210, height: 297)
                    getThumbnail(filePath: url, size: size) { data in
                        if let image = data {
                            result(image)
                        } else {
                            result(FlutterError(code: "404", message: "Could not generate thumbnail", details: nil))
                        }
                    }
                } else {
                    result(FlutterError(code: "400", message: "File path not formatted properly", details: nil))
                }
            } else {
                result(FlutterError(code: "400", message: "Action not supported in this iOS version", details: nil))
            }
        }
    }
    
    @available(iOS 13.0, *)
    private func getThumbnail(filePath: URL, size: CGSize, handler: @escaping (FlutterStandardTypedData?) -> Void) -> Void {
        let request = QLThumbnailGenerator.Request(fileAt: filePath, size: size, scale: UIScreen.main.scale, representationTypes: .all)
        QLThumbnailGenerator.shared.generateBestRepresentation(for: request) { (thumbnail, error) in
            debugPrint("thumbnail: \(thumbnail.debugDescription)")
            if thumbnail == nil {
                debugPrint("failed to get a thumbnail: \(error.debugDescription)")
                handler(nil)
            } else {
                handler(FlutterStandardTypedData(bytes: (thumbnail?.uiImage.jpegData(compressionQuality: 1.0))!))
            }
        }
    }
}
