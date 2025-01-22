//
//  RecipeRowView.swift
//  TakeHomeRecipeApp
//
//  Created by Connor Hill on 1/22/25.
//

// this is really where we get to using the data we get from the api call.

// we need to use an init here because we are using two things together: a) a recipe that is undefined until recipeRow is initialized and b) we have a viewmodel we are loading in. The viewmodel relies on the recipe to exist in order to be intialized, so that is what we make sure happens by unist an init.

// since the recipe row has multiple things going on, I went ahead and separated its various elements into smaller views to be used in the body view.

// * 1: we need a placeholder image here because the image is loaded asynchronously. This means that it is possible to not have anything ready to show while the async function is running so we have a placeholder in those moments similar to how websites use placeholder text when loading images :)

// * 2: since the viewModel loads things asynchronously, it is possible for it to not have anything to show. We use a progress view.


import SwiftUI

struct RecipeRowView: View {
    private let recipe: Recipe
    @StateObject private var viewModel: RecipeRowViewModel
    
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self._viewModel = StateObject(wrappedValue: RecipeRowViewModel(recipe: recipe))
    }
    
    var body: some View {
        HStack(spacing: 12) {
            recipeImage
            recipeDetails
        }
        .task {
            await viewModel.loadImage()
        }
    }
    
    private var recipeImage: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
// * 1
                placeholderImage
            }
        }
    }
    
    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
// * 2
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
            }
    }
    
    private var recipeDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(recipe.name)
                .font(.headline)
            
            Text(recipe.cuisine)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
