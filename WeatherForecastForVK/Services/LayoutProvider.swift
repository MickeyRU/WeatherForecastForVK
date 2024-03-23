import UIKit

protocol LayoutProviderProtocol {
    func createSelectedLocationLayout() -> UICollectionViewCompositionalLayout
}

final class LayoutProvider: LayoutProviderProtocol {
    func createSelectedLocationLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard 
                let self = self,
                let selectedLocationSections = SelectedLocationSections(rawValue: sectionIndex)
            else { return nil }

            switch selectedLocationSections {
            case .weeklyForecast:
                return self.scrollingSection()
            case .selectedDayInfo:
                return self.twoItemSection()
            }
        }
    }
    
    private func scrollingSection() -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(1), height: .absolute(146))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(60), heightDimension: .absolute(146)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.bottom = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 20, bottom: 0, trailing: 20)
        return section
    }
    
    private func twoItemSection() -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(0.5), height: .absolute(166))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute((166))), subitems: [item, item])
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 15)
        section.interGroupSpacing = 10
        return section
    }
    
    private func createItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension) -> NSCollectionLayoutItem {
        return NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width,
                                                                         heightDimension: height))
    }
}
