//
//  CheckAPI.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 12/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import UIKit

enum CheckAPI {

    // MARK: - Enumeration Cases

    case create(form: CreateCheckForm)
    case fetchAll
    case fetchProducts(uid: Int64)
    case fetch(checkUID: Int64)
    case update(store: String, checkUID: Int64)
    case upload(image: UIImage, checkUID: Int64)
    case participants(userUIDs: [Int64], checkUID: Int64)
    case removeParticipant(userUID: Int64, checkUID: Int64)
    case calculate(selectedProducts: [String: [Int64]], checkUID: Int64)
    case reviews(checkUID: Int64)
    case approve(checkUID: Int64)
    case reject(comment: String, checkUID: Int64)
}

// MARK: - EndPointType

extension CheckAPI: EndPointType {

    // MARK: - Instance Properties

    var path: String {
        let basePath = "/v1/checks"

        switch self {
        case .create, .fetchAll:
            return basePath

        case .fetch(let checkUID):
            return basePath + "/\(checkUID)"

        case .fetchProducts(let uid):
            return basePath + "/\(uid)/products"

        case let .update(_, checkUID):
            return basePath + "/\(checkUID)"

        case let .upload(_, checkUID):
            return basePath + "/\(checkUID)/image"

        case let .participants(_, checkUID):
            return basePath + "/\(checkUID)/participants"

        case let .removeParticipant(_, checkUID):
            return basePath + "/\(checkUID)/participants"

        case let .calculate(_, checkUID):
            return basePath + "/\(checkUID)/calculate"

        case .reviews(let checkUID):
            return basePath + "/\(checkUID)/reviews"

        case .approve(let checkUID):
            return basePath + "/\(checkUID)/approve"

        case let .reject(_, checkUID):
            return basePath + "/\(checkUID)/reject"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .create, .participants, .calculate:
            return .post

        case .fetchAll, .fetchProducts, .reviews, .fetch:
            return .get

        case .update, .upload, .approve, .reject:
            return .put

        case .removeParticipant:
            return .delete
        }
    }

    var task: HTTPTask {
        switch self {
        case .create(let form):
            return .requestParameters(bodyParameters: Coders.checkCoder.encode(form: form), urlParameters: nil)

        case let .update(store, _):
            return .requestParameters(bodyParameters: ["store": store], urlParameters: nil)

        case let .participants(userUIDs, _):
            return .requestParameters(bodyParameters: ["userIDs": userUIDs], urlParameters: nil)

        case let .removeParticipant(userUID, _):
            return .requestParameters(bodyParameters: nil, urlParameters: ["userID": userUID])

        case let .calculate(selectedProducts, _):
            return .requestParameters(bodyParameters: ["selectedProducts": selectedProducts], urlParameters: nil)

        case let .reject(comment, _):
            return .requestParameters(bodyParameters: ["comment": comment], urlParameters: nil)

        case let .upload(image, _):
            return .upload(image: image, imageName: "check.jpg", mimeType: .jpeg)

        case .fetchAll, .fetchProducts, .reviews, .approve, .fetch:
            return .request
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
