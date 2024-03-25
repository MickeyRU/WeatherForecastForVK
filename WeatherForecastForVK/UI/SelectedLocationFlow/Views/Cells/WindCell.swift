import UIKit

final class WindCell: UICollectionViewCell, ConfigurableCell {
    static let reuseIdentifier = "WindCell"

    private let headerView = CellHeaderView()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular12
        label.textColor = .primaryWhiteBlack
        label.textAlignment = .center
        return label
    }()
    
    private let windDirectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: WeatherUIModelProtocol) {
        guard let model = model as? WindUIModel else {
            ErrorHandler.handle(error: .customError("Ошибка получения модели WindUIModel"))
            return
        }
        self.windSpeedLabel.text = model.windSpeed
        self.windDirectionImageView.image = UIImage(named: model.windDirection)
    
        let title = NSLocalizedString("Wind", tableName: "Localizable", comment: "")
        headerView.configure(with: title, icon: model.iconType)
    }
    
    private func setupViews() {
        backgroundColor = .cellConditions.withAlphaComponent(0.5)
        layer.cornerRadius = 30
        layer.borderWidth = 1
        layer.borderColor = UIColor.brd.cgColor
        
        [headerView, windDirectionImageView, windSpeedLabel].forEach { contentView.addSubview($0) }
        [headerView, windDirectionImageView, windSpeedLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 20),
            
            windDirectionImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            windDirectionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            windDirectionImageView.widthAnchor.constraint(equalToConstant: 50),
            windDirectionImageView.heightAnchor.constraint(equalToConstant: 50),
            
            windSpeedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            windSpeedLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            windSpeedLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
        ])
    }
}
