//
//  PostModel.swift
//  kufar-analogue
//
//  Created by Bahdan Piatrouski on 14.05.23.
//

import Foundation
import ObjectMapper

final class PostModel: Mappable {
    var balconyType = ""
    var bathroomType = ""
    var email = ""
    var description = ""
    var floor = 0
    var imageUrl = ""
    var name = ""
    var numberOfFloors = 0
    var phoneNumber = ""
    var price = 0
    var totalArea = 0.0
    var totalNumberOfRooms = 0
    
    init?(map: ObjectMapper.Map) {
        mapping(map: map)
    }
    
    func mapping(map: ObjectMapper.Map) {
        balconyType        <- map["balconyType"]
        bathroomType       <- map["bathroomType"]
        email              <- map["creatorEmail"]
        description        <- map["description"]
        floor              <- map["floor"]
        imageUrl           <- map["imageUrl"]
        name               <- map["name"]
        numberOfFloors     <- map["numberOfFloors"]
        phoneNumber        <- map["phoneNumber"]
        price              <- map["price"]
        totalArea          <- map["totalArea"]
        totalNumberOfRooms <- map["totalNumberOfRooms"]
    }
}
