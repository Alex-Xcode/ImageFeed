import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like_off"), for: .normal)
        button.setImage(UIImage(named: "like_on"), for: .selected)
        return button
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(cellImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),

            dateLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor, constant: 8)
        ])
    }

    func configure(with imageURL: String, dateText: String, isLiked: Bool) {
        if let url = URL(string: imageURL) {
            let processor = RoundCornerImageProcessor(cornerRadius: 10)
            cellImageView.kf.indicatorType = .activity
            cellImageView.kf.setImage(with: url, options: [.processor(processor)]) { result in
                switch result {
                case .success(_): break
                    //print("[ImagesListCell] Загружено изображение из: \(value.source)")
                case .failure(_): break
                    //print("[ImagesListCell] Ошибка загрузки: \(error.localizedDescription)") 
                }
            }
        }

        dateLabel.text = dateText
        likeButton.isSelected = isLiked
    }
}
