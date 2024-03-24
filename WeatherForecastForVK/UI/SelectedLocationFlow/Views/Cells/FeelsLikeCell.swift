import UIKit

final class FeelsLikeCell: UICollectionViewCell, ConfigurableCell {
    private let headerView = CellHeaderView()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular34
        label.textColor = .primaryWhiteBlack
        return label
    }()
    
    static var reuseIdentifier: String {
        return "FeelsLikeCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: WeatherUIModelProtocol) {
        guard let model = model as? FeelsLikeUIModel else { return}
        self.temperatureLabel.text = model.temperature
        
        let title = NSLocalizedString("Feels Like", tableName: "Localizable", comment: "")
        headerView.configure(with: title, icon: model.iconType)
    }
    
    private func setupViews() {
        backgroundColor = .cellConditions.withAlphaComponent(0.5)
        layer.cornerRadius = 30
        layer.borderWidth = 1
        layer.borderColor = UIColor.brd.cgColor
        
        [headerView, temperatureLabel].forEach { contentView.addSubview($0) }
        [headerView, temperatureLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 20),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
        ])
    }
}
