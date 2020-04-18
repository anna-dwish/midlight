//
//  Created by Anna Darwish on 4/17/20.
//
import Firebase
import UIKit

class ProfileCreatorVC: UIViewController {
    
    var newActivities = Set<String>()
    var currentActivities = Set<String>()
    var mood = 0
    var email = ""
    var password = ""
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var finishProfile: UIButton!
    @IBOutlet weak var inputAid: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createProfile()
    {
        if (userName.text == nil || userName.text!.count == 0) {
            inputAid.text = "Please enter a valid name"
            return
        }
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = userName.text
        changeRequest?.commitChanges { (error) in
            if error != nil {
                self.inputAid.text = "Please try again"
            }
            else{
                self.updateDatabase()
            }
        }
        
    }
    
    func updateDatabase(){
        print(Auth.auth().currentUser?.displayName as Any)
        print("database updated!!!")
//        let db = Firestore.firestore()
//        var ref: DocumentReference? = nil
//        ref = db.collection("moods").addDocument(data: [
//                "date": "04-16-20",
//                "mood": "happy"
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
//        performSegue(withIdentifier:"moodToProfile",sender:self)
    }


}

