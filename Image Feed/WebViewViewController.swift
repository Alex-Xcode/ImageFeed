import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    weak var delegate: WebViewViewControllerDelegate?

    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        guard let url = createAuthorizationURL() else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    @IBAction private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
    }

    private func createAuthorizationURL() -> URL? {
        var urlComponents = URLComponents(string: Constants.authorizeURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        return urlComponents?.url
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = extractCode(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func extractCode(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.path == "/oauth/authorize/native",
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value
        else { return nil }

        return code
    }
}
