// dfx new learn_defi  -> create project

// actor {
//   public query func greet(name : Text) : async Text {
//     return "Hello, " # name # "!";
//   };
// };

// NOTE:: We have to start, deploy our app
// dfx start
// dfx deploy --> deploy canister to simulated local Internet Computer(ICP) block-chain

// import Debug module from motoko:base-library
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Float "mo:base/Float";

// Create a class(ACTOR) to hold a CANISTER(a place for SMART-CONTRACTS(code) which has WEB-ASSEMBLY logic and flash memory as MEMORY-PAGES)
actor DeFi {
  // create variable using var
  var currentValue = 300;

  // change variable value
  // Nat -> Natural number type
  currentValue := 10000;

  // print "text" to the output stream
  Debug.print("Hello from Motoko!!");

  // to print values
  Debug.print(debug_show (currentValue));

  // never changing
  let id = 223456787654;

  // it's immutable
  // id := 23456;
  Debug.print(debug_show (id));

  // create a function
  // this is a PRIVATE function i.e; accesible only within this ACTOR
  func privateFunc() {
    currentValue += 1;

    Debug.print(debug_show (currentValue));

  };

  // calling the function
  privateFunc();

  // this is a PUBLIC function, i.e; can be called from outside the canister
  // calling function from outside the canister
  // dfx canister call canister_name function_name fucntion_args
  // Note:: Rather than this we can also use CANDID UI which is like the swagger-ui for canisters
  // https://internetcomputer.org/docs/current/developer-docs/backend/candid/candid-howto
  // dfx canister id __Candid_UI
  // this swagger takes functions from .did file as service
  // http://127.0.0.1:4943/?canisterId=<<Canister-ui-id>>
  // dfx canister id canister_name
  // arguments: data_type
  // these are UPDATE calls, which take a bit time to update the state of the canister --> CONSENSUS
  public func publicFunc(amount : Nat) {
    currentValue += amount;

    Debug.print(debug_show (currentValue));
  };

  // Natural subtraction underflow if we go beyond Natural Number limit >0
  public func conditionalFunc(amount : Nat) {
    // because we may have an Inference error of data type, so we explicitly take data-type
    let tempValue : Int = currentValue - amount;
    if (tempValue >= 0) {
      currentValue -= amount;
      Debug.print(debug_show (currentValue));
    } else {
      Debug.print("You cannot withdraw a higher amount than current-balance!!!");
    };

  };

  // QUERY calls do NOT update the state of the canister
  // output the data async
  // func_name(): async output_data_type
  public query func checkBalance() : async Float {
    // Debug.print(debug_show (orthogonalPersistence));
    return accountBalance;
  };

  // normal FLEXIBLE variable whose value refreshes across any deploy or update cycle
  var flexibleVariable = 300;

  Debug.print(debug_show (flexibleVariable));

  // ORTHOGONAL PERSISTENCE variable whose value persists across cycles
  // replace via :=
  stable var orthogonalPersistence = 400;

  Debug.print(debug_show (orthogonalPersistence));

  // data-type here is infered and unnecessary to mention
  stable var accountBalance : Float = 300.0;
  accountBalance := 300;

  public func topUp(amount : Float) {
    accountBalance += amount;
    Debug.print(debug_show (accountBalance));
  };

  public func withdraw(amount : Float) {
    let tempValue : Float = accountBalance - amount;
    if (tempValue >= 0) {
      accountBalance -= amount;
      Debug.print(debug_show (accountBalance));
    } else {
      Debug.print("You cannot withdraw a higher amount than current-balance!!!");
    };

  };

  // nanoseconds since 1970
  stable var startTime = Time.now();
  Debug.print(debug_show (startTime));

  // compund interest
  public func compound() {
    let currentTime = Time.now();
    let timeElapsedNS = currentTime - startTime;
    let timeElapsedS = timeElapsedNS / 1000000000;

    // Compound interest formula .. occurs per-second
    // change all data-type to float
    accountBalance := accountBalance * (1.01 ** Float.fromInt(timeElapsedS));

    // because we must change the time of last compunding
    startTime := currentTime;
  };

};
