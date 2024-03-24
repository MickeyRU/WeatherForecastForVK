import UIKit

final class CityCell: UITableViewCell {
    static let reuseIdentifier = "CityCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .dayCellbg.withAlphaComponent(0.3)
        layer.borderWidth = 1
        layer.borderColor = UIColor.brd.cgColor
    }
}
