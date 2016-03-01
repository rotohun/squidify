//
//  Player.swift
//  spotify-clone
//
//  Created by ronald hunter on 2/26/16.
//  Copyright © 2016 ronald hunter. All rights reserved.
//

import Foundation
import MediaPlayer

class Player{
    
    var avPlayer: AVPlayer!
    
    init(){
        avPlayer = AVPlayer()
    }
    
    
    
    func playStream (fileUrl: String){
        
        // Url holds the parameter
        let url = NSURL(string: fileUrl)
        
        
        avPlayer = AVPlayer(URL: url!)
        avPlayer.play()
        
        
        
        setPlayingScreen(fileUrl)
        
        print("Playing stream")
    }
    
    
    // Play Button
    
    func playAudio(){
        // Check if the play is paused or stopped
        if (avPlayer.rate == 0 && avPlayer.error == nil){
            
            //Plays the song
            avPlayer.play()
            
            
            
        }
    }// End of function
    
    
    
    
    
    
    // Pause Button
    
    func pausedAudio(){
        // Check if the play is playing or if there is an error
        if (avPlayer.rate > 0 && avPlayer.error == nil){
            
            
            // Pauses the song
            avPlayer.pause()
            
            
        }
    }// End of function

    // To set the playing screen of the app, When someone accesses it from the lock screen they can then see the name and everything.
    
    func setPlayingScreen(fileUrl: String){
        
        // urlArray creats an array from the parameter string and holds it.
        
        let urlArray = fileUrl.characters.split{$0 == "/"}.map(String.init)
        
        // name variable holds the last part of the array
        let name = urlArray[urlArray.endIndex-1]
        
        print(name)
        
        // songInfo give the name and artist of the track.
        
        let songInfo = [
        
            MPMediaItemPropertyAlbumTitle: name,
            MPMediaItemPropertyArtist: "Kanye"
        
        
        ]
        
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
        
    }// End of the function
    
    
}// End of Class
