#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if no argument provided
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  ##########################################
  # This part is for the element
  # if argument is a number
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    #if argument is a string
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
    fi
  ##########################################
  # if atomic number cannot be found i.e. NULL
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    PROPERTIES=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM properties FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    echo $PROPERTIES | while IFS="|" read ATOMIC_NUMBER ATOMIC_MASS MP BP TYPE_ID
    do
      echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    done
  fi
fi
