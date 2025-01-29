import UIKit
@preconcurrency import WebKit

final class WebViewViewController: UIViewController {
    private var webView: WKWebView!
    private let progressView = UIProgressView(progressViewStyle: .default)
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        setupProgressView()
        loadRequest()
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Подписываемся на KVO с новым API
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, _ in
            guard let self = self else { return }
            self.updateProgress()
        }
    }
    
    private func setupProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func loadRequest() {
        guard let url = URL(string: "https://unsplash.com/oauth/authorize") else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = webView.estimatedProgress >= 1.0
        //print("[WebView] Прогресс загрузки: \(webView.estimatedProgress)")
    }
    
    deinit {
        estimatedProgressObservation = nil
        //print("[WebView] Контроллер деинициализирован")
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let url = navigationResponse.response.url, url.absoluteString.contains("code=") {
            let queryItems = URLComponents(string: url.absoluteString)?.queryItems
            let code = queryItems?.first(where: { $0.name == "code" })?.value
            
            if let code = code {
                //print("[WebView] Получен код авторизации: \(code)")
                NotificationCenter.default.post(name: Notification.Name("AuthCodeReceived"), object: nil, userInfo: ["code": code])
            }
            dismiss(animated: true)
        }
        decisionHandler(.allow)
    }
}

