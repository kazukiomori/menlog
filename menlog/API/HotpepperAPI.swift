//
//  HotpepperAPI.swift
//  matchRestaurant
//
//  Created by Kazuki Omori on 2022/02/13.
//

import Foundation

final class HotpepperAPI {
    
    private var dataTask: URLSessionDataTask?
    
    func getShops(completion: @escaping (Result<Results, Error>) -> Void) {
        // 基本のURLにクエリとしてジャンル:ラーメン、フォーマット:jsonを設定
        // Todo 後で自分でURL作れるようにする　URLComponents()など使う？
        guard let url = URL(string: "https://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=7482a1925ba91a19&genre=G013&format=json") else { return }
        dataTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            guard let data = data else{
                return
            }
            // サーバから受け取ったデータをデコードする
            do{
                let result = try JSONDecoder().decode(HotPepperResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result.results))
                }
            }catch let error{
                completion(.failure(error))
            }
        }
        dataTask?.resume() // 実行する
    }
}
