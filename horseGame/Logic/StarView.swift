
import SwiftUI

// View representing a star image
struct StarView: View {
    var body: some View {
        Image("star")   // Display the image named "star"
            .resizable()    // Allow the image to be resizable
            .frame(width: 30, height: 30)   // Set the frame size of the view
    }
}
