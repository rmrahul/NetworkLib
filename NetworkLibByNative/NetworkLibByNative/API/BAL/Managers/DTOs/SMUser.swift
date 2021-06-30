/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct SMUser : Codable {
	var id : String?
	var first_name : String?
	var last_name : String?
	var email : String?
	var gender : String?
	var accessToken : String?
	var socialId : String?
	var batchCount : Int?
    var device_type: String?
    var device_token: String?
    var password: String?
    var confirm_password: String?
    
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case first_name = "first_name"
		case last_name = "last_name"
		case email = "email"
		case gender = "gender"
		case accessToken = "accessToken"
		case socialId = "socialId"
		case batchCount = "batchCount"
        
        case device_type = "device_type"
        case device_token = "device_token"
        case password = "password"
        case confirm_password = "confirm_password"

	}

    init() {}
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		gender = try values.decodeIfPresent(String.self, forKey: .gender)
		accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
		socialId = try values.decodeIfPresent(String.self, forKey: .socialId)
		batchCount = try! values.decodeIfPresent(Int.self, forKey: .batchCount)
        device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        confirm_password = try values.decodeIfPresent(String.self, forKey: .confirm_password)
	}
}
