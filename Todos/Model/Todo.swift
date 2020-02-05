//
//  Todo.swift
//  Todos
//
//  Created by Jiehao Zhang on 2019/9/9.
//  Copyright © 2019 zjh. All rights reserved.
//

import Foundation
import RealmSwift

class Todo:Object{
    @objc dynamic var name = ""
    @objc dynamic var checked = false
    @objc dynamic var createdAT = Date()
}
