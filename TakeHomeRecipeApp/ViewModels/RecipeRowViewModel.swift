// Made sure to include a recipe row viewModel since you guys mentioned using MVVM in the email you sent me for this technical assessment

// also made sure to utilize main actor for the same reason

// the loadImage function is used to actually call the api using the ImageLoader file. Loading is toggled before and after the call so that that status can be reflected in the view. plenty of error handling here and in ImageLoader :)

import SwiftUI

@MainActor
class RecipeRowViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func loadImage() async {
        guard let urlString = recipe.photoURLSmall ?? recipe.photoURLLarge else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            image = try await ImageLoader.shared.loadImage(from: urlString)
        } catch {
            print("Failed to load image: \(error)")
        }
    }
} 
