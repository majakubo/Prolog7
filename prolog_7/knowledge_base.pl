% data structure representing board
board([ [w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ],
        [w  ,a  ,a  ,c  ,c  ,x  ,i  ,j  ,w  ],
        [w  ,a  ,a  ,x  ,d  ,d  ,x  ,j  ,w  ],
        [w  ,x  ,x  ,x  ,e  ,f  ,x  ,k ,w  ],
        [w  ,b  ,b  ,x  ,e  ,g  ,x  ,k  ,w  ],
        [w  ,b  ,b  ,x  ,x  ,x  ,l  ,l  ,w  ],
        [w  ,b  ,b  ,x  ,h  ,h  ,l  ,l  ,w  ],
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

	block(a).
	block(b).
	block(c).
	block(d).
	block(e).
	block(f).
	block(g).
	block(h).
	block(i).
	block(j).
	block(k).
	block(l).
	block(m).
	block(n).
	block(o).
	block(p).
	direction(up).
	direction(down).
	direction(left).
	direction(right).

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
	loop_through_sequence([_|T]):-
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
    
	find_all_cords_of_block(Board, Character, ListOfCords):-
        n_character(0, Character, ID),
        find_all_objects(Board, Objects, ID),
        find_all_cords_of_block_unwrap(Board, Objects, [], ListOfCords).

%------------------
    replace_cords_with_character(Board, Board, [], _).

	replace_cords_with_character(Board, NewBoard, [H|T], BlockCharacter):-
        unpack_two_element_list(H, Y, X),
        insert_into_two_dimensional_array(Y, X, BlockCharacter, Board, Board1),
        replace_cords_with_character(Board1, NewBoard, T, BlockCharacter).
%------------------

%------------------
	move_cordinates([], NewListOfCords, NewListOfCords , _, _).
	move_cordinates([H|T], TemporaryListOfCords, NewListOfCords, Ydiff, Xdiff):-
        unpack_two_element_list(H, Y, X),
        Y1 is Y + Ydiff,
        X1 is X + Xdiff,
        add_element(TemporaryListOfCords, [Y1, X1], TemporaryListOfCords1),
        move_cordinates(T, TemporaryListOfCords1, NewListOfCords, Ydiff, Xdiff).
	
	get_new_cords(ListOfCords, NewListOfCords, Direction):-
    	xydiff(Direction, Ydiff, Xdiff),
        move_cordinates(ListOfCords, [], NewListOfCords, Ydiff, Xdiff).
%------------------
%
	one_step(Board, NewBoard):-
       block(BlockCharacter),
       direction(Dir),
       move_block(Board, BlockCharacter, Dir, NewBoard).
        
%------------------    
	move_block(Board, BlockCharacter, Direction, NewBoard):-
        can_block_move(Board, BlockCharacter, Direction),
        find_all_cords_of_block(Board, BlockCharacter, ListOfCords),
    	replace_cords_with_character(Board, Board1, ListOfCords, x),
        get_new_cords(ListOfCords, ListOfCords1, Direction),
        replace_cords_with_character(Board1, NewBoard, ListOfCords1, BlockCharacter).
        
%------------------


%------------------
    can_single_cell_move(Board, Y, X, Ydiff, Xdiff):-
        position(Board, Y, X, BlockCharacter),
        n_character(0, BlockCharacter, FirstBlockCharacter),
        Y1 is Y + Ydiff,
        X1 is X + Xdiff,
        position(Board, Y1, X1, CellCharacter),
        n_character(0, CellCharacter, FirstCellCharacter),
        (FirstCellCharacter = FirstBlockCharacter ; FirstCellCharacter = 'x').
%------------------



%------------------	
	can_every_cell_move(_, [], _, _).
	can_every_cell_move(Board, [H|T], Xdiff, Ydiff):-
        unpack_two_element_list(H, Y, X),
        can_single_cell_move(Board, Y, X, Xdiff, Ydiff), 
        can_every_cell_move(Board, T, Xdiff, Ydiff).
%------------------



%------------------
    can_block_move(Board, BlockCorner, Direction):-
        xydiff(Direction, Ydiff, Xdiff),
        find_all_cords_of_block(Board, BlockCorner, ListOfCords),
        can_every_cell_move(Board, ListOfCords, Ydiff, Xdiff).
%------------------


%------------------
        
	xydiff(D, Y, X):-
        D = 'left',
        Y is 0,
        X is -1.
	xydiff(D, Y, X):-
        D = 'right',
        Y is 0,
        X is 1.
	xydiff(D, Y, X):-
        D = 'up',
        Y is -1,
        X is 0.	
	xydiff(D, Y, X):-
        D = 'down',
        Y is 1,
        X is 0.
%------------------


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
	

