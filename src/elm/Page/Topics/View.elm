module Page.Topics.View exposing (view)


import Html exposing (Html, div, text)

topics : List String
topics = ["Computer", "Software", "Hardware", "Apple", "Android", "Mobile Phones and Tablet", "Photography, Digital Imaging and Video", "Codemasters","Open Source", "Arts & Design", "Musician", "Property Talk", "Finance, Business and Investment House", "Real World Issues", "Education Essentials", "Job & Careers", "Brides & Groom", "Pregnancy & Parenting", "Health & Fitness", "Grab & Uber", "Movies and Music", "Anime", "Dota2", "Console Couches", "Kopitiam", "Cupid's Corner", "Pets", "The Sports Channel", "Football", "Hobbies, Collectibles and Model Kits", "Travel & Living", "Girl's Forum", "Men's Style and Fashion"]


classifieds : List String
classifieds = [ "Job enlistment", "Properties", "Business for Sale", "Services Noticeboard", "Events and gatherings" ]

view : Html msg
view =
    div [] (List.map listView topics)


listView : String -> Html msg
listView content =
    div [] [ text content ]