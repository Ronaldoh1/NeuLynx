//
//  MailVC.swift
//
//
//  Created by Ronald Hernandez on 7/10/15.
//
//

import UIKit

class MailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    var messagesArray:[String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //        let testObject:PFObject = PFObject(className: "Messages")
        //        testObject["SomeProperty"] = "some value"
        //        testObject.saveInBackgroundWithBlock(nil)

        //retrieve Messages from parse
        self.retrieveMessages()

        //to recognize that the user has tapped outside the textfield, we need to add a Tap gesture recognizer to the TableView


        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.tableView .addGestureRecognizer(tapGesture);

    }


    //MARK: TableView Delegate
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
    //MARK: Textfield Delegatess

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.5, animations: {

            //update itsview if there are any changes in the contrants.
            self.view.layoutIfNeeded()

            self.heightConstraint.constant = 300
            self.view.layoutIfNeeded()

            }, completion: nil)

        return true;
    }

    func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5, animations: {

            //update itsview if there are any changes in the contrants.
            self.view.layoutIfNeeded()

            self.heightConstraint.constant = 60
            self.view.layoutIfNeeded()

            }, completion: nil)
    }


    //MARK: helper method
    func tableViewTapped() {

        //force textfield to end editing.
        self.messageTextField.endEditing(true)
    }

    func retrieveMessages(){

        var query = PFQuery(className:"Message")

        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]?, error: NSError?) -> Void in

            //clear the array so that we don't append repeated objects.

            self.messagesArray = [String]()

            //Loop through the PFObjects array

            if let myObjects = objects {
                for messageObject in myObjects {
                    //retrieve the string of MessageText

                    let messageText:String? = (messageObject as! PFObject)["MessageText"] as? String

                    //assign to message array
                    self.messagesArray.append(messageText!)

                }
            }

            //reload the tableView
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }

        }



    }

    //action Button
    @IBAction func onSendButtonTapped(sender: AnyObject) {

        //send button is tapped.

        //call the end editing method for text field to dismiss keyboard
        self.messageTextField.endEditing(true)

        //diable the textfield and buttong
        self.messageTextField.enabled = false;
        self.sendButton.enabled = false;
        //create the PFObject

        var message:PFObject = PFObject(className:"Message")



        //Set the text key to the text of the message textfield
        message["MessageText"] = self.messageTextField.text

        //Save the PFObject
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                //retrieve the latest message and reload data.

                self.messageTextField.enabled = true;
                self.sendButton.enabled = true;
                //retreive messages
                self.retrieveMessages()

            } else {
                // There was a problem, check error.description

                NSLog(error!.description)
            }

            dispatch_async(dispatch_get_main_queue()){
                //enable the textfield and button
                self.messageTextField.enabled = true;
                self.sendButton.enabled = true;
                self.messageTextField.text = ""
            }
            
            
        }
        
        
        //perform an animation 
        UIView.animateWithDuration(0.5, animations: {
            
            //update itsview if there are any changes in the contrants.
            self.view.layoutIfNeeded()
            
            self.heightConstraint.constant = 60
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        
    }

}
