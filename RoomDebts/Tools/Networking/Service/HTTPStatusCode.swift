//
//  HTTPStatusCode.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 21/03/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

enum HTTPStatusCode: Int {
    case `continue` = 100
    case switchingProtocols
    case processing

    case ok = 200
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
    case iMUsed = 226

    case multipleChoices = 300
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy
    case switchProxy
    case temporaryRedirect
    case permanentRedirect

    case badRequest = 400
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case payloadTooLarge
    case uriTooLong
    case unsupportedMediaType
    case rangeNotSatisfiable
    case expectationFailed
    case imATeapot
    case misdirectedRequest = 421
    case unprocessableEntity
    case locked
    case failedDependency
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests
    case requestHeaderFieldsTooLarge = 431
    case unavailableForLegalReasons = 451

    case internalServerError = 500
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case httpVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended = 510
    case networkAuthenticationRequired
}
