//
//  User.swift
//  ProjectManager
//
//  Copyright (c) 2023 Minii All rights reserved.

import FirebaseAuth

struct UserInformation: Codable {
    let userId: String
    let email: String
    let projectIds: [String] = []
}
