// Made sure to include a recipe list viewModel since you guys mentioned using MVVM in the email you sent me for this technical assessment

// also made sure to utilize main actor for the same reason

// also made sure to use asnyc functions for api calls because of the same reason and... you kinda need to in order to call the api properly :)



// the fetchRecipes function is used to actually call the api using the networkService file. Loading is toggled before and after the call so that that status can be reflected in the view. plenty of error handling here and in networkService :)

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var error: NetworkError?
    @Published var isLoading = false
    
    func toggleDebugState() {
        if error != nil {
            // Reset to normal state
            error = nil
            recipes = []
            Task {
                await fetchRecipes()
            }
        } else if recipes.isEmpty {
            // Show error state
            error = NetworkError.invalidResponse
            recipes = []
        } else {
            // Show empty state
            error = nil
            recipes = []
        }
    }
    
    func fetchRecipes() async {
        isLoading = true
        error = nil
        
        do {
            recipes = try await NetworkService.shared.fetchRecipes()
        } catch let error as NetworkError {
            self.error = error
        } catch {
            self.error = .unknown(error)
        }
        
        isLoading = false
    }
} 
