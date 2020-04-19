//
//  Created by Anna Darwish on 4/17/20.
//
import Firebase
import UIKit

class ProfileCreatorVC: UIViewController {
    
    var newActivities = Set<String>()
    var currentActivities = Set<String>()
    var mood = 0
    
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
                return
            }
            else{
                self.updateDatabase()
                self.performSegue(withIdentifier:"loginNewUser",sender:self)
            }
        }
        
        
    }
    
    func updateDatabase(){
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        db.collection(userID!).document("profile").setData([
            "mood": mood,
            "currentActivities": Array(currentActivities),
            "newActivities": Array(newActivities)
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }


}

