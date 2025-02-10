#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.

# if there is an argument
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
    SYMBOL=$($PSQL "SELECT symbol from elements where atomic_number=$1")
    NAME=$($PSQL "SELECT name from elements where atomic_number=$1")
  else
    RES=$($PSQL "select atomic_number from elements where symbol='$1';")
    if [[ -z $RES ]]
    then
      NAME=$1
      ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where NAME='$1';")
      SYMBOL=$($PSQL "select symbol from elements where NAME='$1';")
    else
      SYMBOL=$1
      ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where SYMBOL='$1';")
      NAME=$($PSQL "select name from elements where SYMBOL='$1';")
    fi
  fi

  # if any of these is empty
  if [[ -z $SYMBOL || -z $NAME || -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    # echo properties
    TYPE_ID=$($PSQL "select TYPE_ID from properties where atomic_number=$ATOMIC_NUMBER;")
    TYPE=$($PSQL "select TYPE from types where type_id=$TYPE_ID;")
    ATOMIC_MASS=$($PSQL "select ATOMIC_MASS from properties where atomic_number=$ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "select MELTING_POINT_CELSIUS from properties where atomic_number=$ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "select BOILING_POINT_CELSIUS from properties where atomic_number=$ATOMIC_NUMBER;")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi