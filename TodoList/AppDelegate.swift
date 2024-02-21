//
//  AppDelegate.swift
//  TodoList
//
//  Created by SUCHAN CHANG on 2/14/24.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = Realm.Configuration(schemaVersion: 5) { migration, oldSchemaVersion in
            
            // 0:
            
            // 1: ListModel에 새로운 컬럼 newColumn 추가
            if oldSchemaVersion < 1 {
                print("0 -> 1")
            }
            
            // 2: ListModel에 컬럼 newColumn 삭제
            if oldSchemaVersion < 2 {
                print("1 -> 2")
            }
            
            // 3: ListModel에 컬럼 newColumn2 추가
            if oldSchemaVersion < 3 {
                print("2 -> 3")
            }
            
            // 4: ListModel에 컬럼 newColumn2의 컬럼명을 renamedNewColumn2로 수정
            if oldSchemaVersion < 4 {
                print("3 -> 4")
                migration.renameProperty(onType: ListModel.className(), from: "newColumn2", to: "renamedNewColumn2")
            }
            
            // 5: ListModel에 새로운 컬럼 newTitle 추가 후, 기본값을 title 컬럼 값으로 초기화
            if oldSchemaVersion < 5 {
                print("4 -> 5")
                migration.enumerateObjects(ofType: ListModel.className()) { oldObject, newObject in
                    guard let old = oldObject else { return }
                    guard let new = newObject else { return }
                    
                    new["newTitle"] = "안녕하세요. \(old["title"]!)입니다!"
                }
            }
            
        }
        
        Realm.Configuration.defaultConfiguration = configuration

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

