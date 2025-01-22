// basic struct model for the recipes loaded in from the api you provided in the assesment instructions. It is codable to make it easy to decode using json and it is identifiable in order to make it easy to use these structs in lists etc.

// the coding keys are used because the api uses keys that have multiple words. Swift works better with camel case rather than snake case or other naming conventions.

// the struct recipe response defined below is just a struct object that contains an array of recipes. this will be used when decoding the recipes from the api and it makes it easy to access the api's data throughout the app. :)

import Foundation

struct Recipe: Codable, Identifiable {
    let cuisine: String
    let name: String
    let photoURLLarge: String?
    let photoURLSmall: String?
    let uuid: String
    let sourceURL: String?
    let youtubeURL: String?
    
    var id: String { uuid }
    
    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case uuid
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
} 
