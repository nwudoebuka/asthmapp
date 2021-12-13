import UIKit
import common
import CoreLocation
import PKHUD

class HomeViewController : UIViewControllerWithCollapsibleTitle, ReKampStoreSubscriber {
    
    private let tableView = UITableView()
    private let tableAdapter = HomeTableViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }
    
    private func setupView() {
        view.backgroundColor = Palette.whitesmoke
        
        buildViewTree()
        setConstraints()
    }
   
    private func setupTableView() {
        tableView.run {
            $0.backgroundColor = .clear
            $0.delegate = tableAdapter
            $0.dataSource = tableAdapter
            $0.separatorStyle = .none
        }
        
        [CitataionTableViewCell.self,EmergencyTableViewCell.self,TextTableViewCell.self].forEach(tableView.registerForReuse(cellType:))
        
//        [CitataionTableViewCell.self,EmergencyTableViewCell.self, HomeMiscTableViewCell.self, HomeAlertTableViewCell.self,
//         HomeAverageDataTableViewCell.self, HomeAdsTableViewCell.self,
//         HomeStatsTableViewCell.self].forEach(tableView.registerForReuse(cellType:))
        
        tableAdapter.run {
            $0.onEmergencyTap = onEmergencyTap
            $0.onReportsTap = { self.presentModal(ReportsViewController()) }
            $0.onCitationTap = {
                self.presentModal(WebViewController("https://www.blf.org.uk/support-for-you/breathing-tests/tests-measure-oxygen-levels"))
            }
        }
    }
    
    private func onEmergencyTap() {
        EmergencyStarter().start()
    }
    
    private func buildViewTree() {
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.edgesToSuperview()
    }
    
    func onNewState(state: Any) {
        let state = state as! HomeState
        setData(state)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                KotlinBoolean(bool: oldState.home == newState.home)
            }.select { state in
                state.home
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
    
    private func setData(_ state: HomeState) {
        tableAdapter.items = buildItems(state)
        tableView.reloadData()
    }
    
    private func buildItems(_ state: HomeState) -> [HomeItem] {
        // because swift can't compile long expression in reasonable time
//        let items = buildCitattion() + buildEmergencyItem() + buildAlertItem(state) + buildMiscItem(state)
//        let items2 = buildAverageDataItem(state) + buildAdItems(state) + buildStatsItem(state)
        
        let items = buildCitattion() + buildEmergencyItem() + buildWelcomeCell()
        return items
    }
    
}

extension HomeViewController {
    
    private func buildEmergencyItem() -> [HomeItem] {
        [.emergency]
    }
    
    private func buildCitattion() -> [HomeItem] {
        [.citation]
    }
    private func buildWelcomeCell() -> [HomeItem]{
        [.textCell]
    }
    private func buildAlertItem(_ state: HomeState) -> [HomeItem] {
        guard let alert = state.alert else { return [] }
        return [.alert(
            HomeItem.AlertItem(uiModel:
                CardViewWithRightArrow.UIModel(
                    text: alert.title,
                    imageView: UIImage(named: "ic_alert"),
                    color: Palette.ebonyClay,
                    font: Font.body,
                    isActionable: false
                )
            )
        )]
    }
    
    private func buildMiscItem(_ state: HomeState) -> [HomeItem] {
        guard let pef = state.averagePef else { return [] }
        return [.misc(
            .init(
                uiModel: .init(
                    image: UIImage(named: "ic_pef"),
                    smallImage: getImageByIndicatorLevel(pef.level),
                    title: "\(pef.value)",
                    subtitle: "average_pef".localized,
                    measureUnit: "lpm".localized
                )
            )
        )]
    }
    
    private func buildAverageDataItem(_ state: HomeState) -> [HomeItem] {
        guard let pulse = state.averagePulse, let sp02 = state.averageSp02 else { return [] }
        return [.averageData(
            HomeItem.AverageDataItem(
                leftUIModel: AverageDataCardView.UIModel(
                    image: UIImage(named: "ic_heart"),
                    smallImage: getImageByIndicatorLevel(pulse.level),
                    title: String(pulse.value),
                    subtitle: "average_pulse".localized,
                    measureUnit: nil
                ),
                rightUIModel: AverageDataCardView.UIModel(
                    image: UIImage(named: "ic_sp02"),
                    smallImage: getImageByIndicatorLevel(sp02.level),
                    title: "\(sp02.value)",
                    subtitle: "average_sp02".localized,
                    measureUnit: "%"
                )
            )
        )]
    }
    
    private func getImageByIndicatorLevel(_ level: Indicator.Level) -> UIImage? {
        switch(level) {
        case .normal:
            return UIImage(named: "ic_like")
        case .alert:
            return UIImage(named: "ic_alert")
        default:
            return nil
        }
    }
    
    private func buildAdItems(_ state: HomeState) -> [HomeItem] {
        
        let uiModels = state.ads.map {
            HomeAdCollectionViewCell.UIModel(
                imagePath: $0.imagePath,
                title: $0.title,
                oldPrice: $0.oldPrice,
                newPrice: $0.newPrice,
                link: $0.link
            )
        }
        return [HomeItem.ads(HomeItem.AdsItem(
            uiModels: uiModels,
            onTap: { link in
                self.presentModal(WebViewController(link))
            }
        ))]
    }
    
    private func buildStatsItem(_ state: HomeState) -> [HomeItem] {
        guard let stats = state.stats else { return [] }
        return [.stats(
            HomeItem.StatsItem(
                title: "puffs_count".localized,
                period: "last_4_weeks".localized,
                weeklyPuffs: stats.weeklyPuffs.map { $0.intValue },
                preventerInhaler: Int(stats.preventerInhaler),
                relieverInhaler: Int(stats.relieverInhaler),
                combinationInhaler: Int(stats.combinationInhaler)
            )
        )]
    }
}
