//
//  DBTableView.swift
//  LearnQRCodeScanner
//
//  Created by 陈鹤文 on 2022/7/4.
//

#if os(iOS)

import SwiftUI
import SQLite


public struct DBTableView: SwiftUI.View {
    
    var tableModel: TableModel // = DBModel(databaseName: "BookStore.sqlite").tableModels[1]
    
    public init(tableModel: TableModel) {
        self.tableModel = tableModel
    }
    
    var columns: [GridItem] {
        var result: [GridItem] = []
        for i in 0..<tableModel.columnCount {
            let colWidthArray = tableModel.columnWidthArray
            let width = max(30, colWidthArray[i])
            result.append(GridItem(.fixed(width)))
        }
        return result
    }
    
    public var body: some SwiftUI.View {
        ScrollView([.horizontal, .vertical]) {
            LazyVGrid(columns: columns) {
                ForEach(tableModel.columnNames, id: \.self) { colName in
                    Text(colName)
                }.background(.green)
                
                ForEach(tableModel.rows, id: \.id) { rowModel in
                    ForEach(rowModel.items, id: \.id) { itemModel in
                        Text(itemModel.value)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }                
             }
        }
    }
}

#endif
