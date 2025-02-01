import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthPage()
    }

    private func loadAuthPage() {
        let authURLString = "https://unsplash.com/oauth/authorize?client_id=\(Constants.accessKey)&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&scope=public+read_user"
        if let authURL = URL(string: authURLString) {
            webView.load(URLRequest(url: authURL))
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url, let code = extractCode(from: url) {
            OAuthService.shared.fetchOAuthToken(with: code) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.dismiss(animated: true)
                    case .failure:
                        let alert = UIAlertController(title: "Ошибка", message: "Не удалось авторизоваться", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }

    private func extractCode(from url: URL) -> String? {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let queryItems = components.queryItems,
           let codeItem = queryItems.first(where: { $0.name == "code" }) {
            return codeItem.value
        }
        return nil
    }
}
