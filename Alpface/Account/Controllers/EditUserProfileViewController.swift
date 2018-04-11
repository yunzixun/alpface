//
//  EditUserProfileViewController.swift
//  Alpface
//
//  Created by swae on 2018/4/10.
//  Copyright © 2018年 alpface. All rights reserved.
//

import UIKit

class EditUserProfileViewController: UIViewController {
    
    let EditProfileTableViewCellIdentifier: String = "EditProfileTableViewCell"
    
    fileprivate var editProfileItems: [EditUserProfileModel] = []
    
    public var user: User?
    
    fileprivate lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: self.view.bounds, style: .plain)
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.showsHorizontalScrollIndicator = false
        _tableView.backgroundColor = UIColor.white
        _tableView.separatorStyle = .none
        _tableView.scrollsToTop = true
        _tableView.keyboardDismissMode = .onDrag
        _tableView.register(EditProfileTableViewCell.classForCoder(), forCellReuseIdentifier: EditProfileTableViewCellIdentifier)
        return _tableView
    }()
    
    open lazy var profileHeaderView: EditProfileHeaderView = {
        let _profileHeaderView = EditProfileHeaderView(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 55.0))
        return _profileHeaderView
    }()
    
    /// 下拉头部放大控件 (头部背景视图)
    fileprivate lazy var stickyHeaderContainerView: StickyHeaderContainerView = {
        let _stickyHeaderContainer = StickyHeaderContainerView()
        return _stickyHeaderContainer
    }()
    
    fileprivate lazy var tableHeaderView: UIView = {
        let view = UIView()
        return view
    }()
    
    open lazy var navigationTitleLabel: UILabel = {
        let _navigationTitleLabel = UILabel()
        _navigationTitleLabel.text = "username"
        _navigationTitleLabel.textColor = UIColor.white
        _navigationTitleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        return _navigationTitleLabel
    }()
    
    /// 头部描述用户信息视图的高度(不固定值)
    open var profileHeaderViewHeight: CGFloat = 160
    /// 头部背景视图最小的高度(固定值)
    open let navigationMinHeight : CGFloat = 65.0
    open var navigationTitleLabelBottomConstraint : NSLayoutConstraint?
    open let bouncingThreshold: CGFloat = 100
    /// scrollView 向上滚动时时，固定头部背景视图，此属性为scrollView滚动到contentView.y==这个偏移量时，就固定头部背景视图，将其作为当导航条展示 (固定值)
    open func scrollToScaleDownProfileIconDistance() -> CGFloat {
        return stickyheaderContainerViewHeight - navigationMinHeight
    }
    
    convenience init(user: User) {
        self.init()
        self.user = user
    }
    
    
    /// 更新table header 布局，高度是计算出来的，所以当header上的内容发生改变时，应该执行一次更新header布局
    fileprivate var needsUpdateHeaderLayout = false
    open func setNeedsUpdateHeaderLayout() {
        self.needsUpdateHeaderLayout = true
    }
    open func updateHeaderLayoutIfNeeded() {
        if self.needsUpdateHeaderLayout == true {
            self.profileHeaderViewHeight = profileHeaderView.sizeThatFits(self.tableView.bounds.size).height
            
            /// 只要第一次view布局完成时，再调整下stickyHeaderContainerView的frame，剩余的情况会在scrollViewDidScrollView:时调整
            self.stickyHeaderContainerView.frame = self.computeStickyHeaderContainerViewFrame()
            
            
            /// 更新profileHeaderView和segmentedControlContainer的frame
            self.profileHeaderView.frame = self.computeProfileHeaderViewFrame()
            
            tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: 0, height: stickyHeaderContainerView.frame.height + profileHeaderView.frame.size.height)
            self.tableView.tableHeaderView = tableHeaderView
            profileHeaderView.frame = self.computeProfileHeaderViewFrame()
            self.needsUpdateHeaderLayout = false
        }
    }
    
    func computeStickyHeaderContainerViewFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: tableView.bounds.width, height: stickyheaderContainerViewHeight)
    }
    
    func computeProfileHeaderViewFrame() -> CGRect {
        return CGRect(x: 0, y: computeStickyHeaderContainerViewFrame().origin.y + stickyheaderContainerViewHeight, width: tableView.bounds.width, height: profileHeaderViewHeight)
    }
    
    func computeNavigationFrame() -> CGRect {
        let navigationHeight:CGFloat = max(stickyHeaderContainerView.frame.origin.y - self.tableView.contentOffset.y + stickyHeaderContainerView.bounds.height, navigationMinHeight)
        
        let navigationLocation = CGRect(x: 0, y: 0, width: stickyHeaderContainerView.bounds.width, height: navigationHeight)
        return navigationLocation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupItems()
        self.prepareViews()
    }
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateHeaderLayoutIfNeeded()
    }
    
    @objc fileprivate func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension EditUserProfileViewController {
    
    fileprivate func setupItems() -> Void {
        let item1 = EditUserProfileModel(title: "姓名", content: self.user?.nickname, placeholder: "添加你的姓名")
        let item2 = EditUserProfileModel(title: "简介", content: self.user?.summary, placeholder: "在你的个人资料中添加简介", type: .textFieldMultiLine)
        let item3 = EditUserProfileModel(title: "位置", content: self.user?.address, placeholder: "添加你的位置")
        let item4 = EditUserProfileModel(title: "生日", content: nil, placeholder: "选择你的生日", type: .dateTime)
        editProfileItems.append(item1)
        editProfileItems.append(item2)
        editProfileItems.append(item3)
        editProfileItems.append(item4)
    }
    
    fileprivate func prepareViews() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(backAction))
        self.navigationItem.title = "编辑个人资料"
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(update))
        
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        tableHeaderView.addSubview(stickyHeaderContainerView)
        tableHeaderView.addSubview(profileHeaderView)
        
        tableView.tableHeaderView = tableHeaderView
        
        
        // 导航标题
        stickyHeaderContainerView.addSubview(navigationTitleLabel)
        navigationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationTitleLabel.centerXAnchor.constraint(equalTo: stickyHeaderContainerView.centerXAnchor).isActive = true
        navigationTitleLabelBottomConstraint = navigationTitleLabel.bottomAnchor.constraint(equalTo: stickyHeaderContainerView.bottomAnchor, constant: -ALPNavigationTitleLabelBottomPadding)
        navigationTitleLabelBottomConstraint?.isActive = true
        
        
        // 设置进度为0时的导航条标题和导航条详情label的位置 (此时标题和详情label 在headerView的最下面隐藏)
        animateNaivationTitleAt(progress: 0.0)
        setNeedsUpdateHeaderLayout()
    }
    
}

extension EditUserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   

    }
    
    /// scrollView滚动时调用
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isEqual(self.tableView) == false {
            return
        }
        let contentOffset = scrollView.contentOffset
        let autoOffsetTop : CGFloat = 64.0
        // 当向下滚动时，固定头部视图
        if contentOffset.y <= -autoOffsetTop {
            let bounceProgress = min(1, abs(contentOffset.y+autoOffsetTop) / bouncingThreshold)
            
            let newHeight = abs(contentOffset.y+autoOffsetTop) + stickyheaderContainerViewHeight

            // 调整 stickyHeader 的 frame
            self.stickyHeaderContainerView.frame = CGRect(
                x: 0,
                y: contentOffset.y+autoOffsetTop,
                width: tableView.bounds.width,
                height: newHeight)
            
            // 更新blurEffectView的透明度
            self.stickyHeaderContainerView.blurEffectView.alpha = min(1, bounceProgress * 2)
            
            // 更新headerCoverView的缩放比例
            let scalingFactor = 1 + min(log(bounceProgress + 1), 2)
            //      print(scalingFactor)
            self.stickyHeaderContainerView.headerCoverView.transform = CGAffineTransform(scaleX: scalingFactor, y: scalingFactor)
            
        } else {
            
            self.stickyHeaderContainerView.blurEffectView.alpha = 0
        }
        
        // 普通情况时，适用于contentOffset.y改变时的更新
        let scaleProgress = max(0, min(1, (contentOffset.y + 64) / self.scrollToScaleDownProfileIconDistance()))
        self.profileHeaderView.animator(t: scaleProgress)
        
        if contentOffset.y > -autoOffsetTop {
            
            // 当scrollView滚动到达阈值时scrollToScaleDownProfileIconDistance
            if contentOffset.y >= scrollToScaleDownProfileIconDistance() {
                self.stickyHeaderContainerView.frame = CGRect(x: 0, y: contentOffset.y - scrollToScaleDownProfileIconDistance(), width: tableView.bounds.width, height: stickyheaderContainerViewHeight)
                // 当scrollView 的 segment顶部 滚动到scrollToScaleDownProfileIconDistance时(也就是导航底部及以上位置)，让stickyHeaderContainerView显示在最上面，防止被profileHeaderView遮挡
                tableHeaderView.bringSubview(toFront: self.stickyHeaderContainerView)
                
            } else {
                // 当scrollView 的 segment顶部 滚动到导航底部以下位置，让profileHeaderView显示在最上面,防止用户头像被遮挡, 归位
                self.stickyHeaderContainerView.frame = computeStickyHeaderContainerViewFrame()
                tableHeaderView.bringSubview(toFront: self.profileHeaderView)
            }
            
            
        }
        
    }
    
}

extension EditUserProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.editProfileItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTableViewCellIdentifier, for: indexPath) as! EditProfileTableViewCell
        cell.selectionStyle = .none
        cell.model = self.editProfileItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.editProfileItems[indexPath.row]
        if model.type == .textFieldMultiLine {
            return 100.0
        }
        return 50.0
    }
}

// MARK: Animators
extension EditUserProfileViewController {
    /// 更新导航条上面titleLabel的位置
    func animateNaivationTitleAt(progress: CGFloat) {
        
        let totalDistance: CGFloat = self.navigationTitleLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + ALPNavigationTitleLabelBottomPadding
        
        if progress >= 0 {
            let distance = (1 - progress) * totalDistance
            navigationTitleLabelBottomConstraint?.constant = -ALPNavigationTitleLabelBottomPadding + distance
        }
    }
}

extension EditUserProfileViewController {
    @objc fileprivate func update() {
        guard let user = self.user else {
            return;
        }
        AuthenticationManager.shared.accountLogin.update(user: user, avatar: nil, cover: nil, success: { (response) in
            
        }) { (error) in
            
        }
    }
}