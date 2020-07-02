
import UIKit
import FirebaseAuth

class VerifyViewController: UIViewController {

    @IBOutlet weak var verifyTextField: UITextField!
    var verification_id : String?
    var profileSegue: String = "verifyVCToProfileVC"
    var dummyCode1: String = "111111"
    
    var dummyUserCodes : [String: String] = [
        "1" : "111111",
        "2" : "222222",
        "3" : "333333",
        "4" : "444444"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetUp()
    }
    
    func viewSetUp(){
        verifyTextField.delegate = self
        
    }
    
   
        

}

extension VerifyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        verifyTextField.resignFirstResponder()
        print("hellloo")
        
//        firebase aut codee
        verifyTextField.text = verifyTextField.text!
        if verification_id != nil {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verification_id!, verificationCode: verifyTextField.text!)
            Auth.auth().signIn(with: credential, completion: { authData, error in
               if(error != nil){
                    print(error.debugDescription)
                }
               else {
                    print("SUCESSS WINNN W YAAS")
                guard let uid = Auth.auth().currentUser?.uid else {print("no UID"); return}
                guard let num = Auth.auth().currentUser?.phoneNumber else {print("no "); return}
                User.phoneNum = num
                FirebaseManager.db_userUid = uid
                
                print(uid)
                guard let name = User.name else {return}
                
                let firebaseID = FirebaseManager.db_userUid 

                let userProfile = FirebaseManager.db.collection("users").document(firebaseID)
                userProfile.setData(["number": num, "uid": uid, "name": name], merge: true)
                
                    
//                    move to next screen
                    self.performSegue(withIdentifier: self.profileSegue, sender: nil)
                    

                }
            })
        }
        else {
            print("ERROR IN VERFICATION PROCESSS")
//                    wrong codealert with send again functionlity 
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        any keybaord offset if needed
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        remove any offset if was added
        
    }
    
}
