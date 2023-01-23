-- 1st
-- 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.

# MAIN QUERY
SELECT * FROM ipl_bidder_details;     -- I_BIDDER_D
SELECT * FROM ipl_bidding_details;     --    I_BIDDING_D
SELECT * FROM ipl_bidder_points;        -- I_BIDDER_POINTS

select I_BIDDER_D.BIDDER_ID,    I_BIDDER_D.BIDDER_NAME,
(select count(BIDDER_ID) from IPL_BIDDING_DETAILS AS I_BIDDING_D
where I_BIDDING_D.bid_status='won' and I_BIDDING_D.bidder_id= I_BIDDER_D.bidder_id )/
(select NO_OF_BIDS from IPL_BIDDER_POINTS I_BIDDER_P where I_BIDDER_D.bidder_id=I_BIDDER_P.bidder_id)*100 as WIN_PERCENTAGE
from IPL_BIDDER_DETAILS I_BIDDER_D order by WIN_PERCENTAGE desc;


-- 2nd
-- 2.	Display the number of matches conducted at each stadium with stadium name, city from the database.
select i_s.stadium_name ,i_s.city ,count(ims.match_id) as number_matches from ipl_stadium I_s join ipl_match_schedule ims 
  on i_s.stadium_id=ims.stadium_id 
  group by i_s.stadium_name
  order by number_matches desc;
  
  
  -- 3rd
  -- 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?
  select i_s.stadium_name,
(select count(*) from  ipl_match im join ipl_match_schedule ims
on im.match_id=ims.match_id
where im.toss_winner=im.match_winner and i_s.stadium_id=ims.stadium_id)/
(select count(*) from ipl_match_schedule ims where i_s.stadium_id=ims.stadium_id) *100 as percentage_wins 
from ipl_stadium i_s;

-- by using case statement
select ipl_stadium.stadium_name,
round(sum(case when ipl_match.toss_winner = ipl_match.match_winner then 1 
else 0
end)*100/count(ipl_match.match_id),2) as tosswin_matchwin_percentage
from ipl_stadium
join ipl_match_schedule
on ipl_match_schedule.stadium_id =ipl_stadium.stadium_id
join ipl_match 
on ipl_match_schedule.match_id = ipl_match.match_id
group by ipl_stadium.stadium_name;
  
  -- 4th 
  -- 4.	Show the total bids along with bid team and team name.
select i_t.team_name,ibd.bid_team ,count(ibd.bid_team) as total_bids from 
ipl_bidding_details ibd join ipl_team i_t
on ibd.bid_team=i_t.team_id
group by ibd.bid_team
order by ibd.bid_team;


-- 5th
-- 5.	Show the team id who won the match as per the win details.
select match_id,
case when match_winner=1 then team_id1 
else  team_id2
end as team_id
from ipl_match;

-- 6th
-- 6.	Display total matches played, total matches won and total matches lost by team along with its team name.
select i_t.team_name,sum(its.matches_played), sum(its.matches_won) as to_matches_won,sum(its.matches_lost) as to_matches_lost 
from ipl_team i_t join ipl_team_standings its 
on i_t.team_id=its.team_id
group by i_t.team_name;


-- 7th
-- 7.	Display the bowlers for Mumbai Indians team.

select i_t.team_name,itm.player_id,itm.player_role,i_p.player_name from 
ipl_team i_t join ipl_team_players itm using(team_id) 
join ipl_player i_p using (player_id) 
where i_t.team_name="Mumbai Indians" and itm.player_role="bowler";

-- 8th
-- 8.	How many all-rounders are there in each team, Display the teams with more than 4 
-- all-rounder in descending order.

select i_t.team_name,itm.player_id,count(itm.player_role) as number_of_all_rounder from 
ipl_team i_t join ipl_team_players itm using(team_id) 
where itm.player_role="All-Rounder"
group by i_t.team_name
having number_of_all_rounder>4
order by number_of_all_rounder desc
;

























