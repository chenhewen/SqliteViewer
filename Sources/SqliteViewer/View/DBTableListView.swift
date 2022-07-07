//
//  DBTableListView.swift
//  LearnQRCodeScanner
//
//  Created by 陈鹤文 on 2022/7/5.
//

#if os(iOS)
import SwiftUI

public struct DBTableListView: View {
    var dbModel = DBModel(databaseName: "BookStore.sqlite")
    
    public init() {
        
    }
    
    public var body: some View {
        List {
            ForEach(dbModel.tableModels, id:\.id) { tableModel in
                NavigationLink {
                    DBTableView(tableModel: tableModel)
                } label: {
                    HStack {
                        Text(tableModel.tableName)
                    }
                }
            }
        }
    }
}
#endif
