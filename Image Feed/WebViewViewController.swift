import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!

    weak var delegate: AuthDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthRequest()
    }

    private func loadAuthRequest() {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.AccessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.AccessScope)
        ]
        webView.load(URLRequest(url: urlComponents.url!))
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = extractCode(from: navigationAction) {
            delegate?.authDidSucceed(withCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func extractCode(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else { return nil }
        return code
    }
}
