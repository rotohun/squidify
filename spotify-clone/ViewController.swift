//
//  ViewController.swift
//  spotify-clone
//
//  Created by ronald hunter on 2/26/16.
//  Copyright © 2016 ronald hunter. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    // Initialize the player class
    var player: Player!
    
    // Creates a songs array but empty
    var songs: [Song] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setSession()
        
        
        
        player = Player()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
        
        // Making an observer
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleInterruption", name: AVAudioSessionInterruptionNotification, object: nil)
        
        retrieveSongs()
        
    }
    
    
    // Delegate amd source for tableview
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SongsTableViewCell", forIndexPath: indexPath) as! SongsTableViewCell
        
        cell.mainLabel.text = songs[indexPath.row].cleanName()
        return cell
        
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        player.playStream("Your Api Goes here" + songs[indexPath.row].cleanURL())
        changePlayButton()
    }
    
    // End
    
    //inits the first responder
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // sets the audio session for the app to be controlled using the screen lock controls
    
    func setSession(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch{
            print(error)
        }
    }
    
    
    // Function that is connected to the play pause button
    
    @IBAction func playPauseButtonClick(sender: AnyObject) {
        
        if(player.avPlayer.rate > 0){
            player.pausedAudio()
        }else{
            player.playAudio()
        }
        
        changePlayButton()
        
    }
    
    
    //Changes the button from play to pause
    
    func changePlayButton(){
        if(player.avPlayer.rate > 0){
            playPauseButton.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
        }else{
            playPauseButton.setImage(UIImage(named: "Play"), forState: UIControlState.Normal)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        
        if event!.type == UIEventType.RemoteControl{
            
            if event!.subtype == UIEventSubtype.RemoteControlPause{
                print("pause")
                player.pausedAudio()
                
            }else if event!.subtype == UIEventSubtype.RemoteControlPlay{
                print("Playing")
                player.playAudio()
                
            }
            
        } //end of first if statment
        
        
    }// End Of function
    
    // Handles the interuptions of outside forces that request audio
    
    func handleInterruption(notification: NSNotification){
        player.pausedAudio()
        
        let interruptionTypeAsObject = notification.userInfo![AVAudioSessionInterruptionTypeKey] as! NSNumber
        
        let interruptionType = AVAudioSessionInterruptionType(rawValue: interruptionTypeAsObject.unsignedLongValue)
        
        if let type = interruptionType{
            if type == .Ended{
                player.playAudio()
            }
        }
    }// End of Function
    
    
    func retrieveSongs (){
        
        // Url
        let url = NSURL(string: "You database api goes here")
        
        //Backend Thred
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!){
            (data, response, error) in
            
            
            let retrievedList = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print(retrievedList)
            self.parseSongs(retrievedList!)
        }
        task.resume()
        print("Getting Songs")
    }
    
    
    // Parsing songs
    func parseSongs (data: NSString){
        if (data.containsString("*")){
            let dataArray = (data as String).characters.split{$0 == "*"}.map(String.init)
            
            for item in dataArray {
                let itemData = item.characters.split{$0 == ","}.map(String.init)
                
                let newSong = Song(id: itemData[0], name: itemData[1], numLikes: itemData[2], numPlays: itemData[3])
                
                songs.append(newSong!)
            }// End of first for loop
            
            for s in songs{
                
                print(s.cleanName())
                
            }
            
            dispatch_async(dispatch_get_main_queue()){ [unowned self] in
                
                 self.tableView.reloadData()
                
            }
            
           
            
        }// End of if statment
        
    }// End of function

}


