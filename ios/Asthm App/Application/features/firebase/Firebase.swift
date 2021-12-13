import FirebaseAuth
import common

class Firebase {
    
    static var auth: Auth { Auth.auth() }
    
    static func fetchUser(completion: @escaping (common.User?) -> ()) {
        guard let firebaseUser = auth.currentUser else {
            completion(nil)
            return
        }
        
        auth.currentUser?.getIDToken { token, _ in
            if let token = token {
                completion(firebaseUser.toUser(token))
            } else {
                completion(nil)
            }
        }
    }
}

fileprivate extension FirebaseAuth.User {
    
    func toUser(_ token: String) -> common.User {
        return common.User(
            id: uid,
            token: token,
            photoUrl: photoURL?.absoluteString,
            name: displayName,
            email: email,
            isEmailVerified: isEmailVerified,
            phoneNumber: phoneNumber
        )
    }
}
