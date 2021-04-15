/*
Subway Menu

Bread Options:
 Italian Wheat
 Hearty Italian
 Honey Oat
 Parmesan Oregano
 Multigrain
 Flatbread

Meal Options:
 Normal Meal
 Veggie Meal
 Healthy Meal
 Vegan Meal
 Value Meal

Sandwich Options:
 Meat:
  Chicken Bacon Ranch
  Chicken Teriyaki
  Cold Cut Trio
  Egg Mayo
  Italian B.M.T.
  Meatball Marina Melt
  Roast Beef
  Roasted Chicken Breast
  Steak and Cheese
  Subway Club
  Chicken Ham
  Subway Melt
  Tuna
  Turkey
 Veggie Meal:
  Veggie Delite
  Veggie Patty

Sauce Options:
 Habanero Hot Sauce
 Smoky BBQ
 Chipotle Southwest
 Mayonnaise
 Sweet Onion (NF)
 Honey Mustard (NF)
 Red Wine Vinegar (NF)
 Mustard (NF)
 Ranch Dressing
 None

Salad Options (Repeatable when other than all is chosen):
 All
 Cucumber
 Lettuce
 Olives
 Capsicum
 Onions
 Spinach
 Sundried Tomato
 Pickles
 Jalapeno
 None

Top up Options:
 Cheese
 Extra Meat
 Avocado
 None
 
Sides Options:
 Chips
 Cookies
 Hashbrowns
 Energy Bar and Fruit Crisps
 Yogurt
 None

Drinks Options:
 Fountain Drinks
 Dasani Mineral Water
 Minute Maid Pulpy Orange Juice
 Ayataka Japanese Green Tea
 Coffee/Tea
 None
*/

order_subway():-
  writeln("Welcome to Subway!"),
  questions(Q),
  init_question(Q).

init_question([Head|Tail]):-
  asserta(chosen_option([])),
  meal(W),
  nl,
  writeln("Meal Menu:"),
  display_list(W), nl, nl,
  write("Choose your preferred type of meal from above: "),
  read(InputChoice),
  (item_in_list(InputChoice, W) -> 
				asserta(chosen_meal(InputChoice)), append_chosen_option(InputChoice),
				chosen_meal(Z),
				writeln("Selected Option:"), writeln(Z), !,next_question(Tail)); writeln("Enter one of the listed option!"), append([Head], Tail, Q), init_question(Q).

next_question([Head|Tail]):- 
% print_all_selected(),
  chosen_meal(X),
  (Head == bread)-> (bread_question(), !, next_question(Tail));
  (Head == sandwich)-> (sandwich_question(), !, next_question(Tail));
  (Head == salad)-> (salad_question(), !, next_question(Tail));
  (Head == sauce)-> (sauce_question(), !, next_question(Tail));
  (Head == top_up)-> (((X \= value)->top_up_question(); next_question(Tail)), !, next_question(Tail));
  (Head == sides)-> (sides_question(), !, next_question(Tail));
  (Head == drinks)-> (drinks_question(), !, next_question(Tail)).

next_question([]):- 
  nl,
  writeln("You have completed your orders!"),
  writeln("Let me repeat your order"),
  nl,
  chosen_option(X), display_list(X), 
  nl,
  writeln("Press any key to confirm order!"), !,
  read(quitChoice), abort, !.

bread_question():- 
  nl,
  bread(X),
  writeln("Bread Menu: "),
  display_list(X), nl,
  write("Enter your choice: "),
  read(InputChoice),
  (item_in_list(InputChoice, X) -> (
				append_chosen_option(InputChoice),
				writeln("Selected Option: "), writeln(InputChoice), !); writeln("Enter one of the listed option!"), bread_question()).

sandwich_question():- 
  nl,
  chosen_meal(Y),
  ((Y == veggie)-> ( veggie(X), writeln("Only Veggie Sandwiches"), !); sandwich(X)),
  writeln("Sandwich Menu: "),
  display_list(X), nl,
  write("Enter your choice: "),
  read(InputChoice),
  (item_in_list(InputChoice, X) -> (
				append_chosen_option(InputChoice),
				writeln("Selected Option: "), writeln(InputChoice), !); writeln("Enter one of the listed option!"), sandwich_question()).

sauce_question():- 
  nl,
  chosen_meal(Y),
  ((Y == healthy)-> ( non_fatty_sauce(X), writeln("Only Non-Fatty Sauce"), !); sauce(X)),
  writeln("Sauce Menu(Only One Sauce): "),
  display_list(X), nl,
  write("Enter your choice: "),
  read(InputChoice),
  (item_in_list(InputChoice, X) -> (
				append_chosen_option(InputChoice),
				writeln("Selected Option: "), writeln(InputChoice), !); writeln("Enter one of the listed option!"), sauce_question()).

salad_question():- 
  nl,
  salad(X),
  writeln("Salad Menu: "),
  display_list(X), nl,
  write("Enter your choice: "),
  read(InputChoice),
  (item_in_list(InputChoice, X) -> (
				append_chosen_option(InputChoice),
				writeln("Selected Option: "), writeln(InputChoice), !); writeln("Enter one of the listed option!"), salad_question()).

top_up_question():- 
  nl,
  chosen_meal(Y),
  ((Y == vegan)-> ( vegan(X), writeln("No Cheese"), !); top_up(X)),
  writeln("Top Up Menu: "),
  display_list(X), nl,
  write("Enter your choice: "),
  read(InputChoice),
  (item_in_list(InputChoice, X) -> (
				append_chosen_option(InputChoice),
				writeln("Selected Option: "), writeln(InputChoice), !); writeln("Enter one of the listed option!"), top_up_question()).

sides_question():- 
  nl,
  sides(X),
  writeln("Sides Menu: "),
  display_list(X), nl,
  write("Enter your choice: "),
  read(InputChoice),
  (item_in_list(InputChoice, X) -> ( 
				append_chosen_option(InputChoice),
				writeln("Selected Option: "), writeln(InputChoice), !); writeln("Enter one of the listed option!"), sides_question()).

drinks_question():- 
  nl,
  drinks(X),
  writeln("Drinks Menu: "), nl,
  display_list(X), nl,
  write("Enter your choice: "),
  read(InputChoice),
  (item_in_list(InputChoice, X) -> ( 
				append_chosen_option(InputChoice),
				writeln("Selected Option: "), writeln(InputChoice), !); writeln("Enter one of the listed option!"), drinks_question()).
  
:- dynamic chosen_meal/1.
:- dynamic chosen_option/1.

print_all_selected():- 
  write("Selected so far: "), chosen_option(X), display_list(X).


% X => Element, Y => List, Save to chosen_option as list
append_chosen_option(X):- 
(X \== none)-> chosen_option(Y), append([X], Y, Z), asserta(chosen_option(Z)); !.


% KBS Options
questions([meal, bread, sandwich, salad, sauce, top_up, sides, drinks]).
meal([normal, veggie, healthy, vegan, value]).
bread([italian_wheat, hearty_italian, honey_oat, parmesan_oregano, multigrain, flatbread]).
sandwich([chicken_bacon_ranch, chicken_teriyaki, cold_cut_trio, egg_mayo, italian_bmt, meatball_marina_melt, roast_beef, roasted_chicken_breast, steak_and_cheese, subway_club, chicken_ham, subway_melt, tuna, turkey, veggie_delite, veggie_patty]).
sauce([habanero_hot_sauce, smoky_bbq, chipotle_southwest, mayonnaise, sweet_onion, honey_mustard, ranch_dressing, red_wine_vinegar, mustard, none]).
salad([all, cucumber, lettuce, olives, capsicum, onions, spinach, sundried_tomato, pickles, jalapeno, none]).
top_up([cheese, extra_meat, avocado, none]).
sides([chips, cookies, hashbrowns, energy_bar_and_fruit_crisps, yogurt, none]).
drinks([fountain_drinks, dasani_mineral_water, minute_maid_pulpy_orange_juice, ayataka_japanese_green_tea, coffee, tea, none]).


/*
Special Orders:
Veggie Meal: No meat options
Healthy Meal: No fatty sauce
Vegan Meal: No cheese top up
Value Meal: No Top up
*/
% Special Cases
veggie([veggie_delite, veggie_patty]).
non_fatty_sauce([honey_mustard, sweet_onion, red_wine_vinegar, mustard, none]).
vegan([extra_meat, avocado, none]).



display_list([]) :- !.
display_list([Head|Tail]) :-
  write(Head),write(" , "),
    display_list(Tail).

item_in_list(Item, [Item|Rest]).
item_in_list(Item,[Head|Tail]):-item_in_list(Item,Tail).