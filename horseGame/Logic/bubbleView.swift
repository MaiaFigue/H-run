
import SwiftUI

// View representing the bubble image
struct bubbleView: View {
    var body: some View {
        Image("bubble") // Load the bubble image
            .resizable()    // Allow image resizing
            .frame(width: 50, height: 50)   // Set the frame size
    }
}

// Display a preview of BubbleView
#Preview {
    bubbleView()
}
