// CoreData

import Foundation
import CoreData

// 업데이트 구조체모델
struct UpdateInfo {
    var updateName: String?
    var updateContact: String?
    var updateImageURL: String?
}

class CoreDataManager {
    // 싱글톤
    static let shared = CoreDataManager()
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
    
    /* ---------- CRUD의 C ---------- */
    func createData(name: String, contact: String, imageURL: String?) {
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
    
    
    /* ---------- CRUD의 R(콘솔 확인용) ----------- */
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
    
    /* ---------- CoreData에 저장된 데이터를 불러옴 (fetch) ---------- */
    func getInformation() -> [Information] {
        var InformationList = [Information]()
        
        let context = persistentContainer.viewContext
        
        let fecthRequest: NSFetchRequest<Information> = Information.fetchRequest()
        
        do {
            InformationList = try context.fetch(fecthRequest)
        } catch {
            print("fetching error: \(error)")
        }
        
        return InformationList
    }
    
    /* ---------- CRUD의 U ---------- */
    func updateData(info: Information, with newData: UpdateInfo) {
        info.name = newData.updateName
        info.contact = newData.updateContact
        //info.imageURL = newData.updateImageURL
        
        if let raw = newData.updateImageURL?.trimmingCharacters(in: .whitespacesAndNewlines),
           !raw.isEmpty {
            info.imageURL = raw
        }
        
        do {
            try persistentContainer.viewContext.save()
            print("업데이트 성공: imageURL=\(info.imageURL ?? "nil")")
        } catch {
            print("업데이트 실패: \(error)")
        }
    }
    
    /* ----------- CRUD의 D ---------- */
    func deleteData(info: Information) {
        let context = persistentContainer.viewContext
        context.delete(info)
        
        do {
            try context.save()
            print("✅ 개별 삭제 성공")
        } catch {
            print("❌ 전체 삭제 실패: \(error)")
        }
    }

}
