//
//  UserModel.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 5.06.23.
//

import Foundation
import ObjectMapper

final class UserModel: Mappable {
    var email = ""
    var role = ""
    
    init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        email <- map["email"]
        role  <- map["role"]
    }
}
