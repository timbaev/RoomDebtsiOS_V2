//
//  DefaultCheckService.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 13/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

struct DefaultCheckService: CheckService {

    // MARK: - Instance Properties

    private let router = AuthRouter<CheckAPI>()

    let checkExtractor: CheckExtractor

    // MARK: - Instance Methods

    func create(with form: CreateCheckForm, success: @escaping (Check) -> Void, failure: @escaping (WebError) -> Void) {
        self.router.jsonObject(.create(form: form), success: { response in
            do {
                let check = try self.checkExtractor.extractCheck(from: response.content, cacheContext: Services.cacheViewContext)

                success(check)
            } catch {
                if let webError = error as? WebError {
                    failure(webError)
                } else {
                    Log.e(error.localizedDescription)
                }
            }
        }, failure: failure)
    }
}
