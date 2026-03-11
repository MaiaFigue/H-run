
import SwiftUI

//Main content view
struct ContentView: View {
    //State variables to control the presentation of different views
    @State private var showMapsView = false
    @State private var showHowToPlay = false

    var body: some View {
        VStack {
            //Button to start the game and show the maps view
            Button(action: {
                showMapsView = true
            }) {
                Text("START GAME")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            
            //Button to show the "How to Play" instructions
            Button(action: {
                showHowToPlay = true
            }) {
                Text("HOW TO PLAY?")
                    .font(.headline)
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            
            //Button to exit the application
            Button(action : {
                NSApplication.shared.terminate(nil)
            }) {
                Text("EXIT")
                    .font(.headline)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
        //Sheet to show the MapsView when showMapsView is true
        .sheet(isPresented: $showMapsView) {
           MapsView()
                .frame(minWidth: 600, minHeight: 378, idealHeight: 400)
        }
        
        //Sheet to show the How to Play view when showHowToPlay is true
        .sheet(isPresented: $showHowToPlay) {
            ImageCarouselView()
                .frame(minWidth: 600, minHeight: 378, idealHeight: 400)
        }
    }
}
   
//Preview for the ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
