//
//  DashBoardVM.swift
//  NYTimesSample
//
//  Created by Ersin Gürsu on 15.02.2019.
//  Copyright © 2019 Ersin Gürsu. All rights reserved.
//

import Foundation
import UIKit

class DashboardVM: NSObject {
    
   var newsLoaded = {() -> () in }
    
    var selectedItem = {(_ item:Result) -> () in }
    
    fileprivate var nyMostPopolarNews: Welcome?{
        didSet{
            filteredNews = nyMostPopolarNews?.results
        }
    }
    
    fileprivate var filteredNews : [Result]?{
        didSet{
            newsLoaded()
        }
    }

    func hasNews()->Bool{
        
        guard let filtered = filteredNews else { return false }
        return filtered.count != 0
    }

    deinit {
        print("DashboardVM deinit")
    }
} 

extension DashboardVM {
    
    func search(_ text : String?){
        
        guard let welcome = nyMostPopolarNews else { return  }
        
        if (text ?? "").isEmpty{
            filteredNews = welcome.results
            return
        }
        
        filteredNews = welcome.results.filter {$0.title.contains(text!)}
    }
    
}

extension DashboardVM {
    
    func loadNews()
    {
        
        Network.instance.request(params: [:], section: "all-sections", dayType: "7") { [weak self] (result : Welcome) in
            self?.nyMostPopolarNews = result
        }
    }
    
}  
