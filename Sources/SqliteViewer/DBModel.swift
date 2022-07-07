//
//  TableModel.swift
//  LearnQRCodeScanner
//
//  Created by 陈鹤文 on 2022/7/4.
//
#if os(iOS)

import Foundation
import SQLite
import SwiftUI

extension String {
    
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

struct DynamicExpression {
    static func createExpression<T>(_ name: String, type: T) -> Expression<T> {
        return Expression<T>(name)
    }
}

public struct DBModel {
    var dbController: DBController // = "BookStore.sqlite"
    //var tableController: TableController // = "ZBOOKENTITY"
    var tableModels: [TableModel] = []
    
    init(databaseName: String) {
        dbController = DBController(databaseName: databaseName)
        let names = dbController.getTableNames()
        for name in names {
            let tableController = dbController.getTableController(tableName: name)
            let tableModel = TableModel(tableController: tableController)
            tableModels.append(tableModel)
        }
    }
}

public struct TableModel {
    
    var id = UUID().uuidString
    var columnNames: [String]!
    var columnTypes: [String]!
    var rows: [RowModel]!
    var tbController: TableController
    
    var columnCount: Int {
        return columnNames.count
    }
    
    var tableName: String {
        return tbController.tableName
    }
    
    var columnWidthArray: [Double]
    
    init(tableController: TableController) {
        self.tbController = tableController
        columnNames = tableController.getColumnNames()
        columnTypes = tableController.getColumnTypes()
        columnWidthArray = [Double](repeating: 0.0, count: columnNames.count)
        
        var rowList: [RowModel] = []
        for row in tableController.getRows() {
            var itemList:[ItemModel] = []
            for i in 0..<columnCount {
                let colName = columnNames[i]
                // fixme String
                let type = columnTypes[i]
                var value = "*"
                if type == "integer" {
                    if let v = try? row.get(Expression<Int>(colName)) {
                        value = String(v)
                    }
                } else if type == "text" {
                    if let v = try? row.get(Expression<String>(colName)) {
                        value = v
                    }
                } else if type == "real" {
                    if let v = try? row.get(Expression<Double>(colName)) {
                        value = String(v)
                    }
                } else if type == "blob" {
                    if let _ = try? row.get(Expression<SQLite.Blob>(colName)) {
                        value = "unimplemented blob"
                    }
                }

                // fixme extract the code
                let font = UIFont.systemFont(ofSize: 17)
                let cellWidth = value.widthOfString(usingFont: font)
                let headWidth = colName.widthOfString(usingFont: font)
                columnWidthArray[i] = max(cellWidth, headWidth, columnWidthArray[i])
                
                let itemModel = ItemModel(value: value, columnName: colName)
                itemList.append(itemModel)
            }
            
            let rowModel = RowModel(items: itemList)
            rowList.append(rowModel)
        }
        rows = rowList
    }
}

public struct RowModel {
    var id = UUID().uuidString
    var items: [ItemModel]
}

public struct ItemModel {
    var id = UUID().uuidString
    var value: String
    var columnName: String
}

#endif
