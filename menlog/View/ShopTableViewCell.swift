
import UIKit

class ShopTableViewCell: UITableViewCell {
    
    private var urlString: String = ""
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var shopDescription: UILabel!
    
    
    func setCellWithValueOf(_ shop:Shop){
        updateUI(name: shop.name, catch: shop.catch, logoImage: shop.logoImage!)
    }
    
    private func updateUI(name: String, `catch`: String, logoImage: URL){
        self.shopName.text = name
        self.shopDescription.text = `catch`
        
        getImageDataFrom(url: logoImage)
    }
    
    private func getImageDataFrom(url: URL){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                print("Enpty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data){
                    self.shopImage.image = image
                }
            }
        }.resume()
    }
    
}
