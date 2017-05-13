module Molecule.User.Types exposing (User)


-- MODEL


type alias User = 
  { displayName : String
  , email : String
  , emailVerified : Bool
  , photoURL : String
  , isAnonymous : Bool
  , uid : String
}
