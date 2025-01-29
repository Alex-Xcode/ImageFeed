import UIKit
import JGProgressHUD

final class UIBlockingProgressHUD {
    private static let hud = JGProgressHUD(style: .dark)
    
    static func show() {
        if let window = UIApplication.shared.windows.first {
            hud.show(in: window)
        }
    }
    
    static func dismiss() {
        hud.dismiss()
    }
}
