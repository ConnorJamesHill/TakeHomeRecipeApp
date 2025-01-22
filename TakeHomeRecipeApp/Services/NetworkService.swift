// this file handles the api call for recipes.

// actor is used so that there is thread safety which

// singleton structure is used because we only need one instance of this to be shared throughout the app

// * 1: create the url to be used for the call

// * 2: actually make the call

// * 3: pull out the response as a HTTPURLResponse to be checked for validity

// * 4: make sure that the response is coming through correctly

// * 5: Pull out the data and decode it using JSONDecoder. Now we can use the data from the api in the app assuking no errors are thrown! :)

import Foundation

actor NetworkService {
    static let shared = NetworkService()
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    
    private init() {}
    
    func fetchRecipes() async throws -> [Recipe] {
// * 1
        guard let url = URL(string: "\(baseURL)/recipes.json") else {
            throw NetworkError.invalidURL
        }
// * 2
        let (data, response) = try await URLSession.shared.data(from: url)
        
// * 3
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

// * 4
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
// * 5
        do {
            let recipeResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return recipeResponse.recipes
        } catch {
            throw NetworkError.decodingError
        }
    }
} 
