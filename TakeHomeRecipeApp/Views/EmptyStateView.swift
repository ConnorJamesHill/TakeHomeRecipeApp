// pretty simple, self explanatory view

// the only atypical thing is that we use a closure that is passed to the empty state view that allows the user to reload the api data, hopefully negating any empty data issues encountered.

import SwiftUI

struct EmptyStateView: View {
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Recipes Available")
                .font(.headline)
            
            Text("Try refreshing to load recipes")
                .foregroundColor(.secondary)
            
            Button("Refresh") {
                retryAction()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
