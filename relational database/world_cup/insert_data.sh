#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# drop everythig from tables
echo $($PSQL "TRUNCATE games, teams; ALTER sequence teams_team_id_seq restart with 1; ALTER sequence games_game_id_seq restart with 1;")


function insert_team() {

  # get team_id
  TEAM_ID=$($PSQL "select team_id from teams where name='$1';")

  # if team_id not found insert that team
  if [[ -z $TEAM_ID ]]
  then
    INSERT_TEAMS_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$1');")
    if [[ $INSERT_TEAMS_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $1
    fi
  fi

}

function insert_game() {
  
  INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES('$1','$2', $3, $4, $5, $6);")
  if [[ $INSERT_GAMES_RESULT == "INSERT 0 1" ]]
  then
    echo Inserted into games. 
  fi

}

cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals 
do
  # if it is not first row
  if [[ $year != 'year' ]]
  then
    insert_team "$winner"
    insert_team "$opponent"

    WINNER_ID=$($PSQL "select team_id from teams where name='$winner';")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$opponent';")
    insert_game $year "$round" $winner_goals $opponent_goals $WINNER_ID $OPPONENT_ID
  fi
done
