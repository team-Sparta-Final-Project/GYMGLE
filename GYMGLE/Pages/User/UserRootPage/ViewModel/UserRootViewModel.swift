// UserRootViewModel.swift

import Combine

class UserRootViewModel {

    var userNameSubject = PassthroughSubject<String, Never>()
    var gymInUserCountSubject = PassthroughSubject<String, Never>()
    var yesterUserCountSubject = PassthroughSubject<String, Never>()
    var noticeSubject = PassthroughSubject<String, Never>()

    var userName: String = "" {
        didSet {
            userNameSubject.send(userName)
        }
    }

    var gymInUserCount: String = "" {
        didSet {
            gymInUserCountSubject.send(gymInUserCount)
        }
    }

    var yesterUserCount: String = "" {
        didSet {
            yesterUserCountSubject.send(yesterUserCount)
        }
    }

    var notice: String = "" {
        didSet {
            noticeSubject.send(notice)
        }
    }

    init() {
    }
}
