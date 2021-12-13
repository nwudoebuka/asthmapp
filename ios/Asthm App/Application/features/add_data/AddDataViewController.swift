//
//  AddDataViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 14.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common
import PKHUD

class AddDataViewController: UIViewController, ReKampStoreSubscriber {

    private let tableView = UITableView()
    private let tableAdapter = AddDataTableViewAdapter()
    private var tableViewReloadCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupView()
    }

    private func setupTableView() {
        tableView.run {
            $0.backgroundColor = .clear
            $0.delegate = tableAdapter
            $0.dataSource = tableAdapter
            $0.separatorStyle = .none
        }

        [AddDataMeasureTableViewCell.self, AddDataNextReviewTableViewCell.self,
         AddDataPuffsTableViewCell.self].forEach(tableView.registerForReuse(cellType:))
        tableAdapter.onHintTap = { link in
            self.presentModal(WebViewController(link))
        }
    }

    private func setupView() {
        title = "add_data".localized
        view.backgroundColor = Palette.whitesmoke

        setBarButtonItems()
        buildViewTree()
        setConstraints()
        setInteractions()
        setupKeyboardBehaviour()
    }

    private func setBarButtonItems() {
        navigationItem.run {
            $0.rightBarButtonItem = UIBarButtonItemWithText().apply {
                $0.bind("submit".localized, Palette.royalBlue)
            }
            $0.leftBarButtonItem = UIBarButtonItemWithText().apply {
                $0.bind("cancel".localized)
            }
        }
    }

    private func buildViewTree() {
        view.addSubview(tableView)
    }

    private func setConstraints() {
        tableView.edgesToSuperview()
    }

    private func setInteractions() {
        navigationItem.leftBarButtonItem?.customView?.onTap(target: self, action: #selector(onCancelTap))
        navigationItem.rightBarButtonItem?.customView?.onTap(target: self, action: #selector(onSubmitTap))
    }

    @objc private func onCancelTap() {
        dismissAndDestroy()
    }

    @objc private func onSubmitTap() {
        store.dispatch(action: AddDataRequests.SubmitData())
    }

    func onNewState(state: Any) {
        let state = state as! AddDataState
        switch (state.status) {
        case .submitted:
            dismissAndDestroy()
            hideLoading()
        case .pending:
            showLoading()
        case .idle:
            hideLoading()
        default:
            break
        }
        updateData(state)
    }

    private func dismissAndDestroy() {
        store.dispatch(action: AddDataRequests.Destroy())
        dismiss(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                KotlinBoolean(bool: oldState.addData == newState.addData)
            }.select { state in
                state.addData
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }

    private func updateData(_ state: AddDataState) {
        tableAdapter.items = [
            .measure(
                AddDataItem.MeasureUIModel(
                    title: "blood_oxygen_level".localized,
                    hint: "xx".localized,
                    linkText: Constants().SP02_INFO_LINK,
                    measureUnit: "%",
                    onDataChange: { value in
                        store.dispatch(action: AddDataRequests.UpdateBloodOxygenLevel(value: value))
                    },
                    textFieldValidator: AddDataTextFieldDelegate().apply {
                        $0.bind(validator: Sp02Validator())
                    },
                    value: state.bloodOxygenLevel?.intValue,
                    linkTitle: "expected_values".localized
                )
            ),
            .measure(
                AddDataItem.MeasureUIModel(
                    title: "pulse".localized,
                    hint: "xx".localized,
                    linkText: Constants().PULSE_INFO_LINK,
                    measureUnit: "bpm".localized,
                    onDataChange: { value in
                        store.dispatch(action: AddDataRequests.UpdatePulse(value: value))
                    },
                    textFieldValidator: AddDataTextFieldDelegate().apply {
                        $0.bind(validator: PulseValidator())
                    },
                    value: state.pulse?.intValue,
                    linkTitle: "expected_values".localized
                )
            ),
            .puffs(
                AddDataItem.PuffsUIModel(
                    title: "puffs".localized,
                    items: [
                        AddDataItem.PuffsUIModel.Item(
                            title: "preventer_inhaler".localized,
                            onDataChange: { value in
                                store.dispatch(action: AddDataRequests.UpdatePreventerPuffs(value: value))
                            },
                            validator: PulseValidator(),
                            value: state.preventerPuffs
                        ),
                        AddDataItem.PuffsUIModel.Item(
                            title: "reliever_inhaler".localized,
                            onDataChange: { value in
                                store.dispatch(action: AddDataRequests.UpdateRelieverPuffs(value: value))
                            },
                            validator: PulseValidator(),
                            value: state.relieverPuffs
                        ),
                        AddDataItem.PuffsUIModel.Item(
                            title: "combination_inhaler".localized,
                            onDataChange: { value in
                                store.dispatch(action: AddDataRequests.UpdateCombinationPuffs(value: value))
                            },
                            validator: PulseValidator(),
                            value: state.combinationPuffs
                        )
                    ],
                    infoLink: Constants().INHALER_INFO_LINK
                )
            ),
            .measure(
                AddDataItem.MeasureUIModel(
                    title: "peak_expiratory_flow".localized,
                    hint: "xxx".localized,
                    linkText: Constants().PEAK_EXPIRATORY_FLOW_INFO_LINK,
                    measureUnit: "lpm".localized,
                    onDataChange: { value in
                        store.dispatch(action: AddDataRequests.UpdatePeakExpiratoryFlow(value: value))
                    },
                    textFieldValidator: AddDataTextFieldDelegate().apply {
                        $0.bind(validator: PeakExpiratoryFlowValidator())
                    },
                    value: state.peakExpiratoryFlow?.intValue,
                    linkTitle: "expected_values".localized
                )
            ),
            .nextReview(
                AddDataItem.NextReviewUIModel(
                    title: "next_asthma_review".localized,
                    onReminderSwitch: { isOn in
                        store.dispatch(action: AddDataRequests.UpdateIsReminderActivated(isActivated: isOn))
                    },
                    isReminderActivated: state.isReminderActivated,
                    onScheduledReminderSet: { timestamp in
                        store.dispatch(action: AddDataRequests.UpdateScheduledReminder(scheduledReminder: timestamp))
                    }
                )
            )
        ]
        if tableViewReloadCount == 0 {
            tableView.reloadData()
        }
        tableViewReloadCount += 1
    }

    private func showLoading() {
        PKHUD.sharedHUD.userInteractionOnUnderlyingViewsEnabled = false
        HUD.show(.progress, onView: navigationController?.view)
    }

    private func hideLoading() {
        HUD.hide(afterDelay: 0)
    }

    private func setupKeyboardBehaviour() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }

        var contentInset: UIEdgeInsets = tableView.contentInset
        contentInset.bottom = keyboardSize
        tableView.contentInset = contentInset
    }

    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        tableView.contentInset = UIEdgeInsets.zero
    }
}
