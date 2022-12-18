//
//  AssetDetailViewController.swift
//  OpenSeaCollectionProject
//
//  Created by Polo on 2022/12/15.
//

import Foundation
import UIKit
import Combine
import Kingfisher

class AssetDetailViewController: UIViewController {
    
    var viewDidDisappear = PassthroughSubject<Void, Never>()
    
    @IBOutlet weak var itemImageView: UIImageView! {
        didSet {
            itemImageView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    
    private var viewModel: AssetDetailViewModel
    private var cancellable = Set<AnyCancellable>()
    
    init(with viewModel: AssetDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
    }
    
    private func setupUI(){
        
        let asset = viewModel.assets
        
        func setupImageView() {
            if let urlString = asset.imageURL, let url = URL(string: urlString)  {
                if url.isSVGPath {
                    itemImageView.setSVGImage(with: url)
                }else {
                    itemImageView.kf.setImage(with: url)
                }
            }else {
                itemImageView.backgroundColor = .lightGray
            }
        }
        
        setupImageView()
        nameLabel.text = asset.name
        descriptionLabel.text = asset.assetDescription
        linkButton.setTitle(asset.permalink, for: .normal)
        title = asset.collection.name
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappear.send()
    }
    
    @IBAction func onClickURL() {
        let urlString = viewModel.assets.permalink
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    deinit{
        print("deinit")
    }
    
}
