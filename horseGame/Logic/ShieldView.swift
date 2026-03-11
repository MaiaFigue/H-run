
import SwiftUI

// View representing a shield image
struct ShieldView: View {
    var body: some View {
        Image("shield") // Display the image named "shield"
            .resizable()    // Allow the image to be resizable
            .frame(width: 40, height: 40)   // Set the frame size of the view
    }
}

