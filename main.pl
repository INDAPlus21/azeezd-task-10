% Taken and modified from https://gist.github.com/MuffinTheMan/7806903
% Get an element from a 2-dimensional list at (Row,Column)
% using 1-based indexing.
nth1_2d(Row, Column, List, Element) :-
    nth1(Row, List, SubList),
    nth1(Column, SubList, Element).


% Top-level predicate
alive(Row, Column, BoardFileName):-
    see(BoardFileName),     % Loads the input-file
    read(Board),            % Reads the first Prolog-term from the file
    seen,                   % Closes the io-stream
    check_alive(Row, Column, Board).

% Checks whether the group of stones connected to
% the stone located at (Row, Column) is alive or dead.
check_alive(Row, Column, Board):-
    nth1_2d(Row, Column, Board, Stone),
    (Stone = b; Stone = w),
    search_for_liberty(Row, Column, Board, Stone, []).

% Checks if an element (coordinate in this case) is in a given list
visited(Coord, [HCoord|TCoords]) :- Coord = HCoord ; visited(Coord, TCoords).

% Recursively move through grouped pieces until reaching empty or enemy stone.
% Empty returns true for the recursion search
% Enemy stone returns false for the search
% Logical OR is put between all those searches (The search is either in search 1 OR search 2 OR ...)
search_for_liberty(Row, Column, Board, Stone, Visited) :-
    \+ visited([Row, Column], Visited),         % We have NOT visited this coordinate before
    nth1_2d(Row, Column, Board, This_Stone),    % Get the stone at this place
                                                % This stone is either empty or coloured
    ((This_Stone = e);                          % Empty returns true (Found Liberty!!)
    ((This_Stone = Stone),                      % Same colour of stone, continue searching!
        Down is Row + 1,                        % Get all four non-diagonal directions. (Prolog doesn't allow inline arithmetics)
        Up is Row - 1,
        Right is Column + 1,
        Left is Column - 1,(

                     % Next coords                      Append position to visited
    search_for_liberty(Up, Column, Board, This_Stone, [[Row, Column] | Visited]);
    search_for_liberty(Down, Column, Board, This_Stone, [[Row, Column] | Visited]);
    search_for_liberty(Row, Left, Board, This_Stone, [[Row, Column] | Visited]);
    search_for_liberty(Row, Right, Board, This_Stone, [[Row, Column] | Visited])))).
