//
//  HistoryViewController.swift
//  App_0001
//
//  Created by Er Baghdasaryan on 04.12.24.
//

import UIKit
import AppViewModel
import SnapKit
import SDWebImage
import AVFoundation

class HistoryViewController: BaseViewController, UICollectionViewDelegate {

    var viewModel: ViewModel?

    var collectionView: UICollectionView!
    private let userImage = UIImageView()
    private let nameLabel = UILabel(text: "",
                                    textColor: .white,
                                    font: UIFont(name: "SFProText-Semibold", size: 15))
    private let hoursLabel = UILabel(text: "",
                                     textColor: .white,
                                     font: UIFont(name: "SFProText-Regular", size: 15))
    private let pageControl = AdvancedPageControlView()
    private let closeButton = UIButton(type: .system)
    private var currentIndex: Int = 0

    private var autoScrollTimer: Timer?
    private var currentPlayer: AVPlayer?

    private let addToArchive = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
        setupAutoScrollTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = false

        guard let user = self.viewModel?.user else { return }
        self.userImage.image = user.avatar
        self.nameLabel.text = user.name
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        autoScrollTimer?.invalidate()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = UIColor(hex: "#111111")

        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = 21
        self.userImage.contentMode = .scaleAspectFill

        self.nameLabel.textAlignment = .left
        self.hoursLabel.textAlignment = .left

        let mylayout = UICollectionViewFlowLayout()
        mylayout.itemSize = sizeForItem()
        mylayout.scrollDirection = .horizontal
        mylayout.minimumLineSpacing = 0
        mylayout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: mylayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(StoryCell.self)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self

        self.closeButton.setImage(.init(named: "storyClose"), for: .normal)

        pageControl.setPage(0)

        self.addToArchive.setTitle("Add to archive", for: .normal)
        self.addToArchive.setTitleColor(.black, for: .normal)
        self.addToArchive.backgroundColor = .white
        self.addToArchive.layer.masksToBounds = true
        self.addToArchive.layer.cornerRadius = 23

        self.view.addSubview(collectionView)
        self.view.addSubview(pageControl)
        self.view.addSubview(userImage)
        self.view.addSubview(nameLabel)
        self.view.addSubview(hoursLabel)
        self.view.addSubview(closeButton)
        self.view.addSubview(addToArchive)
        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
        let pageCount = self.viewModel?.stories.count
        let spacing = 4 * (pageCount ?? 1)
        let totalSpacing = 24 + spacing
        let drowWidth = (Int(self.view.frame.size.width) - totalSpacing) / (pageCount ?? 1)
        pageControl.drawer = ExtendedDotDrawer(numberOfPages: pageCount,
                                               height: 3,
                                               width: CGFloat(drowWidth),
                                               space: 4,
                                               indicatorColor: UIColor.white,
                                               dotsColor: UIColor.white.withAlphaComponent(0.4),
                                               isBordered: true,
                                               borderWidth: 0.0,
                                               indicatorBorderColor: .orange,
                                               indicatorBorderWidth: 0.0)
    }

    func sizeForItem() -> CGSize {
        let deviceType = UIDevice.currentDeviceType

        switch deviceType {
        case .iPhone:
            let width = self.view.frame.size.width
            let heightt = self.view.frame.size.height - 107
            return CGSize(width: width, height: heightt)
        case .iPad:
            let scaleFactor: CGFloat = 1.5
            let width = 550 * scaleFactor
            let height = 1100 * scaleFactor
            return CGSize(width: width, height: height)
        }
    }

    func setupConstraints() {

        collectionView.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
            view.bottom.equalToSuperview().inset(107)
        }

        pageControl.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(64)
            view.leading.equalToSuperview().offset(12)
            view.trailing.equalToSuperview().inset(12)
            view.height.equalTo(4)
        }

        userImage.snp.makeConstraints { view in
            view.top.equalTo(pageControl.snp.bottom).offset(12)
            view.leading.equalToSuperview().offset(16)
            view.width.equalTo(42)
            view.height.equalTo(42)
        }

        nameLabel.snp.makeConstraints { view in
            view.top.equalTo(userImage.snp.top).offset(11)
            view.leading.equalTo(userImage.snp.trailing).offset(12)
            view.height.equalTo(20)
        }

        hoursLabel.snp.makeConstraints { view in
            view.top.equalTo(nameLabel.snp.top)
            view.leading.equalTo(nameLabel.snp.trailing).offset(8)
            view.height.equalTo(20)
        }

        closeButton.snp.makeConstraints { view in
            view.top.equalTo(pageControl.snp.bottom).offset(20)
            view.trailing.equalToSuperview().inset(16)
            view.width.equalTo(25)
            view.height.equalTo(29)
        }

        addToArchive.snp.makeConstraints { view in
            view.bottom.equalToSuperview().inset(37)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(46)
        }
    }

}

//MARK: Make buttons actions
extension HistoryViewController {
    
    private func makeButtonsAction() {
        closeButton.addTarget(self, action: #selector(closeStories), for: .touchUpInside)
    }

    @objc func closeStories() {
        guard let navigationController = self.navigationController else { return }

        currentPlayer?.pause()
        currentPlayer = nil

        AddUserRouter.popViewController(in: navigationController)
    }

    private func observeVideoEnd(for player: AVPlayer?) {
        guard let player = player else { return }

        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)

        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    @objc private func videoDidEnd(_ notification: Notification) {
        scrollToNextItem()
    }

    private func setupAutoScrollTimer() {
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollToNextItemIfNeeded), userInfo: nil, repeats: true)
    }

    @objc private func scrollToNextItemIfNeeded() {
        if currentPlayer == nil || currentPlayer?.currentItem == nil {
            scrollToNextItem()
        }
    }

    @objc private func scrollToNextItem() {
        guard let numberOfItems = self.viewModel?.stories.count else { return }

        let nextIndex = currentIndex + 1
        if nextIndex < numberOfItems {
            let nextIndexPath = IndexPath(item: nextIndex, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            currentIndex = nextIndex
            self.pageControl.setPage(nextIndex)
        } else {
            autoScrollTimer?.invalidate()
            handleEndOfStories()
        }
    }
    
    private func handleEndOfStories() {
        guard let navigationController = self.navigationController else { return }
        AddUserRouter.popViewController(in: navigationController)
    }

    private func fetchImageUsingSDWebImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        SDWebImageManager.shared.loadImage(
            with: url,
            options: .highPriority,
            progress: nil
        ) { image, data, error, cacheType, finished, imageURL in
            if let error = error {
                print("Failed to fetch image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            completion(image)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleItems = collectionView.indexPathsForVisibleItems.sorted()
        if let visibleItem = visibleItems.first {
            currentIndex = visibleItem.item
        }
    }
}

extension HistoryViewController: IViewModelableController {
    typealias ViewModel = IHistoryViewModel
}

extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel?.stories.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StoryCell = collectionView.dequeueReusableCell(for: indexPath)
        let model = self.viewModel?.stories[indexPath.row]

        currentPlayer?.pause()
        currentPlayer = nil

        if model?.videoDownloadUrl == nil {
            let imageURL = model?.imageDownloadUrl
            self.hoursLabel.text = model?.sinceStr.replacingOccurrences(of: "before", with: "")
            self.fetchImageUsingSDWebImage(from: imageURL!) { image in
                if let image = image {

                    cell.setup(image: image)
                } else {
                    print("Failed to fetch image")
                }
            }
        } else if let videoURLString = model?.videoDownloadUrl,
                    let videoURL = URL(string: videoURLString) {
            cell.setupVideo(url: videoURL)
            self.hoursLabel.text = model?.sinceStr.replacingOccurrences(of: "before", with: "")
            currentPlayer = cell.player
            currentPlayer?.play()

            observeVideoEnd(for: currentPlayer)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem()
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let storyCell = cell as? StoryCell {
            storyCell.player?.pause()
            if currentPlayer == storyCell.player {
                currentPlayer = nil
            }
        }
    }
}

//MARK: Preview
import SwiftUI

struct HistoryViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let historyViewController = HistoryViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<HistoryViewControllerProvider.ContainerView>) -> HistoryViewController {
            return historyViewController
        }

        func updateUIViewController(_ uiViewController: HistoryViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<HistoryViewControllerProvider.ContainerView>) {
        }
    }
}
