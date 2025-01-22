//
//  ContentView.swift
//  TakeHomeRecipeApp
//
//  Created by Connor Hill on 1/21/25.
//

// deploying to iOS 16 simply because I saw in the asessment email that you deploy to that version of iOS

// this page basically determines which of the 3 required views will show based on the status of the api call and/or the data that is brought back.

// * 1: if the call is en route, this will trigger a progress view so that the user knows something is going on, and to bascially just wait a sec.

// * 2: this error view is triggered whenever there is some sort of error involved in the api call process or otherwise.

// * 3: this is called when the data is empty. This could tehcnically be because of some sort of error or something, so there is an option to refresh and flesh out the data properly

// * 4: this is what is ideally shown to the user. this shows the data displayed as desired to the user when no errors or empty data sets are found and we actually can start cooking with this recipe app! :)

// * 5: this button is used to flip through various app states since the interview assesment specifically asked for an empty state view and an error state view. I made it so that you can check that out using the visual button next to the refresh button!

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
// * 1
                if viewModel.isLoading {
                    ProgressView()
// * 2
                } else if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.fetchRecipes()
                        }
                    }
// * 3
                } else if viewModel.recipes.isEmpty {
                    EmptyStateView {
                        Task {
                            await viewModel.fetchRecipes()
                        }
                    }
// * 4
                } else {
                    RecipeListView(recipes: viewModel.recipes)
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
// * 5
                        Button {
                            viewModel.toggleDebugState()
                        } label: {
                            Image(systemName: "eye")
                        }
                        Button {
                            Task {
                                await viewModel.fetchRecipes()
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchRecipes()
        }
    }
}

#Preview {
    ContentView()
}
