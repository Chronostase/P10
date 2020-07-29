//
//  Recipe.swift
//  Reciplease
//
//  Created by Thomas on 17/07/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import CoreData

struct RecipeList: Decodable {
    var q: String
    var hits: [Hit]
}

struct Hit: Decodable {
    var recipe: RecipeDetails
}

struct RecipeDetails: Decodable {
    var label: String
    var image: String
    var url: String
    var yield: Double
    var ingredientLines: [String]
    var totalTime: Double
    var imageData: Data?
    
}

//class RecipeDetails: NSManagedObject, Decodable {
//
//    enum CodingKeys: String, CodingKey {
//        case name = "label"
//        case image
//        case url
//        case yield
//        case ingredientLines
//        case totalTime
//        case imageData
//    }
//
//    init(name: String, image: String, url: String, yield: Double, ingredientLines: String,
//         totalTime: Double, imageData: Data) {
//        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
//            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext else {
//            return
//        }
//        let context = NSManagedObjectContext()
//        super.init(context: context)
//
//        self.name = name
//        self.image = image
//        self.url = url
//        self.yield = yield
//        self.ingredientLines = ingredientLines
//        self.totalTime = totalTime
//        self.imageData = imageData
//    }
//
//    required convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let name: String = try container.decode(String.self, forKey: .name)
//        let image: String = try container.decode(String.self, forKey: .image)
//        let url: String = try container.decode(String.self, forKey: .url)
//        let yield: Double = try container.decode(Double.self, forKey: .yield)
//        let ingredientLines: String = try container.decode(String.self, forKey: .ingredientLines)
//        let totalTime: Double = try container.decode(Double.self, forKey: .totalTime)
//        let imageData: Data = try container.decode(Data.self, forKey: .imageData)
//
//        self.init(name: name, image: image, url: url, yield: yield, ingredientLines: ingredientLines, totalTime: totalTime, imageData: imageData)
//    }
    
//
//    @NSManaged var label: String?
//    @NSManaged var image: String?
//    @NSManaged var url: String?
//    @NSManaged var yield: NSValue?
//    @NSManaged var ingredientLines: [String]?
//    var totalTime: Double?
//    @NSManaged var imageData: Data?
//
//    required convenience init(from decoder: Decoder) throws {
//        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
//            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
//            let entity = NSEntityDescription.entity(forEntityName: "RecipeDetails", in: managedObjectContext) else {
//            fatalError("Failed to decode User")
//        }
//        self.init(entity: entity, insertInto: managedObjectContext)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.name = try container.decodeIfPresent(String.self, forKey: .name)
//        self.image = try container.decodeIfPresent(String.self, forKey: .image)
//        self.url = try container.decodeIfPresent(String.self, forKey: .url)
//        //Pas sur
//        self.yield = try container.decodeIfPresent(Double.self, forKey: .yield) ?? 0
//        self.ingredientLines = try container.decodeIfPresent(String.self, forKey: .ingredientLines)
//        //Pas sur
//        self.totalTime = try container.decodeIfPresent(Double.self, forKey: .totalTime) ?? 0
//        self.imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
//
//    }
//}
