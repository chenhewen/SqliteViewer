//
//  test.swift
//  LearnQRCodeScanner
//
//  Created by 陈鹤文 on 2022/7/4.
//
#if os(iOS)

import Foundation
import SQLite
import CoreData

struct TableController {
    
    var dbDirPath: String
    var dbName: String
    var tableName: String
    var db: Connection?
    
    func getColumnNames() -> [String] {
        var arr: [String] = []
        do {
            let tableInfo = try db!.prepare("PRAGMA table_info(\(tableName))")
            for row in tableInfo {
                arr.append(row[1]! as! String)
            }
        } catch {
            print(error)
        }
        
        return arr
    }
    
    func getColumnTypes() -> [String] {
        var result: [String] = []
        let names = self.getColumnNames()
        var script = "SELECT "
        for (i, name) in names.enumerated() {
            if i < names.count - 1 {
                script += "typeof(\(name)), "
            } else {
                script += "typeof(\(name)) "
            }
        }
        script += "FROM \(tableName) LIMIT 1;"
        do {
            let tableInfo = try db!.prepare(script)
            for row in tableInfo {
                for item in row {
                    let type = item! as! String
                    result.append(type)
                }
            }
//            print(result)
//            print("------")
        } catch {
            print(error)
        }
        
        return result
    }
        
    func getRows() -> [Row] {
        var allRows: [Row] = []
        do {
            let books = Table(self.tableName)
            allRows = Array(try db!.prepare(books))
        }catch {
            print (error)
        }
        
        return allRows
        
    }
}

struct DBController {
    
    var dbDirPath: String
    var dbName: String
    var tableControllers: [String: TableController] = [:]
    var db: Connection?
    
    var sqliteDBPath: String {
        return dbDirPath + "/" + dbName
    }
    
    init(databaseDirPath: String = NSPersistentContainer.defaultDirectoryURL().absoluteString,
         databaseName: String) {
        self.dbDirPath = databaseDirPath
        self.dbName = databaseName
        db = try? Connection(databaseDirPath + "/" + databaseName)        
    }
    
    func getTableNames() -> [String] {
        var result: [String] = []
        do {
            let statement = try self.db!.prepare("SELECT name FROM sqlite_schema WHERE type='table'")
            for row in statement {
                if let r = row[0] {
                    result.append(r as! String)
                }
            }
        } catch {
            print(error)
        }
        
        return result
    }
    
    mutating func getTableController(tableName: String) -> TableController {
        guard let controller = tableControllers[tableName] else {
            let tc = TableController(dbDirPath: self.dbDirPath,
                                 dbName: self.dbName,
                                 tableName: tableName,
                                 db: self.db)
            tableControllers[tableName] = tc
            return tc
        }
        
        return controller
    }
}

#endif
