

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var Outlet1: UILabel!
    
    var soundPlayer: AVAudioPlayer?
    var elapsedTime: TimeInterval = 0
    
    @IBOutlet weak var p1Icon: UIImageView!
    @IBOutlet weak var p2Icon: UIImageView!
    
    // Switch for multi-player or single player
    @IBOutlet weak var multiPlayerSwitch: UISwitch!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var gridButtons: [UIButton]!
    
    @IBOutlet weak var p1ScoreLabel: UILabel!
    @IBOutlet weak var p2ScoreLabel: UILabel!
    
    @IBOutlet weak var winnerLabel: UILabel!
    
    // Declaring symbols for the game
    var img1 = UIImage(named: "cross")
    var img2 = UIImage(named: "nought")
    
    // Default 9 buttons of the grid
    var grid = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]

    var currentPlayer : Int = 1
    
    // Game history
    @IBOutlet weak var historyTextView: UITextView!
    
    // Current score
    var p1Score : Int = 0
    var p2Score : Int = 0
    
    
    // Start game function
    func start(){
        grid = [[0, 0, 0] , [0, 0, 0], [0, 0, 0]]
        
        // All buttons are empty when the game starts
        for button in gridButtons{
            button.setImage(nil, for: .normal)
        }
        
        currentPlayer = 1
    }
    
    // Choosing cross symbol to play as player 1
    @IBAction func btnX(_ sender: UIButton) {
        currentPlayer = 1
    }
    
    // Choosing nought symbol to play as player 2
    @IBAction func btnO(_ sender: UIButton) {
        currentPlayer = 2
    }
    
    // When pressing one of the buttons to play the game
    @IBAction func cellSelected(_ sender: UIButton) {
        
        let rowIndex = sender.tag / 3
        let colIndex = sender.tag % 3
        
        if grid[rowIndex][colIndex] != 0 {return}
        
        // Get to know which player press on which cell
        grid[rowIndex][colIndex] = currentPlayer
        
        // Set cross symbol for player 1
        if currentPlayer == 1 {
            sender.setImage(img1, for: .normal)
        }
        // Set nought symbol for player 2
        else if currentPlayer == 2 {
            sender.setImage(img2, for: .normal)
        }
        
        // Get result from winlose function to variable winner
        let winner = winlose()
        
        // Check who is the winner
        switch winner {
        case 0:
            currentPlayer = (currentPlayer % 2) + 1
        case 1:
            // Winner label for player 1
            winnerLabel.text = "Player 1 is the winner!"
            
            // Alert message for player 1
            alertWinner(playerName: "Player 1")
            
            // Player 1's current score
            p1Score += 1
            
            // Plyaer 1 score label
            p1ScoreLabel.text = "Score: \(p1Score)"
            
            // Game history for player 1
            historyTextView.insertText("\nPlayer 1's result: \(p1Score)")
        case 2:
            winnerLabel.text = "Player 2 is the winner!"
            alertWinner(playerName: "Player 2")
            
            p2Score += 1
            p2ScoreLabel.text = "Score: \(p2Score)"
            historyTextView.insertText("\nPlayer 2's result: \(p2Score)")
        default:
            
            winnerLabel.text = "\(winner) is not matched"
        }
        
        // AI mode to check if single player mode is enabled
        if multiPlayerSwitch.isOn == false{
            let (cellIndex, gridRowIndex, gridColIndex, p2Win) = whereToPlay()
            
            // Set symbol for player 2
            gridButtons[cellIndex].setImage(img2, for: .normal)
            
            // Set the grid to value 2
            grid[gridRowIndex][gridColIndex] = 2
            
            // Show alert if player 2 wins
            if p2Win == true {
                alertWinner(playerName: "Player 2")
            }
            
            // Otherwise, player 1 can now play the game
            currentPlayer = 1
        }
    }
    
    // Check if player 1 or 2 wins the match
    // 1 is player 1 wins, 2 is player 2 wins or 0 is no players win at all
    func winlose() -> Int {
        
        // First row
        if grid[0][0] != 0 && grid[0][0] == grid[0][1] && grid[0][1] == grid[0][2] {
            return grid[0][0]
        }
        
        // Second row
        if grid[1][0] != 0 && grid[1][0] == grid[1][1] && grid[1][1] == grid[1][2] {
            return grid[1][0]
        }
        
        // Third row
        if grid[2][0] != 0 && grid[2][0] == grid[2][1] && grid[2][1] == grid[2][2] {
            return grid[2][0]
        }
        
        // First column
        if grid[0][0] != 0 && grid[0][0] == grid[1][0] && grid[1][0] == grid[2][0] {
            return grid[0][0]
        }
        
        // Second column
        if grid[0][1] != 0 && grid[0][1] == grid[1][1] && grid[1][1] == grid[2][1] {
            return grid[0][1]
        }
        
        // Third column
        if grid[0][2] != 0 && grid[0][2] == grid[1][2] && grid[1][2] == grid[2][2] {
            return grid[2][2]
        }
        
        // Top right to bottom left
        if grid[0][2] != 0 && grid[0][2] == grid [1][1] && grid[1][1] == grid[2][0] {
            return grid[2][0]
        }
        
        // Top left to bottom right
        if grid[0][0] != 0 && grid[0][0] == grid[1][1] && grid[1][1] == grid[2][2]{
            return grid[2][2]
        }
        return 0
    }
    
    
    // Alert message shows who won the game
    func alertWinner(playerName : String){
        let alertController = UIAlertController(title: "Alert", message: "\(playerName) Won!", preferredStyle: .alert)
        
        // When there is a winner, the grid will start as new game
        let okAction = UIAlertAction(title: "Ok", style: .default){
            (action) -> Void in self.start()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // When single player mode is on
    func whereToPlay() -> (Int, Int, Int, Bool){
        var index = -1
        var draw = 0
        var gridRowIndex = 0
        var gridColIndex = 0
        
        for row in 0 ... 2 {
            for col in 0 ... 2 {
                index = index + 1
                
                // Check when none of the players have played the game
                if grid[row][col] == 0
                {
                    
                    // Set the cell to 2
                    grid[row][col] = 2
                    
                    // Get the result from winlose function
                    var i = winlose()
                    
                    // If the value is actually 2, player 2 wins the game
                    if i == 2
                    {
                        return (index, row, col, true)
                    }
                    
                    // Check if the winner is player 1
                    grid[row][col] = 1
                    i = winlose()
                    
                    // If so, this means player 2 did not win the match by returning the flag as false
                    if i == 1
                    {
                        return (index, row, col, false)
                    }
                    
                    // When no one wins and other cells are available, player can still play the game
                    draw = index
                    gridRowIndex = row
                    gridColIndex = col
                    
                    // Set the cell to empty
                    grid[row][col] = 0
                }
            }
        }
        
        // No winner then return as false
        return (draw, gridRowIndex, gridColIndex, false)
    }
    
    // Reset game button
    @IBAction func btnReset(_ sender: UIButton) {
        start()
    }
    
    // Play or resume music button
    @IBAction func btnPlay(_ sender: UIButton) {
        // play and resume
        if soundPlayer != nil{
            soundPlayer!.currentTime = elapsedTime
            soundPlayer!.play()
        }
    }
    
    // Pause music button
    @IBAction func btnPause(_ sender: UIButton) {
        if soundPlayer != nil{
            elapsedTime = soundPlayer!.currentTime
            soundPlayer!.pause()
        }
    }
    
    // Stop music button
    @IBAction func btnStop(_ sender: UIButton) {
        if soundPlayer != nil{
            soundPlayer!.stop()
            elapsedTime = 0
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        Outlet1.text = name
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* “Choosing Images with UIImagePickerController in Swift,” Coding Explorer Blog, 27-Apr-2015. [Online]. Available: http://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/. [Accessed: 04-Apr-2017]. */
        imagePicker.delegate = self
        
        // URL of the Song name and type
        let path = Bundle.main.path(forResource: "Spring-In-My-Step", ofType: "mp3")
        
        let url = URL(fileURLWithPath: path!)
        
        do {
            // set up the player by loading the sound file
            try soundPlayer = AVAudioPlayer(contentsOf: url)
        }
            // catch the error if playback fails
        catch { print("file not availalbe")}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

