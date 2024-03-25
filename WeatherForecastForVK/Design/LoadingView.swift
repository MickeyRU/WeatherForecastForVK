import UIKit

final class LoadingView: UIView {
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular34
        label.textColor = .primaryWhiteBlack
        label.text = NSLocalizedString("loading", tableName: "Localizable", comment: "")
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [loadingLabel].forEach { addSubview($0) }
        [loadingLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
                
        NSLayoutConstraint.activate([
            loadingLabel.topAnchor.constraint(equalTo: topAnchor),
            loadingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
