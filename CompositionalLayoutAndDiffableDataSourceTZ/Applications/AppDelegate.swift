//
//  AppDelegate.swift
//  CompositionalLayoutAndDiffableDataSourceTZ
//
//  Created by Николай Гринько on 06.03.2024.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		let window = UIWindow(frame: UIScreen.main.bounds)
		let mainNavigationController = UINavigationController(rootViewController: ViewController())
		window.rootViewController = mainNavigationController
		window.makeKeyAndVisible()
		
		self.window = window
		
		return true
	}
}
