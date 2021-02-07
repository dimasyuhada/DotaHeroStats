//
//  HeroDetailsViewController.swift
//  HeroStats
//
//  Created by macuser on 11/07/2020.
//  Copyright © 2020 Dimas Syuhada. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedfrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedfrom(url: url, contentMode: mode)
    }
}

class HeroDetailsViewController: UIViewController {
    
    var hero:HeroStats?
    var similarHeroes = [HeroStats]()
    var strRole = ""
    var strUrl1 = ""
    var strUrl2 = ""
    var strUrl3 = ""
    
    @IBOutlet weak var imgHero: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    
    @IBOutlet weak var lblAtkType: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblAtk: UILabel!
    @IBOutlet weak var lblArmor: UILabel!
    @IBOutlet weak var lblHealth: UILabel!
    @IBOutlet weak var lblMS: UILabel!
    
    @IBOutlet weak var imgOtherHero1: UIImageView!
    @IBOutlet weak var imgOtherHero2: UIImageView!
    @IBOutlet weak var imgOtherHero3: UIImageView!
    
    var baseUrl = "https://api.opendota.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (_,value) in hero!.roles.enumerated(){
            strRole = "\(strRole) \(value)"
        }

        lblName.text = hero?.localized_name
        lblHealth.text = "\((hero?.base_health)!)"
        lblAtk.text = "\((hero?.base_attack_max)!)"
        lblAtkType.text = "\((hero?.attack_type)!)"
        lblMS.text = "\((hero?.move_speed)!)"
        lblRole.text = strRole
        lblType.text = hero?.primary_attr.uppercased()
        
        let strUrl = baseUrl+(hero?.img)!
//        let url = URL(string: strUrl)
        
        imgHero.downloadedFrom(link: strUrl)
        
        getSimilarHeroes()
    }

    @objc func getSimilarHeroes(){
        var sortedHeroes : [HeroStats] = []
        switch hero?.primary_attr {
            case ("agi"):
                sortedHeroes = similarHeroes.sorted(by: {$0.move_speed > $1.move_speed})
                strUrl1 = baseUrl+(sortedHeroes[0].img)
                strUrl2 = baseUrl+(sortedHeroes[1].img)
                strUrl3 = baseUrl+(sortedHeroes[2].img)
            case ("str"):
                sortedHeroes = similarHeroes.sorted(by: {$0.base_attack_max > $1.base_attack_max})
                strUrl1 = baseUrl+(sortedHeroes[0].img)
                strUrl2 = baseUrl+(sortedHeroes[1].img)
                strUrl3 = baseUrl+(sortedHeroes[2].img)
            case ("int"):
                sortedHeroes = similarHeroes.sorted(by: {$0.base_mana > $1.base_mana})
                strUrl1 = baseUrl+(sortedHeroes[0].img)
                strUrl2 = baseUrl+(sortedHeroes[1].img)
                strUrl3 = baseUrl+(sortedHeroes[2].img)
            default:
                break
        }
        imgOtherHero1.downloadedFrom(link: strUrl1)
        imgOtherHero2.downloadedFrom(link: strUrl2)
        imgOtherHero3.downloadedFrom(link: strUrl3)
    }
}
