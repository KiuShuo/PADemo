//
//  LearnSwiftModel.swift
//  PADemo
//
//  Created by shuo on 2018/9/11.
//  Copyright © 2018年 shuo. All rights reserved.
//

import Foundation

struct Repo: Decodable {
    let name: String
    let stars: Int
    let url: URL
    let randomDateCommit: Date
    
    private enum CodingKeys: String, CodingKey {
        case name
        case stars
        case url
        case randomDateCommit = "random_date_commit"
    }
}

// Enum的原始值一定要是Codable，一般使用的String/Int都是可以的
enum Level: String, Codable {
    case large
    case medium
    case small
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

// CustomDebugStringConvertible只是为了更好打印
class City: Codable, CustomDebugStringConvertible {
    
    let name: String
    let pop: UInt
    let level: Level
    let location: Location
    
    enum CodingKeys: String, CodingKey {
        case name = "short_name"
        case pop
        case level
        case location
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        pop = try container.decode(UInt.self, forKey: .pop)
        level = try container.decode(Level.self, forKey: .level)
        location = try container.decode(Location.self, forKey: .location)
    }
    
    var debugDescription: String {
        return """
        {
        "name": \(name),
        "pop": \(pop),
        "level": \(level.rawValue),
        "location": {
        "latitude": \(location.latitude),
        "longitude": \(location.longitude)
        }
        }
        """
    }
}
