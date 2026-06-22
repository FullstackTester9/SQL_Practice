--CREATE DATABASE SOCCER
--GO

--USE SOCCER
--GO
--use master
--drop database SOCCER
-- ==========================================
-- COUNTRY
-- ==========================================

CREATE TABLE soccer_country (
    country_id NUMERIC PRIMARY KEY,
    country_abbr VARCHAR(4),
    country_name VARCHAR(40)
);

-- ==========================================
-- CITY
-- ==========================================

CREATE TABLE soccer_city (
    city_id NUMERIC PRIMARY KEY,
    city VARCHAR(25),
    country_id NUMERIC,
    FOREIGN KEY (country_id)
        REFERENCES soccer_country(country_id)
);

-- ==========================================
-- VENUE
-- ==========================================

CREATE TABLE soccer_venue (
    venue_id NUMERIC PRIMARY KEY,
    venue_name VARCHAR(30),
    city_id NUMERIC,
    aud_capacity NUMERIC,
    FOREIGN KEY (city_id)
        REFERENCES soccer_city(city_id)
);

-- ==========================================
-- PLAYING POSITION
-- ==========================================

CREATE TABLE playing_position (
    position_id VARCHAR(2) PRIMARY KEY,
    position_desc VARCHAR(15)
);

-- ==========================================
-- TEAM
-- ==========================================

CREATE TABLE soccer_team (
    team_id NUMERIC PRIMARY KEY,
    team_group CHAR(1),
    match_played NUMERIC,
    won NUMERIC,
    draw NUMERIC,
    lost NUMERIC,
    goal_for NUMERIC,
    goal_against NUMERIC,
    goal_diff NUMERIC,
    points NUMERIC,
    group_position NUMERIC
);

-- ==========================================
-- PLAYER
-- ==========================================

CREATE TABLE player_mast (
    player_id NUMERIC PRIMARY KEY,
    team_id NUMERIC,
    jersey_no NUMERIC,
    player_name VARCHAR(40),
    posi_to_play VARCHAR(2),
    dt_of_bir DATE,
    age NUMERIC,
    playing_club VARCHAR(40),

    FOREIGN KEY (team_id)
        REFERENCES soccer_team(team_id),

    FOREIGN KEY (posi_to_play)
        REFERENCES playing_position(position_id)
);

-- ==========================================
-- REFEREE
-- ==========================================

CREATE TABLE referee_mast (
    referee_id NUMERIC PRIMARY KEY,
    referee_name VARCHAR(40),
    country_id NUMERIC,

    FOREIGN KEY (country_id)
        REFERENCES soccer_country(country_id)
);

-- ==========================================
-- ASSISTANT REFEREE
-- ==========================================

CREATE TABLE asst_referee_mast (
    ass_ref_id NUMERIC PRIMARY KEY,
    ass_ref_name VARCHAR(40),
    country_id NUMERIC,

    FOREIGN KEY (country_id)
        REFERENCES soccer_country(country_id)
);

-- ==========================================
-- COACH
-- ==========================================

CREATE TABLE coach_mast (
    coach_id NUMERIC PRIMARY KEY,
    coach_name VARCHAR(40)
);

-- ==========================================
-- TEAM COACHES
-- ==========================================

CREATE TABLE team_coaches (
    team_id NUMERIC,
    coach_id NUMERIC,

    PRIMARY KEY (team_id, coach_id),

    FOREIGN KEY (team_id)
        REFERENCES soccer_team(team_id),

    FOREIGN KEY (coach_id)
        REFERENCES coach_mast(coach_id)
);

-- ==========================================
-- MATCH MASTER
-- ==========================================

CREATE TABLE match_mast (
    match_no NUMERIC PRIMARY KEY,
    play_stage CHAR(1),
    play_date DATE,
    results CHAR(5),
    decided_by CHAR(1),
    goal_score CHAR(5),
    venue_id NUMERIC,
    referee_id NUMERIC,
    audience NUMERIC,
    plr_of_match NUMERIC,
    stop1_sec NUMERIC,
    stop2_sec NUMERIC,

    FOREIGN KEY (venue_id)
        REFERENCES soccer_venue(venue_id),

    FOREIGN KEY (referee_id)
        REFERENCES referee_mast(referee_id),

    FOREIGN KEY (plr_of_match)
        REFERENCES player_mast(player_id)
);

-- ==========================================
-- MATCH DETAILS
-- ==========================================

CREATE TABLE match_details (
    match_no NUMERIC,
    play_stage VARCHAR(1),
    team_id NUMERIC,
    win_lose VARCHAR(1),
    decided_by VARCHAR(1),
    goal_score NUMERIC,
    penalty_score NUMERIC,
    ass_ref NUMERIC,
    player_gk NUMERIC,

    PRIMARY KEY (match_no, team_id),

    FOREIGN KEY (match_no)
        REFERENCES match_mast(match_no),

    FOREIGN KEY (team_id)
        REFERENCES soccer_team(team_id),

    FOREIGN KEY (ass_ref)
        REFERENCES asst_referee_mast(ass_ref_id),

    FOREIGN KEY (player_gk)
        REFERENCES player_mast(player_id)
);

-- ==========================================
-- PLAYER SUBSTITUTIONS
-- ==========================================

CREATE TABLE player_in_out (
    match_no NUMERIC,
    team_id NUMERIC,
    player_id NUMERIC,
    in_out CHAR(1),
    time_in_out NUMERIC,
    play_schedule CHAR(2),
    play_half NUMERIC,

    PRIMARY KEY (match_no, team_id, player_id),

    FOREIGN KEY (match_no)
        REFERENCES match_mast(match_no),

    FOREIGN KEY (team_id)
        REFERENCES soccer_team(team_id),

    FOREIGN KEY (player_id)
        REFERENCES player_mast(player_id)
);

-- ==========================================
-- PLAYER BOOKINGS
-- ==========================================

CREATE TABLE player_booked (
    match_no NUMERIC,
    team_id NUMERIC,
    player_id NUMERIC,
    booking_time VARCHAR(40),
    sent_off CHAR(1),
    play_schedule CHAR(2),
    play_half NUMERIC,

    PRIMARY KEY (match_no, team_id, player_id),

    FOREIGN KEY (match_no)
        REFERENCES match_mast(match_no),

    FOREIGN KEY (team_id)
        REFERENCES soccer_team(team_id),

    FOREIGN KEY (player_id)
        REFERENCES player_mast(player_id)
);

-- ==========================================
-- GOAL DETAILS
-- ==========================================

CREATE TABLE goal_details (
    goal_id NUMERIC PRIMARY KEY,
    match_no NUMERIC,
    player_id NUMERIC,
    team_id NUMERIC,
    goal_time NUMERIC,
    goal_type CHAR(1),
    play_stage CHAR(1),
    goal_schedule CHAR(2),
    goal_half NUMERIC,

    FOREIGN KEY (match_no)
        REFERENCES match_mast(match_no),

    FOREIGN KEY (player_id)
        REFERENCES player_mast(player_id),

    FOREIGN KEY (team_id)
        REFERENCES soccer_team(team_id)
);

-- ==========================================
-- MATCH CAPTAIN
-- ==========================================

CREATE TABLE match_captain (
    match_no NUMERIC,
    team_id NUMERIC,
    player_captain NUMERIC,

    PRIMARY KEY (match_no, team_id),

    FOREIGN KEY (match_no)
        REFERENCES match_mast(match_no),

    FOREIGN KEY (team_id)
        REFERENCES soccer_team(team_id),

    FOREIGN KEY (player_captain)
        REFERENCES player_mast(player_id)
);

-- ==========================================
-- PENALTY GOALKEEPER
-- ==========================================

CREATE TABLE penalty_gk (
    match_no NUMERIC,
    team_id NUMERIC,
    player_gk NUMERIC,

    PRIMARY KEY (match_no, team_id),

    FOREIGN KEY (match_no)
        REFERENCES match_mast(match_no),

    FOREIGN KEY (team_id)
        REFERENCES soccer_team(team_id),

    FOREIGN KEY (player_gk)
        REFERENCES player_mast(player_id)
);

-- ==========================================
-- PENALTY SHOOTOUT
-- ==========================================

CREATE TABLE penalty_shootout (
    kick_id NUMERIC PRIMARY KEY,
    match_no NUMERIC,
    team_id NUMERIC,
    player_id NUMERIC,
    score_goal VARCHAR(1),
    kick_no NUMERIC,

    FOREIGN KEY (match_no)
        REFERENCES match_mast(match_no),

    FOREIGN KEY (team_id)
        REFERENCES soccer_team(team_id),

    FOREIGN KEY (player_id)
        REFERENCES player_mast(player_id)
);