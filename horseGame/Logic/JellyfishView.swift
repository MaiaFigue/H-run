
import SwiftUI

// View representing the jellyfish image
struct JellyfishView: View {
    var body: some View {
        GifImageView("jellyfish")   // Load the jellyfish image
            .frame(width: 100, height: 100) // Set the frame size
    }
}

// Display a preview of JellyfishView
#Preview {
    JellyfishView()
}
