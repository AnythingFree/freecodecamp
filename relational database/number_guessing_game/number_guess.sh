#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read username

# get user info
check=$($PSQL "select username_id from info where username='$username';")
if [[ -z $check ]]
then
  games_played=0
  best_game=0
  echo Welcome, $username! It looks like this is your first time here.
  s=$($PSQL "insert into info(username, games_played, best_game) values('$username', $games_played, $best_game);")
else
  games_played=$($PSQL "select games_played from info where username='$username';")
  best_game=$($PSQL "select best_game from info where username='$username';")
  echo Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses.
fi

# create secret number
secret_number=$(( ( RANDOM % 1000 )  + 1 ))
number_of_guesses=1
echo $secret_number

echo "Guess the secret number between 1 and 1000:"
read guess

# check everything asked and wait for the correct guess
while [[ "$secret_number" -ne "$guess" ]]; do

  if ! [[ "$guess" =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ "$secret_number" -lt "$guess" ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi

  number_of_guesses=$(($number_of_guesses + 1))
  read guess
done

# output message
echo You guessed it in $number_of_guesses tries. The secret number was $secret_number. Nice job!

# update vars
games_played=$((games_played + 1))
if [[ "$number_of_guesses" -lt "$best_game" || "$best_game" -eq 0 ]]
then
  best_game=$number_of_guesses
fi

# update database
s=$($PSQL "update info set games_played=$games_played, best_game=$best_game where username='$username';")


