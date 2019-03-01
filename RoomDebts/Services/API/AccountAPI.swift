//
//  AccountAPI.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 22/01/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

enum AccountAPI {

    // MARK: - Enumeration Cases

    case create(firstName: String, lastName: String, phoneNumber: String)
    case confirm(phoneNumber: String, code: String)
    case signIn(phoneNumber: String)
    case avatar(image: UIImage)
}

// MARK: - EndPointType

extension AccountAPI: EndPointType {

    var path: String {
        let basePath = "/v1/account"

        switch self {
        case .create:
            return basePath

        case .confirm:
            return basePath + "/confirm"

        case .signIn:
            return basePath + "/login"

        case .avatar:
            return basePath + "/avatar"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .create, .confirm, .signIn, .avatar:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case let .create(firstName, lastName, phoneNumber):
            return .requestParameters(
                bodyParameters: Coders.userAccountCoder.encode(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber),
                urlParameters: nil
            )

        case let .confirm(phoneNumber, code):
            return .requestParameters(bodyParameters: Coders.confirmCoder.encode(phoneNumber: phoneNumber, code: code), urlParameters: nil)

        case .signIn(let phoneNumber):
            return .requestParameters(bodyParameters: Coders.phoneNumberCoder.encode(phoneNumber: phoneNumber), urlParameters: nil)

        case .avatar(let image):
            return .upload(image: image, imageName: "avatar.jpg", mimeType: .jpeg)
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
