// just a basic list using the array of recipe structs (these structs use data acquired from the api call we do, using codable so that we can decode the data into them) that are identifiable, so they appear properly in a list. The structs are thrown into a recipe row view which allows for a really clean codebase imo :)

import SwiftUI

struct RecipeListView: View {
    let recipes: [Recipe]
    
    var body: some View {
        List(recipes) { recipe in
            RecipeRowView(recipe: recipe)
        }
        .listStyle(.plain)
    }
}
