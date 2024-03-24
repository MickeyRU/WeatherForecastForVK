import UIKit

final class HumidityCell: UICollectionViewCell, ConfigurableCell {
    static let reuseIdentifier = "HumidityCell"

    private let headerView = CellHeaderView()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular34
        label.textColor = .primaryWhiteBlack
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
    
    func configure(with model: WeatherUIModelProtocol) {
        guard let model = model as? HumidityUIModel else {
            ErrorHandler.handle(error: .customError("Ошибка получения модели HumidityUIModel"))
            return
        }
        self.humidityLabel.text = model.humidity
        
        let title = NSLocalizedString("Humidity", tableName: "Localizable", comment: "")
        headerView.configure(with: title, icon: model.iconType)
    }
    
    private func setupViews() {
        backgroundColor = .cellConditions.withAlphaComponent(0.5)
        layer.cornerRadius = 30
        layer.borderWidth = 1
        layer.borderColor = UIColor.brd.cgColor
        
        [headerView, humidityLabel].forEach { contentView.addSubview($0) }
        [headerView, humidityLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 20),
            
            humidityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            humidityLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            humidityLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor)
        ])
    }
}
