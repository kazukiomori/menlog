//
//  MapViewController.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/05/19.
//

import UIKit
import MapKit
import GoogleMaps
import SDWebImage

class MapViewController: UIViewController {
    
    private var viewModel = ShopViewModel()
    private var hotpepperAPI = HotpepperAPI()
    var mapView = GMSMapView()
    private var shop = [Shop]()
    private let shopImage: UIImage = {
        let shopImage = UIImage()
        return shopImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupMap()
        getShopDataWithLocation()
    }
    
    
    private func setupMap() {
        guard let lat = latitude else { return }
        guard let lon = longitude else { return }
        // GoogleMapの初期位置(自身の今いる場所)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }
    
    
    private func getShopDataWithLocation(){
        guard let lat = latitude else { return }
        guard let lon = longitude else { return }
        
        let latString = String(lat)
        let lonString = String(lon)
        
        hotpepperAPI.getShopWithLocation(lat: latString, lon: lonString) {[weak self] (result) in
            switch result{
            case .success(let listOf):
                self?.shop = listOf.shop
                if self?.shop == nil { return }
                for i in 0 ..< (self?.shop.count)! {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: (self?.shop[i].lat)!, longitude: (self?.shop[i].lng)!)
                    marker.title = "\((self?.shop[i].name)!)"
                    marker.snippet = "\((self?.shop[i].catch)!)"
                    if ((self?.shop[i].logoImage) != nil) {
                        let shopName = (self?.shop[i].logoImage)!.absoluteString
                        marker.icon = UIImage(url: shopName)
                    }
                    marker.map = self?.mapView
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

