import UIKit
import common
import PKHUD

class LearnViewController : UIViewControllerWithCollapsibleTitle, ReKampStoreSubscriber {
    
    private let tableView = UITableView()
    private let tableAdapter = LearnTableViewAdapter()

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
        
        [EmergencyTableViewCell.self, LearnVideoTableViewCell.self,
         LearnArticleTableViewCell.self, LearnSearchTableViewCell.self].forEach {
            tableView.registerForReuse(cellType: $0)
         }
        tableAdapter.run {
            $0.onTap = { link in
                self.presentModal(WebViewController(link))
            }
            $0.onEmergencyTap = onEmergencyTap
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
        let state = state as! LearnState
        
        tableAdapter.items = [[LearnNewsItem.emergency, LearnNewsItem.search], state.filteredNews.toNewsItems()]
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(subscriber: self) { subscription in
            subscription.skipRepeats { oldState, newState in
                KotlinBoolean(bool: oldState.learn == newState.learn)
            }.select { state in
                state.learn
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(subscriber: self)
    }
}

fileprivate extension Array where Element == LearnNews {
    
    func toNewsItems() -> [LearnNewsItem] {
        compactMap {
            switch($0) {
            case let article as LearnNews.Article:
                return LearnNewsItem.article(LearnNewsItem.Article(article))
            case let video as LearnNews.Video:
                return LearnNewsItem.video(LearnNewsItem.Video(video))
            default:
                return nil
            }
        }
    }
}
