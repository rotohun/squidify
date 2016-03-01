//
//  song.swift
//  spotify-clone
//
//  Created by ronald hunter on 2/26/16.
//  Copyright © 2016 ronald hunter. All rights reserved.
//

import Foundation


class Song {
    
    var id: Int
    var name: String
    var numLikes: Int
    var numPlays: Int
    
    
    init? (id: String, name: String, numLikes: String, numPlays: String){
        
        // Set up conversion for the ID, Number of Likes, Number of Plays
        
        self.id = Int(id)!
        self.name = name
        self.numLikes = Int(numLikes)!
        self.numPlays = Int(numPlays)!
    }
    
    // get the variables from the class
    
    func getId () -> Int{
        return id
    }
    
    func getName () -> String{
        return name
    }
    
    func getNumLikes () -> Int{
        return numLikes
    }
    
    func getNumPlays () -> Int{
        return numPlays
    }
    
    func cleanURL () ->String{
        let clean = name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        return clean!
        
    }
    
    
    func cleanName () ->String{
        let clean = name.stringByReplacingOccurrencesOfString(".mp3", withString: "")
        
        
        return clean
        
        
    }

    
    
}





