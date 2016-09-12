//
//  AppDelegate.swift
//  PushAndLocalNotifications
//
//  Created by Thales Toniolo on 10/18/14.
//  Copyright (c) 2014 FIAP. All rights reserved.
//
import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

	//MARK: - Private Declarations
	var window: UIWindow?
	var deviceToken:String = ""

	//MARK: - Life Cycle
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Registra o Push Notification e os recursos que ele vai utilizar (badge, som e alerta)
		UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil))
		
		// Dica: Para testar o disparo de push, veja o site http://urbanairship.com

		return true
	}

	//MARK: - Background Delegates
	func applicationWillResignActive(application: UIApplication) {
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Registra local notification
		let localNotification:UILocalNotification = UILocalNotification()
		localNotification.fireDate = NSDate(timeIntervalSinceNow: 3) // Tempo em segundos a partir de agora
		localNotification.alertBody = "Ola Local Notification!"
		localNotification.applicationIconBadgeNumber = 1
		localNotification.soundName = UILocalNotificationDefaultSoundName
		localNotification.alertAction = "Minha notificacao..."
		localNotification.repeatInterval = NSCalendarUnit.Day
		localNotification.userInfo = ["TipoLocalDisparado":"1"]
		UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Local notification - Remove o badge e a notificacao
		let localNotification:UILocalNotification = UILocalNotification()
		localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
		localNotification.applicationIconBadgeNumber = -1 // As badges nao trabalham de forma indexada, se voce adicionou 1 remove 1, se adicionar 5 deve remover 5 e nao defini-la como 0
		localNotification.repeatInterval = NSCalendarUnit()
		UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
		UIApplication.sharedApplication().cancelAllLocalNotifications()
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	//MARK: - Local Notification Delegates
	func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
		if let tipo = notification.userInfo?["TipoLocalDisparado"] {
			print("Local Notification recebida do tipo: \(tipo)")
		}
	}

	//MARK: - Push Notification Delegates
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		// Token a ser registrado no servidor para disparo do push
		self.deviceToken = deviceToken.description.stringByReplacingOccurrencesOfString("<", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(">", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

		// Token para o envio do push
		print("Push Device Token = \(self.deviceToken)")
	}

	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		print("Falha ao registrar o push: \(error.localizedDescription)")
	}

	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		print("Push Notification recebida")
	}
}
