
import SwiftUI

struct UfoView: View {
    var body: some View {
        GifImageView("UFO") // Display UFO GIF
            .frame(width: 50, height: 50) // Set frame size
    }
}

#Preview {
    UfoView() // Preview UFO view
}
