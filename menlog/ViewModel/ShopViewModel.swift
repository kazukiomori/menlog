import Foundation

class ShopViewModel {
    private var hotpepperAPI = HotpepperAPI()
    private var shop = [Shop]()
    
    func getShopData(completion: @escaping () -> ()) {
        hotpepperAPI.getShops{[weak self] (result) in
            switch result{
            case .success(let listOf):
                self?.shop = listOf.shop
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getShopDataWithLocation(lat: String, lon: String, completion: @escaping (Result<Results, Error>) -> Void) {
        hotpepperAPI.getShopWithLocation(lat: lat, lon: lon) {[weak self] (result) in
            switch result{
            case .success(let listOf):
                self?.shop = listOf.shop
                completion(result)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func numberOfRowsInsection(section: Int) -> Int{
        if shop.count != 0{
            return shop.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Shop{
        return shop[indexPath.row]
    }
}
