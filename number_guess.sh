#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
#enter user name
echo "Enter your username:"
read NAME
#check name if present in db
CHECK_NAME=$($PSQL "select username from users where username='$NAME'")
NUMBER_OF_GAMES_PLAYED=$($PSQL "select count(*) from users inner join games using(user_id) where username='$NAME'")
BEST_NUMBER_OF_GUESS=$($PSQL "select min(number_of_guesses) from users inner join games using(user_id) where username='$NAME'")

if [[ -z $CHECK_NAME ]]
  then
    INSERT_USER=$($PSQL "insert into users(username) values('$NAME')")
    echo "Welcome, $NAME! It looks like this is your first time here."
  else
    echo "Welcome back, $NAME! You have played $NUMBER_OF_GAMES_PLAYED games, and your best game took $BEST_NUMBER_OF_GUESS guesses."
fi

RAND_NUM=$((1 + RANDOM % 1000))
GUESS_COUNT=1
echo "Guess the secret number between 1 and 1000:"

while read INPUT
do
  if [[ ! $INPUT =~  ^[0-9]+$ ]]
    then
    echo "That is not an integer, guess again:"
    else
      if [[ $INPUT -eq $RAND_NUM ]]
        then
        break
        else
          if [[ $INPUT -gt $RAND_NUM ]]
            then
            echo "It's lower than that, guess again:"
            elif [[ $INPUT -lt $RAND_NUM ]]
            then
            echo "It's higher than that, guess again:"
          fi
      fi
  fi
  GUESS_COUNT=$(($GUESS_COUNT+1))
done
if [[ $GUESS_COUNT == 1 ]]
then
echo "You guessed it in $GUESS_COUNT tries. The secret number was $RAND_NUM. Nice job!"
else 
echo "You guessed it in $GUESS_COUNT tries. The secret number was $RAND_NUM. Nice job!"
fi
FETCH_USERID_OF_PLAYER=$($PSQL "select user_id from users where username='$NAME'")
INSERT_INTO_GAMES=$($PSQL "insert into games(number_of_guesses, user_id) values($GUESS_COUNT, $FETCH_USERID_OF_PLAYER)")