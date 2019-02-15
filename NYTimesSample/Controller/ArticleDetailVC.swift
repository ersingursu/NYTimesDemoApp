//
//  ArticleDetailVC.swift
//  NYTimesSample
//
//  Created by Ersin Gürsu on 15.02.2019.
//  Copyright © 2019 Ersin Gürsu. All rights reserved.
//

import UIKit

class ArticleDetailVC: BaseVC {

    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var imgArticle: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var abstractText: UILabel!
    
    var model:Result?{
        didSet{
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        self.titleText = "NY Times Most Popular"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func updateUI(){
        if model != nil && articleTitle != nil{
            setAuthor(_author: model?.byline)
            setCaption(_caption: model?.media[0].caption)
            setArticleTitle(title: model?.title)
            setPublishDate(publish: model?.publishedDate)
            setAbstractText(abstract: model?.abstract)
            setArticleImage(imgUrlStr: model?.media[0].mediaMetadata[0].url)
        }
    }
    
    @IBAction func full(_ sender: Any) {
        UIApplication.shared.open(URL.init(string: model!.url)!, options: [:]) { (val) in
            
        }
    }
    func setArticleTitle(title: String?){
        if let titleStr = title{
            articleTitle.text = titleStr
        }
    }
    
    func setCaption(_caption: String?){
        if let captionStr = _caption{
            caption.text = captionStr
        }
    }
    
    func setAuthor(_author: String?){
        if let authorStr = _author{
            author.text = authorStr
        }
    }
    
    func setPublishDate(publish: String?){
        if let publishStr = publish{
            publishDate.text = publishStr
        }
    }
    
    func setAbstractText(abstract: String?){
        if let abstractStr = abstract{
            abstractText.text = abstractStr
        }
    }
    
    func setArticleImage(imgUrlStr: String?){
        guard let urlStr = imgUrlStr else {
            return
        }
        
        let _url = URL(string: urlStr)!
        loadImage(url: _url)
    }
    
    func loadImage(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imgArticle.image = image
                    }
                }
            }
        }
    }

}

extension ArticleDetailVC: StoryboardInstantiable {
    static var storyboardName: String { return "ArticleDetail" }
    static var storyboardIdentifier: String? { return "ArticleDetailVC" }
}
