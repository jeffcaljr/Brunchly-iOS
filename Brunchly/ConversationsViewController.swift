//
//  ConversationsViewController.swift
//  Brunchly
//
//  Created by Jeffery Calhoun on 6/6/17.
//  Copyright © 2017 YoTechnica. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ChameleonFramework
import Toaster

class ConversationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    //MARK: Test code, delete later
    var users = [TestUser]()
    var images = [UIImage]()
    
    @IBOutlet weak var toolbar: DarkToolbar!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Uncomment the following lines later, after testing.
        toolbar.setViewController(viewController: self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
        
        backgroundImage.addBlurEffect()
        
        //MARK: Test code, delete later
        MockUserService.shared.loadUsers(count: 10, gender: TestGender.female, withCompletion: {(users, images) in
            
            if let users = users, let images = images{
                
                self.images = images
                
                self.users = users
                
                
                self.tableView.reloadData()
            }
            else{
                Toast(text: "error loading sample users", delay: 0, duration: Delay.long).show()
            }
            
        })
        
//        tabBarItem.badgeValue = "10"
//        tabBarItem.badgeColor = UIColor.flatSkyBlue()
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return users.count == images.count ? users.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as! ConversationTableViewCell
        
        let resizedPhoto = UIImage.resizeImage(image: images[indexPath.row], newWidth: 100)
        
        cell.configureCell(name: users[indexPath.row].name, photo: resizedPhoto, message: "Hi, how are you", date: "1 min")
        
        return cell
    }
    
    //MARK: DZNEmptyDataSet
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No Conversations"
        let titleFont = UIFont(name: "Avenir Next", size: 28)
        let attrs = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: titleFont]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        var emptyImage = UIImage.resizeImage(image: UIImage(named: "brunchly_b_icon")!, newWidth: 50)

        emptyImage = emptyImage.maskWithColor(color: UIColor(hexString: "#F44336")!)!
        
        return emptyImage
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "When you create connections and begin conversations, they will appear here."
        let titleFont = UIFont(name: "Avenir Next", size: 16)
        let attrs = [NSForegroundColorAttributeName: UIColor(hexString: "#BDBDBD")!, NSFontAttributeName: titleFont]
        return NSAttributedString(string: str, attributes: attrs)
    }

}
