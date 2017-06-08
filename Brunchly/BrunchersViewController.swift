//
//  BrunchersViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/6/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import Koloda
import Toaster
import DZNEmptyDataSet




class BrunchersViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {
    
    var cardInfoViewHeight: CGFloat = 120
    
    //TODO: Test code, delete later
    var users: [TestUser]!
    var images: [UIImage]!
    
    @IBOutlet weak var toolbar: DarkToolbar!
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var noCardsView: UIView!
    @IBOutlet weak var noCardsLogoView: UIImageView!
    @IBOutlet weak var yesBtn: UIImageView!
    @IBOutlet weak var noBtn: UIImageView!
    @IBOutlet weak var undoBtn: UIImageView!
    @IBOutlet weak var helpBtn: UIImageView!
    @IBOutlet var meetBtns: [UIImageView]!
    
    @IBOutlet weak var kolodaAspectConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        toolbar.setViewController(viewController: self)
        
        backgroundImage.addBlurEffect()
        
        kolodaView.frame.size = CGSize(width: kolodaView.frame.width, height: kolodaView.frame.width + cardInfoViewHeight)
        
        let kolodaSizeConstraint = NSLayoutConstraint(item: kolodaView, attribute: .height, relatedBy: .equal, toItem: kolodaView, attribute: .width, multiplier: 1, constant: cardInfoViewHeight)
        
        
        kolodaView.addConstraint(kolodaSizeConstraint)
        kolodaView.removeConstraint(kolodaAspectConstraint)
        kolodaView.layer.cornerRadius = 4
        kolodaView.clipsToBounds = true
        
        noCardsLogoView.image = noCardsLogoView.image?.maskWithColor(color: UIColor(hexString: "#F44336")!)
        
        yesBtn.image = yesBtn.image?.maskWithColor(color: UIColor.flatMint())
        yesBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BrunchersViewController.swipeRight(_:))))
        
        noBtn.image = noBtn.image?.maskWithColor(color: UIColor.flatWatermelon())
        noBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BrunchersViewController.swipeLeft(_:))))
        
        undoBtn.image = undoBtn.image?.maskWithColor(color: UIColor.flatYellowColorDark())
        undoBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BrunchersViewController.undoSwipe(_:))))
        
        helpBtn.image = helpBtn.image?.maskWithColor(color: UIColor(hexString: "#D32F2F")!)
        helpBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BrunchersViewController.showHelp(_:))))
        
        
        
        //TODO: Uncomment the following 2 lines later
//        kolodaView.dataSource = self
//        kolodaView.delegate = self
        
        
        //TODO: Test Code, delete later
        users = [TestUser]()
        images = [UIImage]()
        
        MockUserService.shared.loadUsers(count: 25, gender: TestGender.female, withCompletion: {(users, images) in
            
            if let users = users, let images = images{
                
                for user in users{
                    self.users.append(user)
                }
                
                for image in images{
                    self.images.append(image)
                }
                
                self.kolodaView.dataSource = self
                self.kolodaView.delegate = self
                self.kolodaView.reloadData()
            }
            else{
                Toast(text: "error loading sample users", delay: 0, duration: Delay.long).show()
            }

        })





    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: KolodaViewDataSource
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int{
        
        if users.count == 0{
            noCardsView.isHidden = false
            setMeetButtonsHidden(isHidden: true)
        }
        else{
            noCardsView.isHidden = true
            setMeetButtonsHidden(isHidden: false)
        }
        
        return users.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed{
        
        return DragSpeed.moderate
        
    }
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView{
        
        let cardView = CardView()
        cardView.frame.size = CGSize(width: koloda.frame.width, height: koloda.frame.height)
        cardView.layer.borderWidth = 4
        cardView.layer.borderColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 4
        cardView.clipsToBounds = true
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: cardView.frame.width, height: cardView.frame.width)
        imageView.backgroundColor = UIColor.black
        imageView.layer.cornerRadius = 2
        imageView.clipsToBounds = true
        
        imageView.image = images[index]
        
        
        let overlay = CustomOverlayView()
        overlay.configureView(user: users[index])
        overlay.backgroundColor = UIColor.white
        overlay.translatesAutoresizingMaskIntoConstraints = false
        
        
        cardView.addSubview(imageView)
        cardView.addSubview(overlay)
        
        
        
        
        cardView.addConstraint(NSLayoutConstraint(item: overlay, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1, constant: 0))
        cardView.addConstraint(NSLayoutConstraint(item: overlay, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 0))

    
        cardView.addConstraint(NSLayoutConstraint(item: overlay, attribute: .bottom, relatedBy: .equal, toItem: cardView, attribute: .bottom, multiplier: 1, constant: 0))
        
        
        cardView.addConstraint(NSLayoutConstraint(item: overlay, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: cardInfoViewHeight))
        
        
        
        return cardView
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView?{
        
//        var overlay = CustomOverlayView()
//        overlay.configureView(user: users[index])
        return nil
    }
    
    //MARK: KolodaViewDelegate
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        noCardsView.isHidden = false
        setMeetButtonsHidden(isHidden: true)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        Toast(text: "selected card!", delay: 0, duration: Delay.short).show()
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    
    func setMeetButtonsHidden(isHidden: Bool){
        for btn in meetBtns{
            btn.isHidden = isHidden
        }
    }
    
    func swipeLeft(_ gesture: UIGestureRecognizer){
        kolodaView.swipe(.left)
    }
    
    func swipeRight(_ gesture: UIGestureRecognizer){
        kolodaView.swipe(.right)
        
    }
    
    func undoSwipe(_ gesture: UIGestureRecognizer){
        kolodaView.revertAction()
    }
    
    func showHelp(_ gesture: UIGestureRecognizer){
        var toast = Toast(text: "Heeeeelllllllllllppppp!", delay: 0, duration: Delay.long)
        toast.view.backgroundColor = UIColor(hexString: "#D32F2F")
        toast.view.textColor = UIColor.white
        toast.view.textInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        toast.view.font = UIFont(name: "Avenir Next", size: 20)
        toast.show()
    }

}


extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var capitalized: String {
        return first.uppercased() + String(characters.dropFirst())
    }
}
