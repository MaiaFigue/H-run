
import SwiftUI

//View for the horse character
struct HorseView: View {
    //Binding to the horse's position
    @Binding var horsePosition: CGPoint
    //State variable to block jumping
    @State var blockJump: Bool = false
    
    var body: some View {
        //Display the horse GIF image
        GifImageView("horsing")
            .frame(width: 150, height: 150) // Set frame size
            .offset(x: horsePosition.x, y: horsePosition.y) // Position the horse based on its current position
            .onReceive(Keyboard.shared.$keyEvent) { event in // Listen for keyboard events
                switch event {
                case .leftArrowKeyDown:
                    self.moveHorseLeft() // Move horse left
                case .rightArrowKeyDown:
                    self.moveHorseRight() // Move horse right
                case .spacebarKeyDown:
                    print(horsePosition.y)
                    if horsePosition.y == 0 && !blockJump {
                        jump() // Make the horse jump if conditions are met
                    }
                default:
                    break
                }
            }
    }
    
    //Function to move the horse left
    func moveHorseLeft() {
        if horsePosition.x > -120 {
            withAnimation {
                horsePosition.x -= 50
            }
        }
    }
    
    //Function to move the horse right
    func moveHorseRight() {
        if horsePosition.x < 300 {
            withAnimation {
                horsePosition.x += 50
            }
        }
    }
    
    //Function to make the horse jump
    func jump() {
        blockJump = true
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            horsePosition.y -= 100 //Move the horse up
        }
        
        //After a short delay, move the horse back down
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                horsePosition.y += 100 //Move the horse back down to its original position
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                blockJump = false //Allow jumping again
            }
        }
    }
}

//Preview for the HorseView
struct HorseView_Previews: PreviewProvider {
    static var previews: some View {
        HorseView(horsePosition: .constant(CGPoint(x: 0, y: 0)))
    }
}
