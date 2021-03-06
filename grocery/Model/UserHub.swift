

import Foundation

class UserHub {
    static let sharedInstance = UserHub()
    
//    for homeVC table view
    var requestedList: [Item] = [Item]() {
        willSet {
        }
        didSet {
            NotificationCenter.default.post(name: .vcOneAction, object: self)
        }
    }
    
//    for shoppingVC table view
    var shoppingList: [GroceryList] = [GroceryList]() {
        willSet {
        }
        didSet {
            print("Shop list uodate")
            NotificationCenter.default.post(name: .shoppingList, object: self)
        }
    }
    
//    for feedVC table view
    var neighborList: [GroceryList] = [GroceryList]() {
        willSet {
            
        }
        didSet {
            print("neibotListUpdate")
            NotificationCenter.default.post(name: .neighborList, object: self)
        }
    }
    
    
    
    private init() {
        listenDbChanges()
        let userList = GroceryList(name: User.name ?? "My List", groceryItems: requestedList)
        shoppingList.append(userList)
        listenNeighborLists()
        print("invoked n list")
        
    }
    
    func swipedToAddDeliveryList(delivery: GroceryList) {
        print("swiped", delivery)
        var newDelivery: Bool = true
        for (i,user) in shoppingList.enumerated() {
            if user.name ==  delivery.name {
                newDelivery = false
                shoppingList[i].groceryItems.append(delivery.groceryItems[0])
            }
        }
        if newDelivery {
            shoppingList.append(delivery)
        }
    }
    
   
    
    func listenNeighborLists() {
//        neighborList.removeAll()
        print("n list m called")
        var aggregateList: [GroceryList] = [GroceryList]()
        neighborList.removeAll()
        
        FirebaseManager.db.collectionGroup("users").addSnapshotListener{ (querySnapshot, err) in
            print("HELLO")
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("rorar")
                self.neighborList.removeAll()
                for (index, document) in querySnapshot!.documents.enumerated() {

//                    SUBCOLLECTION START
                    let id = document.documentID
                    let property = document.get("reqList")
                    
//
                    
                    if id == FirebaseManager.db_userUid {
                        continue
                    }
                    
                    let subCol = FirebaseManager.col_usersRef.document(id).collection("shoppingList").document("requestedItems")
                    print("ID IS")

                    subCol.getDocument { (document, error) in
                        
                        if let document = document, document.exists {
                            guard let data = document.data() else {
                              print("Document data was empty.")
                              return
                           }
                            print("workedddd" )
//                              self.neighborList[index].groceryItems.insert(shopItem, at: 0)
//                            print(self.neighborList)
                            
                            let nameProperty = document.get("name") ?? ""
                            
                            let personXReqList: [Item] = self.updateModel(data: data)
                            let personXGroceryList = GroceryList(name: nameProperty as! String, groceryItems: personXReqList)
                            self.neighborList.append(personXGroceryList)
                            aggregateList.append(personXGroceryList)
                            
//                            append(personXGroceryList)
                            print("sdoddne", index, aggregateList.count)
//                            print("Completed", id,aggregateList)
                        } else {
                            print("Document does not exist")
                        }
                    }
                    print("sdoddne2", aggregateList.count)
//                    SUBCOLLECTION END

                }
            }
        }
        self.neighborList = aggregateList
        print("aggg ===", aggregateList.count)
    }
    

       
   func listenDbChanges(){
   //        sync up model with firebase here
           FirebaseManager.doc_reqListRef
           .addSnapshotListener { documentSnapshot, error in
             guard let document = documentSnapshot else {
               print("Error fetching document: \(error!)")
               return
             }
             guard let data = document.data() else {
               print("Document data was empty.")
               return
             }
//             print("Current data: \(data.keys)")
             self.requestedList = self.updateModel(data: data)
             self.shoppingList[0].groceryItems = self.requestedList
           }
    
       }
       
       func updateModel(data: [String: Any]) -> [Item]{
        var newReqList: [Item] = [Item]()
            for output in data {
               if let itemDeets = output.value as? [String] {
                   let shopItem = Item(price: itemDeets[1], name: output.key, notes: itemDeets[0])
                newReqList.insert(shopItem, at: 0)
               }
           }
            return newReqList
       }
    
}
