
import SwiftUI

//Main view for the Seahorse game
struct SeahorseGameView: View {
    //State variables for positions of various elements
    @State private var obstaclePosition = [CGPoint(x: 1000, y: 300)]
    @State private var seahorsePosition = CGPoint(x: 0, y: 0)
    @State private var starPosition = CGPoint(x: -100, y: 300)
    @State private var bubblePosition = CGPoint(x: -100, y: 300)
    @State private var backgroundOffSet: CGFloat = 0
    
    //State variables for game conditions
    @State private var collisionDetected = false
    @State private var isGameStarted = false
    @State private var isStarActivated = false
    @State private var isBubbleActive = false
    
    //State variables for durations of power-ups
    @State private var bubbleDuration: TimeInterval = 10.0
    @State private var starDuration: TimeInterval = 7.0
    
    //State variables for scoring
    @State private var score = 0
    @State private var highestScore = 0
    @State private var scoreMultiplier = 1
    
    // State variables for speeds of elements
    @State private var obstacleSpeed: Double = 0.1
    @State private var starSpeed: Double = 0.1
    @State private var bubbleSpeed: Double = 0.1

    // State variables for thresholds to spawn power-ups
    @State private var nextStarScoreThreshold = 200
    @State private var nextBubbleScoreThreshold = 350
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
                Image("underWater")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.backgroundOffSet, y: 0)
                
                Image("underWater")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: self.backgroundOffSet + geometry.size.width, y: 0)
                
                //Seahorse view
                seahorseView(horsePosition: $seahorsePosition)
                    .position(x: geometry.size.width / 3, y: geometry.size.height - 100)
                
                // Obstacles and power-ups
                if isGameStarted && !collisionDetected {
                    ForEach(obstaclePosition.indices, id: \.self) { index in
                        JellyfishView()
                            .position(self.obstaclePosition[index])
                            .onReceive(self.timer) { _ in
                                self.obstacleMove(index: index)
                                self.checkCollision(geometry: geometry)
                            }
                    }
                    .onReceive(self.timer) { _ in
                        self.score += 1 * self.scoreMultiplier
                        self.spawnStar()
                        self.spawnShield()
                    }
                    
                    if starPosition.x >= 0 {
                        StarView()
                            .position(starPosition)
                            .onTapGesture {
                                starPosition = CGPoint(x: -100, y: 300)
                            }
                            .onReceive(self.timer) { _ in
                                self.starMove()
                                self.checkCollision(geometry: geometry)
                            }
                    }
                    
                    if bubblePosition.x >= 0 && !isBubbleActive {
                        bubbleView()
                            .position(bubblePosition)
                            .onTapGesture {
                                bubblePosition = CGPoint(x: -100, y: 300)
                            }
                            .onReceive(self.timer) { _ in
                                self.shieldMove()
                                self.checkCollision(geometry: geometry)
                            }
                    }
                }
                
                // Game over view
                if collisionDetected && lives <= 0{
                    VStack {
                        Text("GAME OVER")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .bold()
                        Button(action: {
                            self.resetGame()
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
                    
                    if isBubbleActive {
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
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("BACK")
                            .padding(10)
                            .font(.title3)
                            .foregroundColor(.white)
                            .background(Color.cyan)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .position(x: geometry.size.width / 8, y: geometry.size.height / 10)
                    
                    VStack {
                        HStack {
                            Button("EASY") {
                                selectedDifficulty = .easy
                                setDifficultyParameters()
                            }
                            .padding()
                            .background(selectedDifficulty == .easy ? Color.green : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button("HARD") {
                                selectedDifficulty = .hard
                                setDifficultyParameters()
                            }
                            .padding()
                            .background(selectedDifficulty == .hard ? Color.red : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                        }
                        .buttonStyle(PlainButtonStyle()) //add or not?
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                    }
                    
                    // Sound control button
                    Button(action: {
                        self.toggleSound()
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
                self.setDifficultyParameters()
                self.startBackGroundAnimation(geometry: geometry)
                SoundManager.shared.playBubblesSound()
            }
            .onDisappear() {
                SoundManager.shared.stopBubblesSound()
            }
            .onReceive(Keyboard.shared.$keyEvent) { event in
                if event == .spacebarKeyDown {
                    self.isGameStarted = true
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
            bubbleDuration = 10.0
            lives = 3
        case .hard:
            obstacleSpeed = 0.5
            starDuration = 3.0
            bubbleDuration = 5.0
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
    
    // Move the obstacle
    func obstacleMove(index: Int) {
        if obstaclePosition[index].x > -100 {
            withAnimation {
                obstaclePosition[index].x -= CGFloat(obstacleSpeed * 100)
            }
            if score >= 200 && score % 200 == 0 {
                obstacleSpeed += 0.1
            }
        } else {
            obstaclePosition[index] = CGPoint(x: 1000, y: 300)
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
            starPosition = CGPoint(x: -100, y: 300)
        }
    }
    
    // Move the shield power-up
    func shieldMove() {
        if bubblePosition.x >= 0 {
            withAnimation {
                bubblePosition.x -= CGFloat(bubbleSpeed * 100)
            }
            if score % 200 == 0 {
                bubbleSpeed += 0.1
            }
        } else {
            bubblePosition = CGPoint(x: -100, y: 300)
        }
    }
    
    // Check for collisions
    func checkCollision(geometry: GeometryProxy) {
        let horseFrame = CGRect(x: geometry.size.width / 3 + seahorsePosition.x, y: geometry.size.height - 70 + seahorsePosition.y, width: 50, height: 50)
        
        for obstacle in obstaclePosition {
            let obstacleFrame = CGRect(x: obstacle.x, y: obstacle.y, width: 50, height: 50)
            if horseFrame.intersects(obstacleFrame) {
                if !isBubbleActive && !collisionCooldown {
                    loseLives()
                    startCollisionCooldown()
                    SoundManager.shared.playEffectSound(sound: .electricity)
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
            if !isStarActivated {
                activateStar()
                starPosition = CGPoint(x: -100, y: 300)
                SoundManager.shared.playEffectSound(sound: .star)
            }
        }

        let shieldFrame = CGRect(x: bubblePosition.x, y: bubblePosition.y, width: 50, height: 50)
        if horseFrame.intersects(shieldFrame) {
            if !isBubbleActive {
                activateShield()
                bubblePosition = CGPoint(x: -100, y: 300)
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
        isBubbleActive = true
        bubblePosition = CGPoint(x: -100, y: 300)
        DispatchQueue.main.asyncAfter(deadline: .now() + bubbleDuration) {
            isBubbleActive = false
            bubblePosition = CGPoint(x: -100, y: 300)
            print("Shield deactivated")
        }
    }
    
    // Pause the game
    func pause() {
        timer.upstream.connect().cancel()
    }
    
    // Spawn star power-up
    func spawnStar() {
        if score >= nextStarScoreThreshold {
           self.starPosition = CGPoint(x: 1000, y: 300)
           nextStarScoreThreshold += 200
       }
    }

    // Spawn shield power-up
    func spawnShield() {
        if score >= nextBubbleScoreThreshold {
            self.bubblePosition = CGPoint(x: 1000, y: 300)
            nextBubbleScoreThreshold += 350
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
        SoundManager.shared.stopBubblesSound()
        SoundManager.shared.playGameOverSound()
    }
    
    // Toggle sound on or off
    func toggleSound() {
        isSoundOn.toggle()
        SoundManager.shared.toggleBubbleSound()
    }
    
    //Reset the game
    func resetGame() {
        self.isGameStarted = false
        self.collisionDetected = false
        self.isStarActivated = false
        self.isBubbleActive = false
        self.seahorsePosition = CGPoint(x: 0, y: 0)
        self.obstaclePosition = [CGPoint(x: 1000, y: 300)]
        self.starPosition = CGPoint(x: -100, y: 300)
        self.bubblePosition = CGPoint(x: -100, y: 300)
        self.scoreMultiplier = 1
        self.obstacleSpeed = 0.1
        self.starSpeed = 0.1
        self.bubbleSpeed = 0.1
        self.starDuration = 7.0
        self.bubbleDuration = 10.0
        self.nextStarScoreThreshold = 200
        self.nextBubbleScoreThreshold = 350
        self.highestScore = max(self.score, self.highestScore)
        self.saveHighestScore()
        self.score = 0
        self.setDifficultyParameters()
        self.lives = selectedDifficulty == .easy ? 3 : 1
        SoundManager.shared.stopGameOverSound()
        SoundManager.shared.playBubblesSound()
    }
}

//Preview for the SeahorseGameView
struct SeahorseGameView_Preview: PreviewProvider {
    static var previews: some View {
        SeahorseGameView()
    }
}

