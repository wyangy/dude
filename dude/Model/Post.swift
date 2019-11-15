//
//  Post.swift
//  dude
//
//  Created by Wendy Yang on 2019/11/15.
//  Copyright © 2019 wyangy. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Post {
    let ref : DatabaseReference
    let email : String
    let message : String
}
