import UIKit

protocol AuthDelegate: AnyObject {
    func authDidSucceed(withCode code: String)
}

final class AuthViewController: UIViewController {
    private let showWebViewSegue = "ShowWebViewSegue"
    weak var delegate: AuthDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegue,
           let webViewVC = segue.destination as? WebViewViewController {
            webViewVC.delegate = delegate
        }
    }
}
