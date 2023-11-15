//
//  EmailSender.swift
//  GYMGLE
//
//  Created by t2023-m0088 on 11/14/23.
//

import Foundation
import SwiftSMTP

let smtp = SMTP(
    hostname: "smtp.gmail.com", email: "gymgle7@gmail.com", password: "swwjjnnurmteohto"
)

var user_name = "회원님!"
var user_email: String = ""

let mail_from = Mail.User(name: "GYMGLE", email: "gymgle7@gmail.com")
let mail_to = Mail.User(name: user_name, email: user_email)

let codeChar = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

func createEmailCode() -> String{
    var certiCode: String = ""

    for _ in 0...5 {
        let randNum = Int.random(in: 0 ..< codeChar.count)
        certiCode += codeChar[randNum]
    }
    return certiCode
}

let certiNumber = createEmailCode()

let content = "[GYMGLE] E-MAIL VERIFICATION \n" + "Certification Number: [" + certiNumber + "] \"APP에서 인증번호를 입력해주세요."
let mail = Mail(from: mail_from, to: [mail_to],subject: "GYMGLE 이메일 인증 코드입니다.",text: content)

