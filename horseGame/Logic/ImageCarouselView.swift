
import SwiftUI

struct ImageCarouselView: View {
    @Environment (\.presentationMode) var presentationMode  // Environment variable for presentation mode
    @State private var currentIndex = 0 // State to track current index of images
    let images: [String] = ["chooseMap", "keys", "starAbility", "shieldsAbility", "obstacleWarn"]   // Array of image names
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    // Loop through images and display them with opacity based on currentIndex
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .opacity(self.currentIndex == index ? 1 : 0)
                            .animation(.easeInOut(duration: 0.5), value: currentIndex)
                    }
                }
            }
            
            // Navigation buttons
            HStack {
                Button(action: {
                    self.previousImage()
                }) {
                    Image(systemName: "chevron.left")
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // OK button to dismiss the view
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("OK!")
                        .padding(10)
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button(action: {
                    self.nextImage()
                }) {
                    Image(systemName: "chevron.right")
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // Function to go to previous image
    private func previousImage() {
        self.currentIndex = (self.currentIndex - 1 + self.images.count) % self.images.count
    }
    
    // Function to go to next image
    private func nextImage() {
        self.currentIndex = (self.currentIndex + 1) % self.images.count
    }
}

// Preview for ImageCarouselView
#Preview {
    ImageCarouselView()
}
