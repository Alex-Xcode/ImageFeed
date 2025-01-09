import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    private func setupCell() {
        cellImage.contentMode = .scaleAspectFill
        cellImage.clipsToBounds = true
        cellImage.layer.cornerRadius = 12
    }

    func configure(with image: UIImage?, date: String, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = date
        let likeImageName = isLiked ? "like_button_on" : "like_button_off"
        likeButton.setImage(UIImage(named: likeImageName), for: .normal)
    }
}
