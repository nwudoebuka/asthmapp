//
//  ReportsViewController.swift
//  Asthm App
//
//  Created by Den Matiash on 28.01.2021.
//  Copyright © 2021 xorum.io. All rights reserved.
//

import Foundation
import UIKit
import common
import PKHUD

class ReportsViewController: ClosableUIViewController, ReKampStoreSubscriber {

    private let segmentedControl = UISegmentedControl(items: ["daily", "weekly", "monthly"].map { $0.localized })
    private let tableView = UITableView()
    private let tableAdapter = ReportsTableViewAdapter()

    private let buddyUserId: String?

    init(buddyUserId: String? = nil) {
        self.buddyUserId = buddyUserId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        title = "reports".localized
        view.backgroundColor = Palette.whitesmoke

        buildViewTree()
        setConstraints()
        setupSegmentedControl()
        setupTableView()
        fetchData()
    }

    private func buildViewTree() {
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
    }

    private func setConstraints() {
        segmentedControl.run {
            $0.topToSuperview(offset: 8)
            $0.centerXToSuperview()
        }

        tableView.run {
            $0.topToBottom(of: segmentedControl, offset: 8)
            $0.edgesToSuperview(excluding: .top)
        }
    }

    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        if #available(iOS 13, *) {
            segmentedControl.selectedSegmentTintColor = Palette.royalBlue
            segmentedControl.setTitleTextAttributes([.foregroundColor: Palette.white], for: .selected)
        }
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }

    @objc private func segmentedControlChanged() {
        fetchData()
    }

    private func setupTableView() {
        tableView.run {
            $0.backgroundColor = .clear
            $0.delegate = tableAdapter
            $0.dataSource = tableAdapter
            $0.separatorStyle = .none
        }

        [ReportTableViewCell.self, ShareReportTableViewCell.self].forEach(tableView.registerForReuse(cellType:))
    }

    func onNewState(state: Any) {
        let state = state as! ReportsState
        switch (state.status) {
        case .pending:
            showLoading()
        case .idle:
            hideLoading()
        default:
            break
        }
        if let csv = state.csv {
            shareCSV(csv)
            store.dispatch(action: ReportsRequests.DestroyCSV())
        }
        
        tableAdapter.run {
            $0.items = (buddyUserId == nil ? [.shareReport] : []) + buildReports(state)
            $0.onGetReportsTap = { period in
                self.getReportCSV(period)
            }
        }
        tableView.reloadData()
    }
    
    private func getReportCSV(_ period: Period) {
        store.dispatch(action: ReportsRequests.GetReportCSV(period: period))
    }
    
    private func shareCSV(_ csv: String) {
        if let url = URL(string: "mailto:?subject=My asthma report&body=\(csv)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            UIApplication.shared.open(url)
        }
    }

    private func fetchData() {
        store.dispatch(action: ReportsRequests.FetchReports(period: getCurrentPeriod(), buddyUserId: buddyUserId))
    }

    private func getCurrentPeriod() -> Period {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            return Period(type: .day, startInMillis: Int64(Date().dayStart.timeIntervalSince1970 * 1000))
        case 1:
            return Period(type: .week, startInMillis: DateUtils().startOfCurrentWeek())
        case 2:
            return Period(type: .month, startInMillis: Int64(Date().monthStart.timeIntervalSince1970 * 1000))
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
                KotlinBoolean(bool: oldState.reports == newState.reports)
            }.select { state in
                state.reports
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
}

extension ReportsViewController {

    private func buildReports(_ state: ReportsState) -> [ReportsItem] {
        state.reports.map { report in
            let items = [
                ReportsItem.ReportUIModel.Item(
                    title: "avg_sp02".localizedFormat(args: report.averageSp02.value),
                    subtitle: getMessageByIndicatorLevel(report.averageSp02.level),
                    image: getImageByIndicatorLevel(report.averageSp02.level)
                ),
                ReportsItem.ReportUIModel.Item(
                    title: "avg_pulse".localizedFormat(args: report.averagePulse.value),
                    subtitle: getMessageByIndicatorLevel(report.averagePulse.level),
                    image: getImageByIndicatorLevel(report.averagePulse.level)
                ),
                ReportsItem.ReportUIModel.Item(
                    title: "avg_pef".localizedFormat(args: report.averagePef.value),
                    subtitle: getMessageByIndicatorLevel(report.averagePef.level),
                    image: getImageByIndicatorLevel(report.averagePef.level)
                ),
                ReportsItem.ReportUIModel.Item(
                    title: "total_attacks".localizedFormat(args: report.attacks.value),
                    subtitle: getMessageByIndicatorLevel(report.attacks.level),
                    image: getImageByIndicatorLevel(report.attacks.level)
                )
            ]
            return ReportsItem.report(
                ReportsItem.ReportUIModel(
                    title: getFormattedDateByPeriod(report.period),
                    items: items,
                    isShareEnabled: buddyUserId == nil,
                    onShareTap: {
                        self.getReportCSV(report.period)
                    }
                )
            )
        }
    }

    private func getMessageByIndicatorLevel(_ level: Indicator.Level) -> String {
        switch (level) {
        case .normal:
            return "normal_for_your_condition".localized
        case .alert:
            return "lower_than_your_average".localized
        default:
            fatalError()
        }
    }

    private func getImageByIndicatorLevel(_ level: Indicator.Level) -> UIImage? {
        switch (level) {
        case .normal:
            return UIImage(named: "ic_like")
        case .alert:
            return UIImage(named: "ic_alert")
        default:
            fatalError()
        }
    }

    private func getFormattedDateByPeriod(_ period: Period) -> String {
        switch (period.type) {
        case .day:
            return DateFormatter().apply { $0.dateFormat = "EEEE, d MMMM" }.string(
                from: Date(timeIntervalSince1970: Double(period.startInMillis / 1000))
            )
        case .month:
            return DateFormatter().apply { $0.dateFormat = "MMMM yyyy" }.string(
                from: Date(timeIntervalSince1970: Double(period.startInMillis / 1000))
            )
        case .week:
            let startDate = Date(timeIntervalSince1970: Double(period.startInMillis / 1000))
            let firstDay = Calendar.current.component(.day, from: startDate)

            let endDate = startDate.plusDays(6)
            let lastDay = Calendar.current.component(.day, from: endDate)

            let month = DateFormatter().apply { $0.dateFormat = "MMMM" }.string(from: endDate)
            return "\(firstDay) - \(lastDay) \(month)"
        default:
            fatalError()
        }
    }
}
