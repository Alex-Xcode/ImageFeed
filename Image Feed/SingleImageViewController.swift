import UIKit

final class SingleImageViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    private let shareButton = UIButton()
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            updateImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateImage()
    }
    
    private func setupUI() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
        setupShareButton()
    }
    
    private func setupShareButton() {
        shareButton.setImage(UIImage(named: "share_icon"), for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            shareButton.widthAnchor.constraint(equalToConstant: 44),
            shareButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func updateImage() {
        guard let image = image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImage()
    }
    
    private func rescaleAndCenterImage() {
        guard let image = image else { return }
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        let hScale = scrollView.bounds.width / image.size.width
        let vScale = scrollView.bounds.height / image.size.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        
        let newContentSize = scrollView.contentSize
        let xOffset = (newContentSize.width - scrollView.bounds.width) / 2
        let yOffset = (newContentSize.height - scrollView.bounds.height) / 2
        scrollView.setContentOffset(CGPoint(x: xOffset, y: yOffset), animated: false)
    }
    
    @objc private func didTapShareButton() {
        guard let image = image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
