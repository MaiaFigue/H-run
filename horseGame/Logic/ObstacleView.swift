
import SwiftUI

// View representing an obstacle with a GIF image
struct ObstacleView : View {
    var body: some View {
        GifImageView("heno")    // Display the GIF image named "heno"
            .frame(width: 50, height: 50)   // Set the frame size of the view
            
    }
}
