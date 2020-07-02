
import UIKit
import FirebaseAuth

class loginViewController: UIViewController {

    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    var num: String = ""
    var verification_id : String?  = nil
    var verifySegue: String = "loginVCToVerifyVC"
    var dummyNum1: String = "+19171111111"
    
    var dummyUsers : [String: String] = [
        "1" : "+19171111111",
        "2" : "+19172222222",
        "3" : "+19173333333",
        "4" : "+19174444444"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
    }
    
    func viewSetUp(){
        numberTextField.delegate = self
        guard let name = User.name else {return}
        nameLabel.text = "Hello " + name + ""
        
    }
    
    func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           let action = UIAlertAction(title: "OK", style: .default, handler: nil)
           alert.addAction(action)
           present(alert, animated: true, completion: nil)
    }
    
    
//    passing data and seque with verificationID
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
        if segue.identifier == verifySegue {
            let destinationVC = segue.destination as! VerifyViewController
            destinationVC.verification_id = sender as? String
        }
    }
    
}

extension loginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        numberTextField.resignFirstResponder()
        
//        added firebase auth code
//        CHNAGE HERE FOR DUMMY NUMBERS W DUMMY DICTIONARY ABOVE
        numberTextField.text = numberTextField.text!
        if !numberTextField.text!.isEmpty {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        PhoneAuthProvider.provider().verifyPhoneNumber(numberTextField.text!, uiDelegate: nil, completion: { verficationID, error in
            if(error != nil){
                print(error.debugDescription)
            }else {
                self.verification_id = verficationID
    //                    move to next page
                print("movint to next page")
                self.performSegue(withIdentifier: self.verifySegue, sender: self.verification_id)
//                            if user clicks done before verify then call another alert thata  delgate frm firebase d2
                }
            })
        }else {
            print("please enter your mobile numebr")
//                    invalid mobile number or syntax send alrert
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
