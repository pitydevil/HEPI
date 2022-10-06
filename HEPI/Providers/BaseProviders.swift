//
//  Base Providers.swift
//  HEPI
//
//  Created by Mikhael Adiputra on 03/10/22.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

class BaseProviders : databaseRequestProtocol, querySummaryProtocol{
    func callDatabase<T: Codable>() -> Observable<T>  {
        return Observable<T>.create { observer in
            let taskContext = self.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Journaling")
                do {
                    let results = try taskContext.fetch(fetchRequest)
                    var journalArray: [Journal] = []
                    for journal in results {
                        let journalNew = Journal(titleJournal: journal.value(forKey: "titleJournal") as? String, moodDesc: journal.value(forKey: "moodDesc") as? String, descJournal:  journal.value(forKey: "descJournal") as? String, dateCreated:  journal.value(forKey: "dateCreated") as? Date, moodImage: journal.value(forKey: "moodImage") as? Data)
                        journalArray.append(journalNew)
                    }
                    observer.onNext(journalArray as! T)
                } catch let error as NSError {
                    observer.onError(error)
                }
            }
            return Disposables.create {
            }
        }
    }
    
    lazy var persistContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HEPI")
        
        container.loadPersistentStores{ _, error in
            guard error == nil else {
                fatalError("Unresolved error \(String(describing: error))")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return taskContext
    }
    
    func deleteJournal(_ dateCreated: Date, completion: @escaping(_ result: Bool)->Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Journaling")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "dateCreated == %@", dateCreated as CVarArg )
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion(true)
                }else {
                    completion(false)
                }
            }
        }
    }
    
    func querySummary<T>(_ startDate: Date, _ endDate: Date) -> Observable<T> where T : Decodable, T : Encodable {
        return Observable<T>.create { observer in
            let taskContext = self.newTaskContext()
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Journaling")
                let predicate_0  = NSPredicate(format: "dateCreated >= %@", startDate as CVarArg)
                let predicate_1  = NSPredicate(format: "dateCreated <= %@", endDate as CVarArg)
                fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate_0, predicate_1])
                do {
                    let results = try taskContext.fetch(fetchRequest)
                    var journalArray: [Journal] = []
                    for journal in results {
                        let journalNew = Journal(titleJournal: journal.value(forKey: "titleJournal") as? String, moodDesc: journal.value(forKey: "moodDesc") as? String, descJournal:  journal.value(forKey: "descJournal") as? String, dateCreated:  journal.value(forKey: "dateCreated") as? Date, moodImage: journal.value(forKey: "moodImage") as? Data)
                        journalArray.append(journalNew)
                    }
                    observer.onNext(journalArray as! T)
                } catch let error as NSError {
                    observer.onError(error)
                }
            }
            return Disposables.create {
            }
        }
    }
    
    func updateExisting(_ titleJournal:String, _ descJournal: String, _ dateCreated : Date, _ moodImage : Data, _ moodDesc : String, completion: @escaping(_ result: Bool) -> Void) {

        let taskContext = newTaskContext()
        taskContext.perform {
            do {
                if NSEntityDescription.entity(forEntityName: "Journaling", in: taskContext) != nil {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Journaling")
                    fetchRequest.fetchLimit = 1
                    fetchRequest.predicate = NSPredicate(format: "titleJournal == %@", titleJournal)
                    if let results = try? taskContext.fetch(fetchRequest).first {
                        var journaling : Journaling?
                        journaling = results as? Journaling
                        journaling!.moodDesc = moodDesc
                        journaling!.titleJournal = titleJournal
                        journaling!.moodImage = moodImage
                        journaling!.descJournal = descJournal
                        do {
                            try taskContext.save()
                            completion(true)
                        } catch let error as NSError {
                            completion(false)
                            print("Could not save: \(error.userInfo)")
                        }
                    }
                }
            } catch let error as NSError {
                completion(false)
            }
        }
    }
    
    func addJournal(_ titleJournal:String, _ descJournal: String, _ dateCreated : Date, _ moodImage : Data, _ moodDesc : String, completion: @escaping(_ result: Bool) -> Void) {

        let taskContext = newTaskContext()
        taskContext.perform {
            do {
                if let entity = NSEntityDescription.entity(forEntityName: "Journaling", in: taskContext) {
                    
                    let member = NSManagedObject(entity: entity, insertInto: taskContext)
                    member.setValue(descJournal, forKeyPath: "descJournal")
                    member.setValue(titleJournal, forKeyPath: "titleJournal")
                    member.setValue(dateCreated, forKeyPath: "dateCreated")
                    member.setValue(moodDesc, forKeyPath: "moodDesc")
                    member.setValue(moodImage, forKeyPath: "moodImage")
                    do {
                        try taskContext.save()
                        completion(true)
                    } catch let error as NSError {
                        completion(false)
                        print("Could not save: \(error.userInfo)")
                    }
                }
            } catch let error as NSError {
                completion(false)
            }
        }
    }
}
