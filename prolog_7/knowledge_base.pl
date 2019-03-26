% data structure representing board
board([[w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ],
        [w  ,aR ,a  ,cR ,c  ,x  ,iR ,jR ,w  ],
       [w  ,a  ,a  ,x  ,dR ,d  ,x  ,j  ,w  ],
        [w  ,x  ,x  ,x  ,eR ,fR ,x  ,kR ,w  ],
        [w  ,bR ,b  ,x  ,e  ,gR ,x  ,k  ,w  ],
       [w  ,b  ,b  ,x  ,x  ,x  ,lR ,l  ,w  ],
        [w  ,b  ,b  ,x  ,hR ,h  ,l  ,l  ,w  ],
        [w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ]]).

% String manipulation
	% n character in characters
    n_character(N, Chars, Char):-
        string_chars(Chars, Str),
        nth0(N, Str, Char).
	
%------------------	
	position(Board, Y, X, Character):-
        nth0(Y, Board, Column),
        nth0(X, Column, Character).
%------------------


%------------------
	is_position_free(Board, Y, X):-
        position(Board, Y, X, 'x').
%------------------    

%------------------
    is_position_wall(Board, Y, X):-
        position(Board, Y, X, 'w').
%------------------

%------------------
    add_element(List, Element, [Element|List]).
%------------------


%------------------
	loop_through_sequence([]).
	loop_through_sequence([H|T]):-
        loop_through_sequence(T).
%------------------


%------------------
	find_all_objects_unwrap([], ObjectsTemp, ObjectsTemp, _).
    
    find_all_objects_unwrap([H|T], ObjectsTemp, Objects, Character):-
        n_character(_, H, Character),
        add_element(ObjectsTemp, H, ObjectsTemp1),
    	find_all_objects_unwrap(T, ObjectsTemp1, Objects, Character),!.

    find_all_objects_unwrap([_|T], ObjectsTemp, Objects, Character):-
		find_all_objects_unwrap(T, ObjectsTemp, Objects, Character), !.

    find_all_objects(Board, Objects, Character):-
        append(Board, L),
    	find_all_objects_unwrap(L, [], Objects, Character).
%------------------	



%------------------
    find_all_cords_of_block_unwrap(_, [], ListOfCords, ListOfCords).	
	
    find_all_cords_of_block_unwrap(Board, [H|T], ListOfCordsTemp, ListOfCords):-
         position(Board, Y, X, H),
         insert_into_two_dimensional_array(Y, X, 'T', Board, NewBoard),
    	 add_element(ListOfCordsTemp, [Y, X], ListOfCordsTemp1),
         find_all_cords_of_block_unwrap(NewBoard, T, ListOfCordsTemp1, ListOfCords), !.
    
	find_all_cords_of_block(Board, BlockCorner, ListOfCords):-
        n_character(0, BlockCorner, ID),
        find_all_objects(Board, Objects, ID),
        find_all_cords_of_block_unwrap(Board, Objects, [], ListOfCords).
%------------------
    move_block(Board, BlockCorner, Direction):-
        Direction = 'up'.

	move_block(Board, BlockCorner, Direction):-
        Direction = 'down'.

	move_block(Board, BlockCorner, Direction):-
        Direction = 'left'.

	move_block(Board, BlockCorner, Direction):-
        Direction = 'right'.




%------------------
    change_in_list(Index, Elem, [_|T], [Elem|T]):-
        Index = 0,
    	!.
	
    change_in_list(Index, Elem, [H|T], [H|Out]):-
        Index1 is Index - 1,
        change_in_list(Index1, Elem, T, Out).
%------------------


%------------------
	insert_into_two_dimensional_array(Y, X, Object, Board, NewBoard):-
        nth0(Y, Board, ColFrom),
        change_in_list(X, Object, ColFrom, NewColFrom),
        change_in_list(Y, NewColFrom, Board, NewBoard).
%------------------



%------------------
    unpack_one_element_list([H|_], H).


    unpack_two_element_list([H|T], H, B):-
        unpack_one_element_list(T, B).


	unpack_three_element_list([H|T], H, B, C):-
        unpack_two_element_list(T, B, C).
%------------------
	
	
        
