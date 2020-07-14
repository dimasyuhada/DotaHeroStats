//
//  Hero.swift
//  HeroStats
//
//  Created by macuser on 10/07/2020.
//  Copyright © 2020 Dimas Syuhada. All rights reserved.
//

import Foundation

struct Hero: Codable {
    var id: Int = 0
    var localized_name: String = ""
    var primary_attr: String = ""
    var attack_type: String = ""
    var roles: [String]
    var img: String = ""
    var base_health: Int = 0
    var base_attack_max: Int = 0
    var base_mana: Int = 0
    var move_speed: Int = 0
}


