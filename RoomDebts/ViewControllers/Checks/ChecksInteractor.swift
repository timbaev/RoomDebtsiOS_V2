//
//  ChecksInteractor.swift
//  RoomDebts
//
//  Created by Timur Shafigullin on 11/04/2019.
//  Copyright © 2019 Timur Shafigullin. All rights reserved.
//

import Foundation
import PromiseKit

final class ChecksInteractor: ChecksBusinessLogic, ChecksDataStore {

    // MARK: - Instance Properties

    private var checkList: CheckList?
    private var checkListType: CheckListType = .unknown

    private var isRefreshingData = false
    private var shouldApplyData = true

    // MARK: - ChecksDataStore

    var checks: [Check] = []

    // MARK: - Initializers

    deinit {
        self.unsubscribeFromCheckEvents()
    }

    // MARK: -

    var presenter: ChecksPresentationLogic!

    var checkService: CheckService!
    var checkManager: CheckManager!
    var checkListManager: CheckListManager!

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

    private func handle(stateError error: Error) {
        let actionTitle = "Try Again".localized()

        switch error as? WebError {
        case .some(.connection), .some(.timeOut):
            if self.checkList?.isEmpty ?? true {
                self.presenter.showEmptyState(with: #imageLiteral(resourceName: "ErrorInternet.pdf"),
                                              title: Messages.internetConncetionTitle,
                                              message: Messages.internetConnection,
                                              actionTitle: actionTitle)
            } else {
                self.presenter.showMessage(with: Messages.internetConncetionTitle, message: Messages.internetConnection)
            }

        case .some(.badRequest):
            if let webError = error as? WebError, let message = webError.message {
                if self.checkList?.isEmpty ?? true {
                    self.presenter.showEmptyState(with: #imageLiteral(resourceName: "ErrorWarning"),
                                                  title: Messages.unknownErrorTitle,
                                                  message: message,
                                                  actionTitle: actionTitle)
                } else {
                    self.presenter.showMessage(with: Messages.unknownErrorTitle, message: message)
                }
            } else {
                self.presenter.showEmptyState(with: #imageLiteral(resourceName: "ErrorWarning"),
                                              title: Messages.unknownErrorTitle,
                                              message: Messages.unknownError,
                                              actionTitle: actionTitle)
            }

        default:
            if self.checkList?.isEmpty ?? true {
                self.presenter.showEmptyState(with: #imageLiteral(resourceName: "ErrorWarning"),
                                              title: Messages.unknownErrorTitle,
                                              message: Messages.unknownError,
                                              actionTitle: actionTitle)
            } else {
                self.presenter.showMessage(with: Messages.unknownErrorTitle, message: Messages.unknownError)
            }
        }
    }

    // MARK: -

    private func subscribeToCheckEvents() {
        self.unsubscribeFromCheckEvents()

        self.checkManager.objectsChangedEvent.connect(self, handler: { [weak self] check in
            if let checkList = self?.checkListManager.first(withListType: .all) {
                self?.checkList = checkList
                self?.checks = checkList.checks

                self?.presenter.showChecks(with: checkList)
            }
        })

        self.checkManager.startObserving()
    }

    private func unsubscribeFromCheckEvents() {
        self.checkManager.objectsChangedEvent.disconnect(self)
    }

    // MARK: - ChecksBusinessLogic

    func createCheck(with metadata: String) {
        guard let form = self.extractMetadata(metadata) else {
            self.presenter.showMessage(with: "Invalid QR Code".localized(), message: "Support only receipt's QR codes".localized())
            return
        }

        self.presenter.showLoadingIndicator()

        firstly {
            self.checkService.create(with: form)
        }.ensure {
            self.presenter.hideLoadingIndicator()
        }.catch { error in
            self.presenter.showMessage(with: error)
        }
    }

    func fetchChecks() {
        let checkList = self.checkListManager.firstOrNew(withListType: .all)

        if checkList.isEmpty {
            self.presenter.showLoadingState(with: "Loading checks".localized(),
                                            message: "We are loading list of checks. Please wait a bit".localized())
        } else {
            self.checks = checkList.checks
            self.checkList = checkList

            self.presenter.showChecks(with: checkList)
        }

        firstly {
            self.checkService.fetchAll()
        }.done { checkList in
            self.subscribeToCheckEvents()

            self.checks = checkList.checks
            self.checkList = checkList

            if checkList.isEmpty {
                self.presenter.showEmptyState(with: "Checks not exists".localized(), actionTitle: "Scan New Check".localized())
            } else {
                self.presenter.hideEmptyState()
            }

            self.presenter.stopRefreshing()

            self.presenter.showChecks(with: checkList)
        }.catch { error in
            self.handle(stateError: error)
        }
    }
}
