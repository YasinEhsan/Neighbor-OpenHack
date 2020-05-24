
import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

struct FirebaseManager {
    static let db = Firestore.firestore()
    static let auth = Auth.auth()
    
    
    //db schema names
    static var db_userUid: String = "utXREMAJ6AWAX8TsjFWM3wjb8mH3"
    static let db_users: String = "users"
    static let db_shopList:  String = "shoppingList"
    static let db_reqList: String = "requestedItems"
    
    
    //colelctions and doc refrences
    static let col_usersRef = db.collection(db_users)
    static let doc_userRef = col_usersRef.document(db_userUid)
    static let col_shopListRef = doc_userRef.collection(db_shopList)
    static let doc_reqListRef = col_shopListRef.document(db_reqList)
    
    // development testing CRUd
    static let doc_testReqItems = db.collection("reqItems").document(db_userUid)

    
}


