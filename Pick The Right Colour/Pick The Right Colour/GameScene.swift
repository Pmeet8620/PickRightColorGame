//
//  GameScene.swift
//  Pick The Right Colour
//
//  Created by user198565 on 8/1/21.
//

import SpriteKit


import GameplayKit
var square0 = SKSpriteNode()
var square1 = SKSpriteNode()
var square2 = SKSpriteNode()
var square3 = SKSpriteNode()


var lblMain = SKLabelNode()
var lblScore = SKLabelNode()
var lblTimer = SKLabelNode()

var squarePositionOffset : CGFloat = 120

var squareSize = CGSize(width: 150, height: 150)

var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)

var offBlackColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)

var color0 = UIColor.orange
var color1 = UIColor.green
var color2 = UIColor.purple
var color3 = UIColor.blue

var incorrectColor0 = UIColor.yellow
var incorrectColor1 = UIColor.lightGray
var incorrectColor2 = UIColor.red



var colorArrayString = ["Orange", "Green", "Purple", "Blue"]
var colorArrayChoice = 0

var colorChoice = 0

var correctSquare = 0

var touchLocation = CGPoint()
var touchedNode = SKNode()

var score = 0
var isAlive = true

var countDownTimerVar = 12

class GameScene: SKScene {
    override func didMove(to view: SKView) {
       

        resetGameVariables()

        spawnLblMain()
        spawnLblScore()
        spawnLblTimer()
        
        countDownTimer()
    
        
        randomizeColors()
            }
    func resetGameVariables(){
        score = 0

        isAlive = true

        countDownTimerVar = 12
        
        spawnSquare0()
        spawnSquare1()
        spawnSquare2()
        spawnSquare3()
    }
    func randomizeColors(){
        colorArrayChoice = Int(arc4random_uniform(4))
        colorChoice = Int(arc4random_uniform(4))
        correctSquare = Int(arc4random_uniform(4))
        
        printColorCorrectSquare()
        printColors()
        
    }
    
    func printColors(){
        
        if colorChoice == 0{
            lblMain.fontColor = color0
        }
        if colorChoice == 1{
            lblMain.fontColor = color1
        }
        if colorChoice == 2{
            lblMain.fontColor = color2
        }
        if colorChoice == 3{
            lblMain.fontColor = color3
        }
        lblMain.text = "\(colorArrayString[colorArrayChoice])"
        
    }
    
    func printColorCorrectSquare(){
        let tempColor = [color0, color1, color2, color3]
        
        if colorChoice == 0{
            square0.color = tempColor[colorChoice]
            square1.color = incorrectColor0
            square2.color = incorrectColor1
            square3.color = incorrectColor2
            
            square0.name = "correct"
            square0.name = "incorrect0"
            square0.name = "incorrect1"
            square0.name = "incorrect2"
        }
        if colorChoice == 1{
            square0.color = incorrectColor1
            square1.color = tempColor[colorChoice]
            square2.color = incorrectColor2
            square3.color = incorrectColor0
            
             square0.name = "incorrect0"
            square0.name = "correct"
            square0.name = "incorrect1"
            square0.name = "incorrect2"
        }
        if colorChoice == 2{
            square0.color = incorrectColor1
            square1.color = incorrectColor0
            square2.color = tempColor[colorChoice]
            square3.color = incorrectColor2
            
            square0.name = "incorrect0"
            square0.name = "incorrect1"
            square0.name = "correct"
            square0.name = "incorrect2"
            
        }
        if colorChoice == 3{
            square0.color = incorrectColor1
            square1.color = incorrectColor0
            square2.color = incorrectColor2
            square3.color = tempColor[colorChoice]
            
            square0.name = "incorrect0"
            square0.name = "incorrect1"
            square0.name = "incorrect2"
            square0.name = "correct"
            
        }
    }
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            
        
        }
        
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
        for touch in touches {
            touchLocation = touch.location(in: self)
            
            if touchedNode.name != "correct" {
                gameOverLogic()
                isAlive = false
            }
            touchedNode = atPoint(touchLocation)
            if touchedNode.name == "correct"{
                addToScore()
                randomizeColors()
        }
            
        }
    }
    
    func addToScore(){
        score = score + 1
        updateScore()
    }
    func updateScore(){
        lblScore.text = "Score: \(score)"

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    func spawnSquare0(){
        square0 = SKSpriteNode(color: offWhiteColor, size: squareSize)
        square0.position = CGPoint(x: self.frame.midX - squarePositionOffset, y: self.frame.midY + squarePositionOffset)
        
        self.addChild(square0)
    }
    func spawnSquare1(){
        square1 = SKSpriteNode(color: offWhiteColor, size: squareSize)
        square1.position = CGPoint(x: self.frame.midX + squarePositionOffset, y: self.frame.midX + squarePositionOffset)
        
        self.addChild(square1)
    }
    func spawnSquare2(){
        square2 = SKSpriteNode(color: offWhiteColor, size: squareSize)
        square2.position = CGPoint(x: self.frame.midX - squarePositionOffset, y: self.frame.midX - squarePositionOffset)
        
        self.addChild(square2)
    }
    func spawnSquare3(){
        square3 = SKSpriteNode(color: offWhiteColor, size: squareSize)
        square3.position = CGPoint(x: self.frame.midX + squarePositionOffset, y: self.frame.midX - squarePositionOffset)
        
        self.addChild(square3)
    }
    
    func spawnLblMain(){
        lblMain = SKLabelNode(fontNamed: "Futura")
        lblMain.fontColor = offWhiteColor
        lblMain.fontSize = 100
        lblMain.position = CGPoint(x: self.frame.midX, y:self.frame.midY + 260)
        
        lblMain.text = "Start!"
        self.addChild(lblMain)
    }
    func spawnLblScore(){
        lblScore = SKLabelNode(fontNamed: "Futura")
        lblScore.fontColor = offWhiteColor
        lblScore.fontSize = 50
        lblScore.position = CGPoint(x: self.frame.midX, y:self.frame.midY - 360)
        
        lblScore.text = "Score"
        self.addChild(lblScore)
        
    }
    func spawnLblTimer(){
        lblTimer = SKLabelNode(fontNamed: "Futura")
        lblTimer.fontColor = offWhiteColor
        lblTimer.fontSize = 80
        lblTimer.position = CGPoint(x: self.frame.midX, y:self.frame.midY - 320)
        
        lblTimer.text = "10"
        self.addChild(lblTimer)
    }
    
    func countDownTimer(){
        let wait = SKAction.wait(forDuration: 1.0)
        let countDown = SKAction.run{
            if isAlive == true{
            countDownTimerVar = countDownTimerVar - 1
            }
            
            if countDownTimerVar <= 10 && isAlive == true{
                lblTimer.text = "\(countDownTimerVar)"
            }
            if countDownTimerVar <= 0{
                lblTimer.text = "0"
            }
        }
        
        let sequence = SKAction.sequence([wait, countDown])
        self.run(SKAction.repeat(sequence, count: countDownTimerVar))
    }
    
    func gameOverLogic(){
        lblMain.fontColor = offWhiteColor
        lblMain.text = "Game Over"
        
        lblTimer.text = "Try Again"
        
        square0.removeFromParent()
        square1.removeFromParent()
        square2.removeFromParent()
        square3.removeFromParent()
        resetTheGame()
        
    }
    func resetTheGame(){
        let wait = SKAction.wait(forDuration: 4.0)
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.doorway(withDuration: 1.0)
        
        gameScene.scaleMode = SKSceneScaleMode.aspectFill
        
        let changeScene = SKAction.run{
            self.scene?.view?.presentScene(gameScene, transition: transition)
        }
        let sequence = SKAction.sequence([wait, changeScene])
        self.run(SKAction.repeat(sequence, count: 1))
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
