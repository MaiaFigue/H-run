import SwiftUI

// Enum for game difficulty
enum Difficulty {
    case easy, hard;
}

//Main view for the HorseGameView game
struct HorseGameView: View {
    //State variables for positions of various elements
    @State private var obstaclePosition = [CGPoint(x: 1000, y: 300)]
    @State private var horsePosition = CGPoint(x: 0, y: 0)
    @State private var starPosition = CGPoint(x: -100, y: 300)
    @State private var shieldPosition = CGPoint(x: -100, y: 300)
    @State private var backgroundOffSet: CGFloat = 0
    
    //State variables for game conditions
    @State private var collisionDetected = false
    @State private var isGameStarted = false
    @State private var isStarActivated = false
    @State private var isShieldActive = false
    
    //State variables for durations of power-ups
    @State private var shieldDuration: TimeInterval = 10.0
    @State private var starDuration: TimeInterval = 7.0
    
    //State variables for scoring
    @State private var score = 0
    @State private var highestScore = 0
    @State private var scoreMultiplier = 1
    
    // State variables for speeds of elements
    @State private var obstacleSpeed: Double = 0.1
    @State private var starSpeed: Double = 0.1
    @State private var shieldSpeed: Double = 0.1

    // State variables for thresholds to spawn power-ups
    @State private var nextStarScoreThreshold = 200
    @State private var nextShieldScoreThreshold = 350
    @State private var showStar = false
    
    // Environment variable for presentation mode
    @Environment (\.presentationMode) var presentationMode
    
    // State variables for game difficulty and lives
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var lives: Int = 3
    @State private var isGameOver = false
    @State private var collisionCooldown = false
    
    // State variable for sound control
    @State private var isSoundOn = true
    
    // Timer for game updates
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {

                // Background images
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.backgroundOffSet, y: 0)
                
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.backgroundOffSet + geometry.size.width, y: 0)
                
                //Horse view
                HorseView(horsePosition: $horsePosition)
                    .position(x: geometry.size.width / 3, y: geometry.size.height - 100)
                
                // Obstacles and power-ups
                if isGameStarted && !collisionDetected {
                    ForEach(obstaclePosition.indices, id: \.self) { index in
                        ObstacleView()
                            .position(self.obstaclePosition[index])
                            .onReceive(self.timer) { _ in
                                self.obstacleMove(index: index) // Move obstacles and check for collisions
                                self.checkCollision(geometry: geometry)
                            }
                    }
                    .onReceive(self.timer) { _ in
                        self.score += 1 * self.scoreMultiplier  // Increase score
                        self.spawnStar()    // Spawn star power-up based on score
                        self.spawnShield()  // Spawn shield power-up based on score
                    }
                    
                    // Star power-up
                    if starPosition.x >= 0 {
                        StarView()
                            .position(starPosition)
                            .onTapGesture {
                                starPosition = CGPoint(x: -100, y: 300) // Hide star when tapped (collides)
                            }
                            .onReceive(self.timer) { _ in
                                self.starMove() // Move star and check for collisions
                                self.checkCollision(geometry: geometry)
                            }
                    }
                    
                    // Shield power-up
                    if shieldPosition.x >= 0 && !isShieldActive {
                        ShieldView()
                            .position(shieldPosition)
                            .onTapGesture {
                                shieldPosition = CGPoint(x: -100, y: 300)   // Hide shield when tapped (collides)
                            }
                            .onReceive(self.timer) { _ in
                                self.shieldMove()   // Move shield and check for collisions
                                self.checkCollision(geometry: geometry)
                            }
                    }
                }

                // Game over view with restart button
                if collisionDetected && lives <= 0{
                    VStack {
                        Text("GAME OVER")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .bold()
                        Button(action: {
                            self.resetGame()    // Restart game
                        }) {
                            Text("RESTART")
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                // Display scores
                HStack {
                    Text("HIGHEST SCORE: \(self.highestScore)")
                        .foregroundColor(.white)
                    
                    Text("SCORE: \(self.score)")
                        .foregroundColor(.white) 
                }
                .position(x: geometry.size.width - 120, y: geometry.size.height / 10)
                
                // Display lives
                HeartsView(lives: self.lives)
                    .position(x: geometry.size.width - 120, y: geometry.size.height / 10)
                    .padding()
                
                // Display active power-ups
                VStack {
                    if isStarActivated {
                        Text("DOUBLE SCORE!")
                            .font(.title)
                            .foregroundStyle(Color.white)
                            .bold()
                    }
                    
                    if isShieldActive {
                        Text("SHIELD ACTIVE!")
                            .font(.title)
                            .foregroundStyle(Color.white)
                            .bold()
                    }
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 5)
                
                // Display game controls if the game has not started
                if !isGameStarted {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Go back to previous screen
                    }) {
                        Text("BACK")
                            .padding(10)
                            .font(.title3)
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .position(x: geometry.size.width / 15, y: geometry.size.height / 10)
                    
                    VStack {
                        HStack {
                            Button("EASY") {
                                selectedDifficulty = .easy
                                setDifficultyParameters()   // Set parameters for easy difficulty
                            }
                            .padding()
                            .background(selectedDifficulty == .easy ? Color.green : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button("HARD") {
                                selectedDifficulty = .hard
                                setDifficultyParameters()   // Set parameters for hard difficulty
                            }
                            .padding()
                            .background(selectedDifficulty == .hard ? Color.red : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                    }
                    
                    // Sound control button
                    Button(action: {
                        self.toggleSound()  // Toggle sound on/off
                    }) {
                        Image(systemName: isSoundOn ? "speaker.2.fill" : "speaker.slash.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .background(Color.clear)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .position(x: geometry.size.width - 40, y: geometry.size.height - 30)

                }
            }
            .onAppear() {
                self.setDifficultyParameters()  // Set initial game parameters
                self.startBackGroundAnimation(geometry: geometry)   // Start background animation
                SoundManager.shared.playRunningSound()  // Play background sound
            }
            .onDisappear() {
                SoundManager.shared.stopRunningSound()  // Stop background sound when view disappears
            }
            .onReceive(Keyboard.shared.$keyEvent) { event in
                if event == .spacebarKeyDown {
                    self.isGameStarted = true   // Start game when spacebar is pressed
                }
            }
        }
    }
    
    // Start background animation
    private func startBackGroundAnimation(geometry: GeometryProxy) {
        let animation = Animation.linear(duration: 5).repeatForever(autoreverses: false)
        
        withAnimation(animation) {
            self.backgroundOffSet = -geometry.size.width
        }
    }
    
    // Set game parameters based on selected difficulty
    func setDifficultyParameters() {
        switch selectedDifficulty {
        case .easy:
            obstacleSpeed = 0.3
            starDuration = 7.0
            shieldDuration = 10.0
            lives = 3
        case .hard:
            obstacleSpeed = 0.5
            starDuration = 3.0
            shieldDuration = 5.0
            lives = 1
        }
    }
    
    // Save the highest score to user defaults
    func saveHighestScore() {
        UserDefaults.standard.set(self.highestScore, forKey: "highestScore")
    }
    
    // Load the highest score from user defaults
    func loadHighestScore() {
        if let saveHighestScore = UserDefaults.standard.value(forKey: "highestScore") as? Int {
            self.highestScore = saveHighestScore
        } else {
            self.highestScore = 0
        }
    }
    
    // Move obstacles and check for collisions
    func obstacleMove(index: Int) {
        // Move obstacle and check if it goes off screen
        if obstaclePosition[index].x > -100 {
            withAnimation {
                obstaclePosition[index].x -= CGFloat(obstacleSpeed * 100)
            }
            if score >= 200 && score % 200 == 0 {
                obstacleSpeed += 0.1
            }
        } else {
            obstaclePosition[index] = CGPoint(x: 1000, y: 300)  // Reset position
        }
    }
    
    // Move the star power-up
    func starMove() {
        if starPosition.x >= 0 {
            withAnimation {
                starPosition.x -= CGFloat(starSpeed * 100)
            }
            if score % 200 == 0 {
                starSpeed += 0.1
            }
        } else {
            starPosition = CGPoint(x: -100, y: 300) // Reset position
        }
    }
    
    // Move the shield power-up
    func shieldMove() {
        if shieldPosition.x >= 0 {
            withAnimation {
                shieldPosition.x -= CGFloat(shieldSpeed * 100)
            }
            if score % 200 == 0 {
                shieldSpeed += 0.1
            }
        } else {
            shieldPosition = CGPoint(x: -100, y: 300)   // Reset position
        }
    }
    
    // Check for collisions between the horse and obstacles/power-ups
    func checkCollision(geometry: GeometryProxy) {
        let horseFrame = CGRect(x: geometry.size.width / 3 + horsePosition.x, y: geometry.size.height - 70 + horsePosition.y, width: 50, height: 50)
        
        for obstacle in obstaclePosition {
            let obstacleFrame = CGRect(x: obstacle.x, y: obstacle.y, width: 50, height: 50)
            if horseFrame.intersects(obstacleFrame) {
                if !isShieldActive && !collisionCooldown {
                    loseLives()
                    startCollisionCooldown()
                    SoundManager.shared.playEffectSound(sound: .horse)
                    return
                }
            }
        }
        
        func startCollisionCooldown() {
            collisionCooldown = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                collisionCooldown = false
            }
        }
        
        let starFrame = CGRect(x: starPosition.x, y: starPosition.y, width: 50, height: 50)
        if horseFrame.intersects(starFrame) {
            activateStar()
            starPosition = CGPoint(x: -100, y: 300)
            SoundManager.shared.playEffectSound(sound: .star)
        }
        
        let shielFrame = CGRect(x: shieldPosition.x, y: shieldPosition.y, width: 50, height: 50)
        if horseFrame.intersects(shielFrame) {
            if !isShieldActive {
                activateShield()
                shieldPosition = CGPoint(x: -100, y: 300)
                SoundManager.shared.playEffectSound(sound: .shield)
            }
        }
    }
    
    // Activate the star power-up
    func activateStar() {
        isStarActivated = true
        scoreMultiplier =  2
        starPosition = CGPoint(x: -100, y: 300)
        DispatchQueue.main.asyncAfter(deadline: .now() + starDuration) {
            isStarActivated = false
            scoreMultiplier = 1
            print("Star deactivated")
        }
    }
    
    // Activate the shield power-up
    func activateShield() {
        isShieldActive = true
        shieldPosition = CGPoint(x: -100, y: 300)
        DispatchQueue.main.asyncAfter(deadline: .now() + shieldDuration) {
            isShieldActive = false
            shieldPosition = CGPoint(x: -100, y: 300)
            print("Shield deactivated")
        }
    }

    // Pause the game
    func pause() {
        timer.upstream.connect().cancel()
    }
    
    // Spawn star power-up based on score thresholds
    func spawnStar() {
        if score >= nextStarScoreThreshold {
           self.starPosition = CGPoint(x: 1000, y: 300)
           nextStarScoreThreshold += 200
       }
    }
    
    // Spawn shield power-up based on score thresholds
    func spawnShield() {
        if score >= nextShieldScoreThreshold {
            self.shieldPosition = CGPoint(x: 1000, y: 300)
            nextShieldScoreThreshold += 350
        }
    }
    
    //Funtion to lose lives
    func loseLives() {
        lives = lives - 1
        
        if (lives <= 0) {
            gameOver()
        }
    }
    
    //Game Over function
    func gameOver() {
        self.collisionDetected = true
        SoundManager.shared.stopRunningSound()
        SoundManager.shared.playGameOverSound()
    }
    
    // Toggle sound on or off
    func toggleSound() {
        isSoundOn.toggle()
        SoundManager.shared.toggleRunningSound()  
    }
    
    // Reset the game to initial state 
    func resetGame() {
        self.isGameStarted = false
        self.collisionDetected = false
        self.isStarActivated = false
        self.isShieldActive = false
        self.horsePosition = CGPoint(x: 0, y: 0)
        self.obstaclePosition = [CGPoint(x: 1000, y: 300)]
        self.starPosition = CGPoint(x: -100, y: 300)
        self.shieldPosition = CGPoint(x: -100, y: 300)
        self.scoreMultiplier = 1
        self.obstacleSpeed = 0.1
        self.starSpeed = 0.1
        self.shieldSpeed = 0.1
        self.starDuration = 7.0
        self.shieldDuration = 10.0
        self.nextStarScoreThreshold = 200
        self.nextShieldScoreThreshold = 350
        self.highestScore = max(self.score, self.highestScore)
        self.saveHighestScore()
        self.score = 0
        self.setDifficultyParameters()
        self.lives = selectedDifficulty == .easy ? 3 : 1
        SoundManager.shared.stopGameOverSound()
        SoundManager.shared.playRunningSound()
    }
}

//Preview for the HorseGameView
struct HorseGameView_Previews : PreviewProvider {
    static var previews: some View {
        HorseGameView()
    }
}
