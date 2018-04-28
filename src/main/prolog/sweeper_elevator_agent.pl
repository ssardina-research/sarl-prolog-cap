/** 
 * SARL-Prolog-Elevator - Elevator controller for the SARL Elevator
 * Simulator with Prolog-based theoretical reasoning capabilities
 * Copyright (C) 2017 Matthew McNally.

 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * sweeper_elevator_agent
 * Beliefs held by a Sweeper Elevator Agent in terms of which
 * open car or floor requests to handle at any one time during
 * the simulation
 */

:- dynamic
	active_job/2,
	open_floor_request/1,
	open_car_request/2.


get_iso_time(T) :-
    get_time(X), 
    format_time(atom(T),'%Y-%m-%d--%H:%M:%S',X,posix).

save_db(ID) :-
	(var(ID) -> ID = default ; true),
	string_to_atom(SID, ID),
	get_iso_time(T), !,
	strings_concat(["kb-", SID, "-", T, ".pl"], FileName),
	open(FileName, write, F), 
	set_output(F), 
	listing,
	close(F).
	
	
	
% Concatenate a list of strings
strings_concat([], "").
strings_concat([S|L], CS) :-
	strings_concat(L, CS2),
	string_concat(S, CS2, CS).
	
% The default one at start
active_job(0, up).
	
	
/**
 * direction(-Direction:atom) is semidet.
 *
 * Represents a valid elevator travel direction.
 */
direction(up).
direction(down).

/**
 * open_request(-Destination:int) is nondet.
 *
 * Destination unifies with a floor which has
 * been requested by a person in the simulation.
 */
open_request(Destination) :- open_floor_request(Destination).
open_request(Destination) :- open_car_request(Destination, _).

/**
 * next_job(-Destination:int, -Direction:atom) is semidet.
 *
 * Determine destination request with most utility
 * which should be handled following completion of the
 * current active job and specify the best direction
 * of travel following satisfaction of this job.
 */
next_job(Destination, Direction) :-
	active_job(CurrentDestination, AdvertisedDirection),
	next_job(Destination, Direction, CurrentDestination, AdvertisedDirection).

/**
 * next_job(-Destination:int, -Direction:atom, +Floor:int, +AdvertisedDirection:atom) is semidet.
 * 
 * Determine request with most utility to handle next,
 * accounting for world state following completion of active job.
 */
next_job(Destination, Direction, Floor, AdvertisedDirection) :-
    %! Establish direction from current job destination of
    %  best next request
	next_direction(DestinationDirection, AdvertisedDirection, Floor),
	%! Best request will be closest in direction with most utility
	closest_request_in_direction(Destination, DestinationDirection, Floor),
	%! Predict the direction which would be most efficient to travel
	%  in after we have fulfilled the next job
	next_direction(Direction, DestinationDirection, Destination).

/*
 * next_direction(-Direction:atom, +AdvertisedDirection:atom, +Floor:int) is semidet.
 *
 * Determine the direction of travel from the given floor
 * with the most utility, given an AdvertisedDirection.
 */
next_direction(AdvertisedDirection, AdvertisedDirection, Floor) :-
	open_car_request(Floor, AdvertisedDirection).
next_direction(AdvertisedDirection, AdvertisedDirection, Floor) :-
	request_in_direction(_, AdvertisedDirection, Floor).
next_direction(Direction, AdvertisedDirection, _) :-
	direction(Direction),
	Direction \= AdvertisedDirection.

/**
 * closest_request_in_direction(-Request:int, +Direction:atom, +Floor:int) is semidet.
 *
 * True if Request is the open request closest to Floor
 * in the direction Direction.
 */
closest_request_in_direction(Request, Direction, Floor) :-
	request_in_direction(Request, Direction, Floor),
	\+ (
		request_in_direction(Challenger, Direction, Floor),
		Challenger \= Request,
		is_closer(Challenger, Request, Floor)
	).

/**
 * request_in_direction(-Request:int, +Direction:atom, +Floor:int) is semidet.
 *
 * True if Request is an open request in the direction Direction
 * from Floor.
 */
request_in_direction(Request, Direction, Floor) :-
	open_request(Request),
	reachable_in_direction(Floor, Direction, Request).

/**
 * reachable_in_direction(++Start:int, -Direction:atom, ++End:int) is semidet.
 *
 * True if End can be reached from Start
 * by travelling in the given direction.
 */
reachable_in_direction(Start, up, End) :- End > Start.
reachable_in_direction(Start, down, End) :- Start > End.

/**
 * is_closer(++X:int, ++Y:int, ++Z:int) is semidet.
 *
 * True if floor X is closer to floor Z than floor Y.
 */
is_closer(X, Y, Z) :- abs(Z - X) < abs(Z - Y).