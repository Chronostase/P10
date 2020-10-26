//
//  FakeResponse.swift
//  RecipleaseTests
//
//  Created by Thomas on 16/09/2020.
//  Copyright © 2020 Thomas. All rights reserved.
//

import Foundation
import Alamofire

struct FakeResponse {
    var response: HTTPURLResponse?
    var error: AFError?
    var data: Data?
}
