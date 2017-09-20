//
//  CloudKitManager.swift
//  Leaderboards
//
//  Created by Mithun Reddy on 9/19/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func fetchRecord(withID recordID: CKRecordID, completion: ((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        publicDB.fetch(withRecordID: recordID) { (record, error) in
            completion?(record, error)
        }
    }
    
    func fetchRecords(withIDs recordIDs: [CKRecordID], completion: ((_ records: [CKRecordID: CKRecord]?, _ error: Error?) -> Void)?) {
        let fetchRecordsOperation = CKFetchRecordsOperation(recordIDs: recordIDs)
        fetchRecordsOperation.fetchRecordsCompletionBlock = completion
        publicDB.add(fetchRecordsOperation)
    }
    
    func fetchRecordsWithType(_ type: String, predicate: NSPredicate = NSPredicate(value: true), recordFetchedBlock: ((_ record: CKRecord) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        var fetchedRecords: [CKRecord] = []
        
        let query = CKQuery(recordType: type, predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        let perRecordBlock = { (fetchedRecord: CKRecord) -> Void in
            fetchedRecords.append(fetchedRecord)
            recordFetchedBlock?(fetchedRecord)
        }
        
        queryOperation.recordFetchedBlock = perRecordBlock
        
        var queryCompletionBlock: (CKQueryCursor?, Error?) -> Void = { (_, _) in }
        queryCompletionBlock = { (queryCursor: CKQueryCursor?, error: Error?) -> Void in
            if let queryCursor = queryCursor {
                // there are more results
                let continuedQueryOperation = CKQueryOperation(cursor: queryCursor)
                continuedQueryOperation.recordFetchedBlock = perRecordBlock
                continuedQueryOperation.queryCompletionBlock = queryCompletionBlock
                
                self.publicDB.add(continuedQueryOperation)
            } else {
                completion?(fetchedRecords, error)
            }
        }
        
        queryOperation.queryCompletionBlock = queryCompletionBlock
        self.publicDB.add(queryOperation)
    }
    
    func saveRecord(_ record: CKRecord, completion: ((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        
        publicDB.save(record, completionHandler: { (record, error) in
            
            completion?(record, error)
        })
    }
    
    func updateRecords(_ records: [CKRecord], perRecordCompletion: ((_ record: CKRecord?, _ error: Error?) -> Void)?, completion: ((_ records: [CKRecord]?, _ error: Error?) -> Void)?) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        operation.perRecordCompletionBlock = perRecordCompletion
        
        //operation.modifyRecordsCompletionBlock = { (records, recordIDs, error) -> Void in
            //(completion?(records, error))!
        //}
        
        publicDB.add(operation)
    }
    
}
