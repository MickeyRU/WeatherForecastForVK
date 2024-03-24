import Combine

protocol OtherLocationViewModelProtocol {
    var locationsPublisher: AnyPublisher<[LocationInfo], Never> { get }

    func performSearch(_ searchText: String)    
    func userSelectLocation (location: LocationInfo)
}
