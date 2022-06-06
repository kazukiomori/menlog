//
//  EULAViewController.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/06/01.
//

import Foundation
import UIKit

class EULAViewController: UIViewController{
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let EULAText: UITextView = UITextView(frame: CGRect(x: 10, y: 50, width: self.view.frame.width - 20, height: 630))
        EULAText.text = "メンレコ 使用許諾契約（EULA）\n「メンレコ」は、いわゆる「ラーメン」を記録（レコード）するアプリです。ラーメン1杯ごとの写真を記録（投稿）してください。「ラーメン」から逸脱する内容の写真の記録は禁止します。\n「ラーメン」かどうかの判断は、基本的にはユーザーの皆様のご判断に委ねますが、逸脱すると思われる記録があった場合は削除されることがあります。\n「メンレコ」のご利用にあたって以下の注意事項へのご理解及びご協力をお願いします。なお、本使用許諾契約の内容は事前の予告なしに改正されることがあります。\n・「メンレコ」から公序良俗に反する内容を記録することを禁止します\n・第三者の著作権、商標権、肖像権その他あらゆる権利を侵害するような記録の投稿は禁止します\n・「メンレコ」へ投稿された画像、コメントを無断転載・無断利用することは禁止します。ただし、当該投稿をした本人は除きます\n・他のユーザーが迷惑と感じるような行為は禁止します\n・第三者に不快感を与えるような写真の投稿はお控えください\n・同じ写真を複数の記録に使用することや、1杯のラーメンを複数回記録することは禁止します\n・Instagram等の他サービスのスクリーンショットの記録は禁止します\n・本使用許諾契約に反する記録（投稿）は、事前の通告なしに削除されることがあります\n・本使用許諾契約に反する行為が続く場合、事前の通告なしにアカウントを削除されることがあります\n・アプリ内で不適切な投稿を発見されましたら、運営者へのご報告をお願いします"
        self.view.addSubview(EULAText)
    }
    @IBAction func tappedNotAllowButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func tappedAllowButton(_ sender: Any) {
    }
    
}
