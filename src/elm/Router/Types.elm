module Router.Types exposing (Route(..))

type alias PlayerID = String
type alias PhotoID = String
type alias TopicID = String
type alias PostID = String

type Route
  --= PlayersRoute -- the route for players
  --| PlayerRoute PlayerID
  = LoginRoute
  | RegisterRoute
  | HomeRoute
  | FeedRoute
  | ProfileRoute
  | PhotoRoute PhotoID
  | NotFoundRoute
  | TopicRoute TopicID
  | TopicsRoute
  | PostsRoute
  | PostRoute TopicID PostID 
