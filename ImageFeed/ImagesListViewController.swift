import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    private let photosName = (0..<20).map { "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = ImagesListCell.reuseIdentifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ImagesListCell else {
            fatalError("Unable to dequeue ImagesListCell")
        }
        configure(cell, at: indexPath)
        return cell
    }
}

extension ImagesListViewController {
    private func configure(_ cell: ImagesListCell, at indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        
        cell.configure(with: image,
                       date: dateFormatter.string(from: Date()),
                       isLiked: indexPath.row % 2 == 0)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return 200 }
        
        let padding: CGFloat = 16
        let availableWidth = tableView.bounds.width - padding
        let imageAspectRatio = image.size.height / image.size.width
        return availableWidth * imageAspectRatio + padding
    }
}
