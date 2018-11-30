//
//  HomeVC.swift
//  DivingBreathTrainer
//
//  Created by MacBook Pro on 11/30/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit
import AVFoundation

class HomeVC: UIViewController {
    
    //MARK:- UI variables
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var percentageLabel:UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var progressLabel:UILabel = {
        let label = UILabel()
        label.text = "Downloading"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.white
        label.isHidden = true
        return label
    }()
    
    lazy var contractionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("!", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 30)
        btn.backgroundColor = .trackStrokeColor
        btn.layer.cornerRadius = btnWidth / 2.0
        btn.addTarget(self, action: #selector(contractionBtnPressed(_:)), for: .touchUpInside)
        return btn
    }()
    
    var tableView: UITableView!
    
    //MARK:- variables
    let viewModel = HomeViewModel()
    
    let btnWidth: CGFloat = 65
    
    var shapLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    var contractionLayer: CAShapeLayer!
    var animatingLayer: CAShapeLayer!
    
    var speechSynthesier = AVSpeechSynthesizer()
    
    
    //MARK:- view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTopView()
        
        configureTableView()
        
        speechSynthesier.delegate = self
        
        //this is beacause when the app goes to the background it stopes animating
        //so every time the app comes back the foreground w activate the animation again
        //        NotificationCenter.default.addObserver(self, selector: #selector(animateCircle), name: UIApplication.willEnterForegroundNotification , object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        configureButtons()
        
        configureCircles()
        
        configureLabels()
    }
    
    
    //MARK:- helper methods
    
    
    //MARK:- actions
    @objc func handleTap() {
        startHoldBreathAnimation()
    }
    
    @objc private func contractionBtnPressed(_ sender: UIButton) {
            viewModel.pauseLayer(layer: shapLayer)
        synthesizeSpeech(formString: "weak little bitch!")
    }
    
    
    //MARK:- methods
    func startHoldBreathAnimation() {
        viewModel.timer.invalidate()
        viewModel.count = 10
        shapLayer.strokeEnd = 0
        viewModel.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        self.percentageLabel.text = "\(self.viewModel.count)"
        synthesizeSpeech(formString: "breathe you little shit")
        
        let animation = viewModel.getStrokeAnimation()
        shapLayer.add(animation, forKey: "shapeLayer")
        contractionLayer.add(animation, forKey: "contractionLayer")
    }
    
    @objc func handleTimer() {
        
        viewModel.count -= 1
        if viewModel.count == 0
        {
            synthesizeSpeech(formString: "Hold it in for ever")
            viewModel.timer.invalidate()
        }
        else if viewModel.count <= 3
        {
            synthesizeSpeech(formString: "\(viewModel.count)")
        }
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(self.viewModel.count)"
        }
        
    }
    
    func synthesizeSpeech(formString string: String)
    {
        let speechUtterance = AVSpeechUtterance(string: string)
        speechSynthesier.speak(speechUtterance)
    }
    
   
}

//MARK: - initalization
extension HomeVC
{
    fileprivate func configureTopView() {
        view.addSubview(topView)
        
        topView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor)
        topView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2).isActive = true
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    fileprivate func configureCircles() {
        animatingLayer = viewModel.createTrackLayer(strokeColor: .clear, fillColor: .pulsatingFillColor)
        animatingLayer.position = topView.center
        topView.layer.addSublayer(animatingLayer)
        
        
        //create trackLayer
        // it must be added before the shapeLayer
        // so it can be in the background and the animation happens over it
        trackLayer = viewModel.createTrackLayer(strokeColor: .trackStrokeColor  , fillColor: .backgroundColor)
        trackLayer.position = topView.center
        topView.layer.addSublayer(trackLayer)
        
        
        contractionLayer = viewModel.createTrackLayer(strokeColor: .red, fillColor: .clear)
        contractionLayer.position = topView.center
        contractionLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        contractionLayer.strokeEnd = 0
        topView.layer.addSublayer(contractionLayer)
        
        //main circle the actuly macke progress
        shapLayer = viewModel.createTrackLayer(strokeColor: .white , fillColor: .clear)
        shapLayer.position = topView.center
        
        //this is to rotate the cirlce to - 90 degree
        shapLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        //this remove or make the stroke disappear
        shapLayer.strokeEnd = 0
        
        topView.layer.addSublayer(shapLayer)
    }
    
    fileprivate func configureLabels() {
        topView.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 120, height: 100)
        percentageLabel.centerInSuperview(size: CGSize(width: 120.0, height: 100.0))
        
        topView.addSubview(progressLabel)
        progressLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 100)
        progressLabel.center.x = topView.center.x
        progressLabel.center.y = topView.center.y + 10
    }
    
    fileprivate func configureButtons() {
        topView.addSubview(contractionBtn)
        contractionBtn.anchor(top: nil, leading: topView.leadingAnchor, bottom: topView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 15, right: 0), size: CGSize(width: btnWidth, height: btnWidth))
    }
    
    fileprivate func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.anchor(top: topView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        tableView.register(UINib(nibName: O2TableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: O2TableViewCell.cellIdentifier)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
    }

}

//MARK: - table
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSoruce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = viewModel.dataSoruce[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath) as? O2TableViewCell
        {
            cell.viewModel = cellViewModel
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension HomeVC: AVSpeechSynthesizerDelegate {
    
}
