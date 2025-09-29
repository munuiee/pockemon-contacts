//
//  CoreDataManager.swift
//  pokeContact
//
//  Created by Jihye의 MacBook Pro on 9/29/25.
//

import Foundation
import CoreData

class CoreDataManager {
    // 싱글톤
    static let shared = CoreDataManager()
    // Init 함수를 호출해 인스턴스를 또 생성하는 것을 막기 위해 접근 제어자 private
    private init() {}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "pokeContact")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createData(name: String, contact: String, imageURL: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Information", in: self.persistentContainer.viewContext)
        else { return }
        
        let newInformation = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext)
        
        newInformation.setValue(name, forKey: "name")
        newInformation.setValue(contact, forKey: "contact")
        newInformation.setValue(imageURL, forKey: "imageURL")
        
        do {
            try self.persistentContainer.viewContext.save()
            print("저장 성공")
        } catch {
            print("저장 실패")
        }
    }
    
    func readAllData() {
        do {
            let informations = try self.persistentContainer.viewContext.fetch(Information.fetchRequest())
            
            for information in informations as [NSManagedObject]{
                if let name = information.value(forKey: "name") as? String,
                   let contact = information.value(forKey: "contact") as? String,
                   let imageURL = information.value(forKey: "imageURL") as? String {
                    print("name: \(name), contact: \(contact), imageURL: \(imageURL)")
                }
            }
        } catch {
            print("데이터 읽기 실패")
        }
    }
}
