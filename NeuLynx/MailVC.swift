//
//  MailVC.swift
//  
//
//  Created by Ronald Hernandez on 7/10/15.
//
//

import UIKit

class MailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!

    var messagesArray:[String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

//        let testObject:PFObject = PFObject(className: "Messages")
//        testObject["SomeProperty"] = "some value"
//        testObject.saveInBackgroundWithBlock(nil)

        //add some sample data so we can see soemthing. 
        self.messagesArray.append("Test1")
        self.messagesArray.append("test2")
        self.messagesArray.append("Test3")
        self.messagesArray.append("Test4")

    }



    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        //create a cell
        let cell = self.tableView.dequeueReusableCellWithIdentifier("messageCell") as! UITableViewCell

        //customize the cell
      cell.textLabel?.text = self.messagesArray[indexPath.row]

        //return the cell.

        return cell

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return messagesArray.count

    }

}
