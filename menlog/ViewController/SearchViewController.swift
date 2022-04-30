
import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = ShopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            loadShopData()
    }
    private func loadShopData(){
        viewModel.getShopData {[weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.numberOfRowsInsection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShopTableViewCell 
        
        let shop = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValueOf(shop)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 250
       }
}
