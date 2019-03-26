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

    n_character(N, Chars, Char):-
        string_chars(Chars, Str),
        nth0(N, Str, Char).
	

	position(Board, Y, X, Character):-
        nth0(Y, Board, Column),
        nth0(X, Column, Character).
	

	is_position_free(Board, Y, X):-
        position(Board, Y, X, 'x').
    

    is_position_wall(Board, Y, X):-
        position(Board, Y, X, 'w').
	add_element(List, Element, [Element|List]).
	
	loop_through_sequence([]).
	loop_through_sequence([H|T]):-
        loop_through_sequence(T).
    
	find_all_objects_unwrap([], ObjectsTemp, ObjectsTemp, Character).
    
    find_all_objects_unwrap([H|T], ObjectsTemp, Objects, Character):-
        n_character(_, H, Character),
        add_element(ObjectsTemp, H, ObjectsTemp1),
    	find_all_objects_unwrap(T, ObjectsTemp1, Objects, Character),!.
    

    find_all_objects_unwrap([H|T], ObjectsTemp, Objects, Character):-
		find_all_objects_unwrap(T, ObjectsTemp, Objects, Character), !.
    

    find_all_objects(Board, Objects, Character):-
        append(Board, L),
    	find_all_objects_unwrap(L, [], Objects, Character).
		

	find_all_cords_of_block(Board, BlockCorner):-
        append(Board, L),
        find

    change_in_list(Index, Elem, [_|T], [Elem|T]):-
        Index = 0,
    	!.
	
    change_in_list(Index, Elem, [H|T], [H|Out]):-
        Index1 is Index - 1,
        change_in_list(Index1, Elem, T, Out).

	insert_into_two_dimensional_array(Y, X, Object, Board, NewBoard):-
        nth0(X, Board, ColFrom),
        change_in_list(Y, Object, ColFrom, NewColFrom),
        change_in_list(X, NewColFrom, Board, NewBoard).


    unpack_one_element_list([H|_], H).


    unpack_two_element_list([H|T], H, B):-
        unpack_one_element_list(T, B).


	unpack_three_element_list([H|T], H, B, C):-
        unpack_two_element_list(T, B, C).

	
	find_all_blocks_on_Board(Board, Blocks).
        
