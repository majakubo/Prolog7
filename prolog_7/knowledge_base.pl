%board([ [w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ],
%        [w  ,a  ,a  ,c  ,c  ,d  ,d  ,j  ,w  ],
%        [w  ,a  ,a  ,c  ,c  ,d  ,d  ,j  ,w  ],
%        [w  ,e  ,e  ,f  ,f  ,f  ,i  ,k ,w  ],
%        [w  ,b  ,b  ,f  ,f  ,g  ,i  ,k  ,w  ],
%        [w  ,b  ,b  ,h  ,h  ,h  ,l  ,l  ,w  ],
%        [w  ,b  ,b  ,x  ,x  ,x  ,l  ,l  ,w  ],
%        [w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ,w  ]]).


board([[w, w, w, w, w, w, w],   
       [w, a, b, x, x, x, w],   
       [w, x, x, x, x, x, w],
       [w, x, x, x, x, x, w],
       [w, w, w, w, w, w, w]]).

steps(2).
steps(4).
steps(8).
steps(16).
steps(32).




%block(b).
%block(c).
%block(d).
%block(e).
block(a).

direction(down).
direction(right).
direction(up).
direction(left).

height(a, X):- X is 1.
height(b, X):- X is 2.
height(c, X):- X is 3.
%height(d, X):- X is 4.
%height(e, X):- X is 5.
%height(f, X):- X is 6.
	

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


% PREDICATS

%------------------
	max_steps(MaxSteps):-
        board(Board),
    	find_all_objects(Board, Objects, 'x'),
     	length(Objects, MaxSteps). 
%------------------


%------------------
    n_character(N, Chars, Char):-
        string_chars(Chars, Str),
        nth0(N, Str, Char).	
%------------------	


%------------------
	position(Board, Y, X, Character):-
        nth0(Y, Board, Column),
        nth0(X, Column, Character).
%------------------


%------------------
	find_corner(Board, Y, X, Character):-
        position(Board, Y, X, Character), !.
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


%------------------
	find_all_objects(Board, Objects, Character):-
        append(Board, L),
    	find_all_objects_unwrap(L, [], Objects, Character).
	
	find_all_objects_unwrap([], ObjectsTemp, ObjectsTemp, _).
    
    find_all_objects_unwrap([H|T], ObjectsTemp, Objects, Character):-
        n_character(_, H, Character),
        add_element(ObjectsTemp, H, ObjectsTemp1),
    	find_all_objects_unwrap(T, ObjectsTemp1, Objects, Character),!.

    find_all_objects_unwrap([_|T], ObjectsTemp, Objects, Character):-
		find_all_objects_unwrap(T, ObjectsTemp, Objects, Character), !.

%------------------	

  

%------------------
    find_all_cords_of_block_unwrap(_, [], ListOfCords, ListOfCords).	
	
    find_all_cords_of_block_unwrap(Board, [H|T], ListOfCordsTemp, ListOfCords):-
         position(Board, Y, X, H),
         insert_into_two_dimensional_array(Y, X, 'T', Board, NewBoard),
    	 add_element(ListOfCordsTemp, [Y, X], ListOfCordsTemp1),
         find_all_cords_of_block_unwrap(NewBoard, T, ListOfCordsTemp1, ListOfCords), !.
    
	find_all_cords_of_block(Board, Character, ListOfCords):-
        find_all_objects(Board, Objects, Character),
        find_all_cords_of_block_unwrap(Board, Objects, [], ListOfCords).
%------------------


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
%------------------

%------------------
	get_new_cords(ListOfCords, NewListOfCords, Direction):-
    	xydiff(Direction, Ydiff, Xdiff),
        move_cordinates(ListOfCords, [], NewListOfCords, Ydiff, Xdiff).
%------------------


%------------------
    can_single_cell_move(Board, Y, X, Ydiff, Xdiff):-
        position(Board, Y, X, BlockCharacter),
        Y1 is Y + Ydiff,
        X1 is X + Xdiff,
        position(Board, Y1, X1, CellCharacter),
        (CellCharacter = BlockCharacter ; CellCharacter = 'x').
%------------------


%------------------	
	can_every_cell_move(_, [], _, _).
	can_every_cell_move(Board, [H|T], Xdiff, Ydiff):-
        unpack_two_element_list(H, Y, X),
        can_single_cell_move(Board, Y, X, Xdiff, Ydiff), 
        can_every_cell_move(Board, T, Xdiff, Ydiff).
%------------------


%------------------
    can_block_move(Board, Direction, ListOfCords):-
        xydiff(Direction, Ydiff, Xdiff),
        can_every_cell_move(Board, ListOfCords, Ydiff, Xdiff).
%------------------



%------------------    
	move_block(Board, BlockCharacter, Direction, NewBoard):-
    	find_all_cords_of_block(Board, BlockCharacter, ListOfCords),
        can_block_move(Board, Direction, ListOfCords),
    	replace_cords_with_character(Board, Board1, ListOfCords, x),
        get_new_cords(ListOfCords, ListOfCords1, Direction),
        replace_cords_with_character(Board1, NewBoard, ListOfCords1, BlockCharacter).
%------------------


%------------------
	%best move for the game
	one_step(Board, NewBoard):-
       move_block(Board, a, right, NewBoard), !.
	
	%random  move
	one_step(Board, NewBoard):-
       direction(Dir),
       block(BlockCharacter),
       move_block(Board, BlockCharacter, Dir, NewBoard).
%------------------
	

%------------------
	make_move(Board, Board, Steps, MaxSteps, Final_Y, Final_X, []):-
        not(Steps > MaxSteps),
        find_corner(Board, Y, X, a),
        Y is Final_Y,
        X is Final_X, 
    	!.
	make_move(Board, NewBoard, Steps, MaxSteps,  Final_Y, Final_X, MOVES):-
        not(Steps > MaxSteps),
        one_step(Board, BoardT),
        IncSteps is Steps + 1,
    	make_move(BoardT, NewBoard, IncSteps, MaxSteps, Final_Y, Final_X, MOVEST),
        MOVES = [BoardT | MOVEST],
    	!.
%------------------


%------------------ 

	rozwiaz(FinalY, FinalX, FinalBoard, MOVES):-
    	height(FinalY, Y),
        board(B),
    	steps(MaxSteps),
    	make_move(B, FinalBoard, 0, MaxSteps, Y, FinalX, MOVES), !.
     	
%------------------



%------------------	
	przem(StartY, StartX, EndY, EndX):-
        height(StartY, SY),
        height(EndY, EY),
    	
        board(B),
        max_steps(MaxSteps),
        przem_unwrap(B, SY, StartX, EY, EndX, 0, MaxSteps).
	
	przem_unwrap(_, StartY, StartX, EndY, EndX, Steps, MaxSteps):-
        not(Steps > MaxSteps),
    	StartX = EndX,
        StartY = EndY.

	przem_unwrap(Board, StartY, StartX, EndY, EndX, Steps, MaxSteps):-
        not(Steps > MaxSteps),
    	position(Board, StartY, StartX,  Char),
        direction(Dir),
        move_block(Board, Char, Dir, NewBoard),
        position(NewBoard, TempY, TempX, Char),
    	IncSteps = Steps + 1,
        przem_unwrap(NewBoard, TempY, TempX, EndY, EndX, IncSteps, MaxSteps). 
%------------------
