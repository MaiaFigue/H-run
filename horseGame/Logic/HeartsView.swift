
import SwiftUI

// View representing hearts based on the number of lives
struct HeartsView: View {
    var lives: Int   // Number of lives to display
    var body: some View {
        HStack {
            ForEach(0..<lives, id: \.self) { _ in   // Loop through each life
                Image(systemName: "heart.fill") // Display a filled heart icon
                    .foregroundColor(.red)  // Set the heart color to red
            }
        }
    }
}
