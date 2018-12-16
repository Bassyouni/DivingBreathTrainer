//
//  AppDelegate.swift
//  DivingBreathTrainer
//
//  Created by MacBook Pro on 11/30/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        let homeVC = HomeVC()
        homeVC.view.backgroundColor = .white
        window?.rootViewController = homeVC
        window?.makeKeyAndVisible()
        
        // this because when have music on , and the app launches the music goes off
        // this is bad UX , leave the choice to the user
        // the fix
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: AVAudioSession.Mode.moviePlayback, options: [.mixWithOthers])
        
        return true
    }
    
}

