#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -A -c"

echo -e "\n~~ My Salon ~~\n"

MAIN_MENU() {
  result=$($PSQL "select name, service_id from services;")
  
  echo "$result" | while IFS='|' read name service_id
  do  
    echo "$service_id) $name"
  done

  echo "Choose service?" 
  read SERVICE_ID_SELECTED
}

MAIN_MENU
case $SERVICE_ID_SELECTED in
    1)  ;;
    2)  ;;
    3)  ;;
    *) MAIN_MENU ;;
  esac

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")

if [[ -z $CUSTOMER_ID ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  res=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")
else
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")
fi

echo -e "\nWhat time would you like your cut?"
read SERVICE_TIME

res=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

SERVICE_NAME=$($PSQL "select name from services WHERE service_id=$SERVICE_ID_SELECTED;")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
