module Router.Types exposing (Route(..))

type alias PlayerID =
  String

type alias PhotoID =
  String

type Route
  = PlayersRoute -- the route for players
  | PlayerRoute PlayerID
  | LoginRoute
  | RegisterRoute
  | HomeRoute
  | NotFoundRoute
  | ProfileRoute
  | PhotoRoute PhotoID
