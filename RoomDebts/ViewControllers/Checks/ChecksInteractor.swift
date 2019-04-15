//
//  ChecksInteractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation

final class ChecksInteractor: ChecksBusinessLogic, ChecksDataStore {

    // MARK: - Instance Properties

    var presenter: ChecksPresentationLogic!
    var checkService: CheckService!

    // MARK: - Instance Methods

    private func extractMetadata(_ metadata: String) -> CreateCheckForm? {
        let pattern = #"^(?=.*t=([^&]+)|)(?=.*s=([^&]+)|)(?=.*fn=([^&]+)|)(?=.*i=([^&]+)|)(?=.*fp=([^&]+)|)(?=.*n=([^&]+)|).+$"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return nil
        }

        for match in regex.matches(in: metadata, range: NSRange(0..<metadata.utf16.count)) {
            let nsMetadata = metadata as NSString

            let dateTime = nsMetadata.substring(with: match.range(at: 1))
            let rawSum = nsMetadata.substring(with: match.range(at: 2))
            let fn = nsMetadata.substring(with: match.range(at: 3))
            let i = nsMetadata.substring(with: match.range(at: 4))
            let fp = nsMetadata.substring(with: match.range(at: 5))
            let rawN = nsMetadata.substring(with: match.range(at: 6))

            guard let sumValue = Double(rawSum) else {
                return nil
            }

            let sum = Int(sumValue * 100)

            guard let fiscalSign = Int(fp) else {
                return nil
            }

            guard let fd = Int(i) else {
                return nil
            }

            guard let n = Int(rawN) else {
                return nil
            }

            let form = CreateCheckForm(date: dateTime, sum: sum, fiscalSign: fiscalSign, fd: fd, n: n, fn: fn)

            return form
        }

        return nil
    }

    // MARK: - ChecksBusinessLogic

    func createCheck(with metadata: String) {
        guard let form = self.extractMetadata(metadata) else {
            self.presenter.showMessage(with: "Invalid QR Code".localized(), message: "Support only receipt's QR codes".localized())
            return
        }

        self.presenter.showLoadingIndicator()

        self.checkService.create(with: form, success: { [weak self] check in
            guard let interactor = self else {
                return
            }

            interactor.presenter.hideLoadingIndicator()
        }, failure: { [weak self] error in
            guard let interactor = self else {
                return
            }

            interactor.presenter.hideLoadingIndicator()
            interactor.presenter.showMessage(with: error)
        })
    }
}
