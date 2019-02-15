//
//  DashboardVC.swift
//  NYTimesSample
//
//  Created by Ersin Gürsu on 15.02.2019.
//  Copyright © 2019 Ersin Gürsu. All rights reserved.
//

import UIKit



class DashboardVC: BaseVC {
private let refreshControl = UIRefreshControl()
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var lblNoData: UILabel! 
    
    var newsLoaded = {() -> () in }
    
    var selectedItem = {(_ item:Result) -> () in }
    
    fileprivate var nyTimesNews: Welcome?{
        didSet{
            filteredNews = nyTimesNews?.results
        }
    }
    
    fileprivate var filteredNews : [Result]?{
        didSet{
            newsLoaded()
        }
    }
    
    func hasNews()->Bool{
        
        guard let filtered = filteredNews else { return false }
        return filtered.count != 0
    }
    
    deinit {
        print("DashboardVC deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func rightItemMorePressed() {
        super.rightItemMorePressed()
         print("RightItemMorePressed")
    }
    
    override func leftItemAction() {
        super.leftItemAction()
        print("LeftItemAction")
    }
}

extension DashboardVC {
    
    fileprivate func setupUI()
    {
        self.viewBackgroundColor = Theme.Colors.backgroundLight.color
        self.titleText = "NY Times Most Popular"
        self.viewBackgroundColor = Theme.Colors.backgroundLight.color
        self.rightButtonItemList = [.more,.search]
        
        newsLoaded = { [weak self] in
            DispatchQueue.main.async {
                
                self?.tableReload()
               
            } 
        }
        
        selectedItem = { [weak self] (item) in
            DispatchQueue.main.async {
                
                let vc = ArticleDetailVC.instantiate()
                vc.model = item
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        setupTableView()
        loadNews()
    }
    
    private func tableReload(){
        
        DispatchQueue.main.async {
            self.lblNoData.isHidden = self.hasNews()
            self.tableView.isHidden = !self.hasNews()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    private func setupTableView()
    {
        tableView.backgroundColor = Theme.Colors.backgroundLight.color
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 131
        tableView.rowHeight = UITableView.automaticDimension
        let nib = UINib(nibName: "NYTNewsItemCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NYTNewsItemCell")
    }
    
    @objc private func refreshData(_ sender: Any) {
         
        loadNews()
    }
    
    @IBAction func continueClicked(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DashboardVC: StoryboardInstantiable {
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "DashboardVC" }
}


extension DashboardVC {
    
    override func navigationSearchBarTextChange(_ searchText: String?) {
    
        search(searchText)
        
    }
    
    override func navigationSearchBarEndEditing(){
        super.navigationSearchBarEndEditing()
        search("")
    }
}

extension DashboardVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let _ = nyTimesNews else { return 0 }
        return filteredNews!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = filteredNews![indexPath.row]
        
        let cell:NYTNewsItemCell = tableView.dequeueReusableCell(withIdentifier: "NYTNewsItemCell") as! NYTNewsItemCell
        cell.update(item)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: NYTNewsItemCell = tableView.cellForRow(at: indexPath) as! NYTNewsItemCell
        
        selectedItem(cell.newsModel)
    }
    
    func reload(_ tableView:UITableView, at index:IndexPath) {
        tableView.reloadRows(at: [index], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DashboardVC {
    
    func search(_ text : String?){
        
        guard let welcome = nyTimesNews else { return  }
        
        if (text ?? "").isEmpty{
            filteredNews = welcome.results
            return
        }
        
        filteredNews = welcome.results.filter {$0.title.contains(text!)}
    }
    
}

extension DashboardVC {
    
    func loadNews()
    {
        Network.instance.request(params: [:], section: "all-sections", dayType: "30") { [weak self] (response : Welcome) in
            self?.nyTimesNews = response
        }
        
    }
    
}
