import UIKit

final class CellHeaderView: UIView {
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cellTitle
        label.font = AppFonts.semibold12
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, icon: CellIconType) {
        self.cellImageView.image = icon.icon
        self.titleLabel.text = title
    }
    
    private func setupViews() {
        [cellImageView, titleLabel].forEach { addSubview($0) }
        [cellImageView, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            cellImageView.widthAnchor.constraint(equalToConstant: 20),
            cellImageView.heightAnchor.constraint(equalToConstant: 20),
            cellImageView.topAnchor.constraint(equalTo: topAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: cellImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
