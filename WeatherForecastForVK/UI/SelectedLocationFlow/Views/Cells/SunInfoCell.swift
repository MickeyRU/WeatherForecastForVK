import UIKit

final class SunInfoCell: UICollectionViewCell, ConfigurableCell {
    static let reuseIdentifier = "SunInfoCell"

    private let headerView = CellHeaderView()
    
    private let sunInfoLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular34
        label.textColor = .primaryWhiteBlack
        label.textAlignment = .center
        return label
    }()
    
    private let sunInfo2Label: UILabel = {
        let label = UILabel()
        label.font = AppFonts.regular12
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
        guard let model = model as? SunInfoUIModel else { return}
        self.sunInfoLabel.text = model.sunrise
        self.sunInfo2Label.text = model.sunset
        
        let title = NSLocalizedString("Sunrise", tableName: "Localizable", comment: "")
        headerView.configure(with: title, icon: model.iconType)
    }
    
    private func setupViews() {
        backgroundColor = .cellConditions.withAlphaComponent(0.5)
        layer.cornerRadius = 30
        layer.borderWidth = 1
        layer.borderColor = UIColor.brd.cgColor
        
        [headerView, sunInfoLabel, sunInfo2Label].forEach { contentView.addSubview($0) }
        [headerView, sunInfoLabel, sunInfo2Label].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            headerView.heightAnchor.constraint(equalToConstant: 20),
            
            sunInfoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sunInfoLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            sunInfoLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            
            sunInfo2Label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            sunInfo2Label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            sunInfo2Label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
        ])
    }
}
