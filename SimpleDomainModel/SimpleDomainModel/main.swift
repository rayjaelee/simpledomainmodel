//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    if self.currency == "USD" {
        switch to {
        case "GBP":
            return Money(amount: self.amount / 2, currency: "GBP")
        case "EUR":
            return Money(amount: self.amount * 3 / 2, currency: "EUR")
        case "CAN":
            return Money(amount: self.amount * 5 / 4, currency: "CAN")
        default:
            return Money(amount: self.amount, currency: self.currency)
        }
    } else if self.currency == "EUR" {
        return Money(amount: self.amount / 3 * 2, currency: "USD")
    } else if self.currency == "CAN" {
        return Money(amount: self.amount / 5 * 4, currency: "USD")
    } else if self.currency == "GBP" {
        return Money(amount: self.amount * 2, currency: "USD")
    } else {
        return Money(amount: self.amount, currency: self.currency)
    }
  }
  
  public func add(_ to: Money) -> Money {
    if self.currency == to.currency {
        return Money(amount: self.amount + to.amount, currency: self.currency)
    } else {
        return Money(amount: self.convert("GBP").amount + to.amount, currency: "GBP")
    }
  }
    
  public func subtract(_ from: Money) -> Money {
    return Money(amount: self.amount - from.amount, currency: self.currency)
  }
}

//////////////////////////////////////
//// Job
////
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }

  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }

  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let hourly):
        return Int(hourly * Double(hours))
    case .Salary(let salary):
        return salary
    }
  }

  open func raise(_ amt : Double) {
    switch type {
    case .Hourly(let hourly):
        self.type = Job.JobType.Hourly(hourly + amt)
    case .Salary(let salary):
        self.type = Job.JobType.Salary(salary + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return _job
    }
    set(value) {
        if self.age >= 21 {
         self._job = value
        }
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if self.age >= 21 {
            self._spouse = value
        }
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(String(describing: self._job)) spouse:\(String(describing: self._spouse))]"
  }
}

//////////////////////////////////
// Family

open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    self.members = [spouse1, spouse2]
  }

  open func haveChild(_ child: Person) -> Bool {
    members.append(child)
    return true
  }

  open func householdIncome() -> Int {
    var totalIncome = 0
    for member in members {
        totalIncome += member._job?.calculateIncome(2000) ?? 0
    }
    print(totalIncome)
    return totalIncome
  }
}
