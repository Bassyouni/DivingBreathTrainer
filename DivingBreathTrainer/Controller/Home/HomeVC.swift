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
    
    lazy var percentageLabel: CustomLabel = {
        let label = CustomLabel(fontSize: 40)
        label.text = "Start"
        return label
    }()
    
    lazy var progressLabel: CustomLabel = {
        let label = CustomLabel(fontSize: 22)
        label.text = "Downloading"
        label.isHidden = true
        return label
    }()
    
    lazy var contractionButton: CircleImageButton = {
        let button = CircleImageButton(image: #imageLiteral(resourceName: "lungs"), backgroundColor: .trackStrokeColor)
        button.addTarget(self, action: #selector(contractionBtnPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var startButton: CircleImageButton = {
        let button = CircleImageButton(image: #imageLiteral(resourceName: "start"), backgroundColor: UIColor(red: 243/255, green: 110/255, blue: 93/255, alpha: 1) )
        button.addTarget(self, action: #selector(startBtnPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    var tableView: UITableView!
    
    //MARK:- variables
    let viewModel = HomeViewModel()
    let holdString = "Hold"
    let breatheString = "Breathe"
    let readyString = "Get Ready"
    var progressString = "Start"
    
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
        
        viewModel.delegate = self
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
    @objc private func contractionBtnPressed(_ sender: UIButton) {
        if !viewModel.isInReadyRound {
            if !viewModel.hasContractedInRound {
                pauseLayer(layer: shapLayer)
                synthesizeSpeech(formString: "contractions started after \(viewModel.total - viewModel.count) seconds")
                viewModel.hasContractedInRound = true
            }
        }
    }
    
    @objc private func startBtnPressed(_ sender: UIButton) {
        //TODO: handle pause situations
        //add pause image
            startReadyRound()
    }
    
    //MARK:- methods
    func startReadyRound() {
        viewModel.startRound()
        self.percentageLabel.text = "\(self.viewModel.count.getStringTimeFormat())"
        progressString = readyString
        self.progressLabel.text = progressString
        self.progressLabel.isHidden = false
        synthesizeSpeech(formString: readyString)
        
        shapLayer.strokeEnd = 0
        contractionLayer.strokeEnd = 0
        let animation = getStrokeAnimation()
        shapLayer.add(animation, forKey: "shapeLayer")
        contractionLayer.add(animation, forKey: "contractionLayer")
    }
    
    func startHoldRound() {
        self.percentageLabel.text = "\(self.viewModel.count.getStringTimeFormat())"
        progressString = holdString
        self.progressLabel.text = progressString
        synthesizeSpeech(formString: holdString)
        
        shapLayer.strokeEnd = 0
        contractionLayer.strokeEnd = 0
        let animation = getStrokeAnimation()
        shapLayer.add(animation, forKey: "shapeLayer")
        contractionLayer.add(animation, forKey: "contractionLayer")
    }
    
    func startBreathRound() {
        self.percentageLabel.text = "\(self.viewModel.count.getStringTimeFormat())"
        progressString = breatheString
        self.progressLabel.text = progressString
        synthesizeSpeech(formString: breatheString)
        
        shapLayer.strokeEnd = 0
        contractionLayer.strokeEnd = 0
        let animation = getStrokeAnimation()
        shapLayer.add(animation, forKey: "shapeLayer")
        contractionLayer.add(animation, forKey: "contractionLayer")
    }
    
    func handleTimer(forState state: TrainingState) {
        
        switch state {
        case .ready:
            progressString = readyString
        case .hold:
            progressString = holdString
        case .breathe:
            progressString = breatheString
        }
        
        if viewModel.count == 0 {
            
        }
        else if viewModel.count <= 3
        {
            synthesizeSpeech(formString: "\(viewModel.count)")
        }
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(self.viewModel.count.getStringTimeFormat())"
            self.progressLabel.text = self.progressString
        }
        
    }
    
    // MARK: - helper methods
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
    }
    
    fileprivate func configureCircles() {
        animatingLayer = createTrackLayer(strokeColor: .clear, fillColor: .pulsatingFillColor)
        animatingLayer.position = topView.center
        topView.layer.addSublayer(animatingLayer)
        
        //create trackLayer
        // it must be added before the shapeLayer
        // so it can be in the background and the animation happens over it
        trackLayer = createTrackLayer(strokeColor: .trackStrokeColor  , fillColor: .backgroundColor)
        trackLayer.position = topView.center
        topView.layer.addSublayer(trackLayer)
        
        
        contractionLayer = createTrackLayer(strokeColor: .red, fillColor: .clear)
        contractionLayer.position = topView.center
        contractionLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        contractionLayer.strokeEnd = 0
        topView.layer.addSublayer(contractionLayer)
        
        //main circle the actuly macke progress
        shapLayer = createTrackLayer(strokeColor: .white , fillColor: .clear)
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
        percentageLabel.centerInSuperview(size: CGSize(width: 120.0, height: 100.0),yConstant: -15)
        
        topView.addSubview(progressLabel)
        progressLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 100)
        progressLabel.center.x = topView.center.x
        progressLabel.center.y = topView.center.y + 20
    }
    
    fileprivate func configureButtons() {
        topView.addSubview(contractionButton)
        topView.addSubview(startButton)
        let btnWidth = CircleImageButton.btnWidth
        contractionButton.anchor(top: nil, leading: topView.leadingAnchor, bottom: topView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 15, right: 0), size: CGSize(width: btnWidth, height: btnWidth))
        
        startButton.anchor(top: nil, leading: nil, bottom: topView.bottomAnchor, trailing: topView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 10), size: CGSize(width: btnWidth, height: btnWidth))
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
        tableView.allowsSelection = false
    }

}

// MARK: - circle logic
extension HomeVC
{
    func createTrackLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        return CircleModel.createTrackLayer(strokeColor: strokeColor, fillColor: fillColor)
    }
    
    func getStrokeAnimation() -> CABasicAnimation {
        return CircleModel.animateStroke(duration: CFTimeInterval(viewModel.total))
    }
    
    func pauseLayer(layer: CALayer) {
        CircleModel.pauseLayer(layer: layer)
    }
}

//MARK: - table
extension HomeVC: UITableViewDelegate, UITableViewDataSource
{
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

extension HomeVC: HomeViewModelDelegate {
    
    func didBeginHoldRound() {
        startHoldRound()
    }
    
    func didBeginBreatheRound() {
        startBreathRound()
    }
    
    func handelTimerRound(forState state: TrainingState) {
        handleTimer(forState: state)
    }
    
    func didFinishTraining() {
        //TODO: handel finish state
    }
    
}
