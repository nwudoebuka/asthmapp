//
//  BuddyMainViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 15.02.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common
import PKHUD

class BuddyMainViewController: UIViewController, ReKampStoreSubscriber {

    private let tableView = UITableView()
    private let tableAdapter = BuddyUsersTableViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        fetchData()
    }

    private func setupView() {
        view.backgroundColor = Palette.whitesmoke
        title = "my_buddies".localized

        view.addSubview(tableView)
        tableView.edgesToSuperview()
        addLogoutButton()
    }

    private func setupTableView() {
        tableView.run {
            $0.backgroundColor = .clear
            $0.delegate = tableAdapter
            $0.dataSource = tableAdapter
            $0.separatorStyle = .none
        }

        [BuddyUserTableViewCell.self].forEach(tableView.registerForReuse(cellType:))
    }

    private func addLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic_logout")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(logOutTapped)
        ).apply {
            $0.tintColor = Palette.ebonyClay
        }
    }

    @objc private func logOutTapped() {
        let alertController = UIAlertController(
            title: "log_out".localized,
            message: "do_you_want_to_log_out".localized,
            preferredStyle: .alert
        )

        let stayLoggedInButton = UIAlertAction(
            title: "stay_logged_in".localized,
            style: .default
        )
        let logOutButton = UIAlertAction(
            title: "log_out".localized,
            style: .destructive,
            handler: { _ in self.logOut() })

        [stayLoggedInButton, logOutButton].forEach(alertController.addAction)

        present(alertController, animated: true, completion: nil)
    }

    private func logOut() {
        try? Firebase.auth.signOut()
        store.dispatch(action: IAuthBuddyRequestsLogOut())

        dismiss(animated: true)
    }

    private func fetchData() {
        store.dispatch(action: BuddyRequests.FetchBuddyUsers())
    }

    func onNewState(state: Any) {
        let state = state as! BuddyState
        switch (state.status) {
        case .idle:
            tableAdapter.run {
                $0.items = getItems(state)
                $0.onUserTap = { index in
                    let user = state.buddyUsers[index]
                    switch (user.status) {
                    case .pending:
                        self.showBuddyAcceptDialog(user)
                    case .accepted:
                        self.presentModal(ReportsViewController(buddyUserId: user.id))
                    case .emergency:
                        if user.locationLat != nil && user.locationLng != nil {
                            self.presentModal(BuddyEmergencyViewController(user))
                        } else {
                            self.showMissingBuddyLocationDialog()
                        }
                    default:
                        break
                    }
                }
            }
            hideLoading()
        case .pending:
            tableAdapter.items = []
            showLoading()
        default:
            break
        }
        tableView.reloadData()
    }

    private func showBuddyAcceptDialog(_ user: BuddyUser) {
        let alertController = UIAlertController(
            title: "buddy_request".localized,
            message: "buddy_request_explanation".localizedFormat(args: user.fullName),
            preferredStyle: .alert
        ).apply {
            $0.addAction(UIAlertAction(title: "accept".localized, style: .cancel) { _ in
                store.dispatch(action: BuddyRequests.AcceptBuddyRequest(userId: user.id))
            })
            $0.addAction(UIAlertAction(title: "reject".localized, style: .destructive) { _ in
                store.dispatch(action: BuddyRequests.RejectBuddyRequest(userId: user.id))
            })
        }

        present(alertController, animated: true)
    }
    
    private func showMissingBuddyLocationDialog() {
        let alertController = UIAlertController(
            title: "missing_buddy_location".localized,
            message: "missing_buddy_location_explanation".localized,
            preferredStyle: .alert
        ).apply {
            $0.addAction(UIAlertAction(title: "ok".localized, style: .cancel))
        }

        present(alertController, animated: true)
    }

    private func getItems(_ state: BuddyState) -> [BuddyUsersItem] {
        state.buddyUsers.map { user in
            BuddyUsersItem.buddy(
                .init(title: user.fullName, image: getImageByStatus(user.status))
            )
        } + (state.buddyUsers.isEmpty ? [.noBuddies] : [])
    }

    private func getImageByStatus(_ status: BuddyUser.Status) -> UIImage? {
        switch (status) {
        case .accepted:
            return UIImage(named: "ic_green_dot")
        case .pending:
            return UIImage(named: "ic_gray_dot")
        case .emergency:
            return UIImage(named: "ic_alert")
        default:
            fatalError()
        }
    }

    private func showLoading() {
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        HUD.show(.progress, onView: navigationController?.view)
    }

    private func hideLoading() {
        HUD.hide(afterDelay: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                KotlinBoolean(bool: oldState.buddy == newState.buddy)
            }.select { state in
                state.buddy
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
}
