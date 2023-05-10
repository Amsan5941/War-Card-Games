defmodule War do
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add
    as many additional helper functions as you want.

    The tests for the deal function can be found in test/war_test.exs.
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory
    (the one containing mix.exs)
  """
  def deal(shuf) do #Function that will deal the deck given
    {player1_deck, player2_deck} = shuf |> Enum.map(fn x -> if x==1, do: 14, else: x end) |> Enum.reverse() |> deal_deck() #Uses the input shuf given by the function and maps/changes the values from 1 to 14 (since 1 repersents ace the higest card so changing it to the highest number in the list will make coding the game easier) and than reverses the list and than calls deal deck to divide shuf into 2 decks for each player

      #IO.inspect(player1_deck) #Used to check if player1 deck is correct
      #IO.inspect(player2_deck) #Used to check if player2 deck is correct

      win = play_war(player1_deck, player2_deck) #Calls the play_war function with the two decks to determine who the winner is or if they are tied
      Enum.map(win, fn x-> if x==14, do: 1, else: x end) #Changes the winners cards or the warchest cards from 14 to 1 since all the 1's were changed to 14's
    end

    def deal_deck(shuf) do #Function that will be used to split the deck of cards into 2 decks for each player
      Enum.reduce(shuf, {[], []}, fn card, {player1_deck, player2_deck} -> #Splits the input list shuf into 2 lists (decks) by iteraring through Enum.reduce ensuring each player gets the same amount of cards and the correct card
        if length(player1_deck) < length(player2_deck) do #If player1 has less cards than player2 than player1 will get a card

          {player1_deck ++ [card], player2_deck} #Adds card too player1's deck

        else #When player2 has more cards or equal amount of cards to player 1
        {player1_deck, player2_deck ++ [card]} #Adds card too player2's deck
      end
    end)
  end

  def play_war(player1_deck, player2_deck, warchest \\ []) #Defines a function that takes the arguments player1_deck, player2_deck, and warchest (optional argument) which will recursivley play the game until there is a winner or a tie

  def play_war([], [], warchest) do  #When both decks are empty
    Enum.sort(warchest, :desc) #Returns warchest (there is a tie) in descending order
  end

  def play_war(player1_deck, [], warchest) do #When player 2 has no cards left in this deck
    player1_deck ++ Enum.sort(warchest, :desc) #Adds the warchest to player1 deck in descending order and return the winner (player1's deck)
  end

  def play_war([], player2_deck, warchest) do  #When player 1 has no cards left in this deck
    player2_deck ++ Enum.sort(warchest) #Adds the warchest to player2 deck in descending order and return the winner (player2's deck)
  end

  def play_war([player1_card | rest_player1_deck], [player2_card | rest_player2_deck], warchest) do #Function used to play war that is recusivley called gets the head (first card) of player1 and player2 deck and the tail (rest of the deck with out the first card)
    battle_cards = Enum.sort([player1_card, player2_card] ++ warchest, :desc) #Takes both players first card and the cards in the warchest and sorts them in descending order. This stores all the cards that were used for each round and sort it in descending order and will be sent to the end of the deck of the winning player of the current round (war)
    case player1_card > player2_card do #Check to see if player1's card is bigger than player2's card
      true ->
        play_war(rest_player1_deck ++ battle_cards, rest_player2_deck) #If its true add player2s and player1s card to the end of player1s deck because they won the current war round and by using battle cards as these are the cards that were used for war
      false ->
        case player2_card > player1_card do #If it is false we will check if player2s card is bigger than player1s card
          true ->
            play_war(rest_player1_deck, rest_player2_deck ++ battle_cards)  #If its true add player2s and player1s card to the end of player2s because they won the current war round and deck by using battle cards as these are the cards that were used for war

          false when rest_player1_deck != [] and rest_player2_deck != [] -> #If none of the statments are true that means both player1 and player2 cards are equal making them have a war this is used to check that both players have cards for the war (that their decks are not empty)
            [p1_facedowncard | rest_player1_deck] = rest_player1_deck #Get the first card of player1 deck this will be the card that is faced down
            [p2_facedowncard | rest_player2_deck] = rest_player2_deck #Get the first card of player2 deck this will be the card that is faced down
            play_war(rest_player1_deck, rest_player2_deck, battle_cards ++ [p1_facedowncard, p2_facedowncard]) #Recursivley calls the play_war function with the updated player1 and player2 deck and adds the facedown cards to the battle_cards list as these cards are now in the wager for the declared war

          _ -> #final case where neither player won the war and still have cards remining (another war has occured)
            play_war(rest_player1_deck, rest_player2_deck, battle_cards) #Recursivley calls the play_war function with the updated player_decks and the accumulated battle cards
        end
    end

  end








end

#shuf = [1,13,1,13,1,13,1,13,12,11,12,11,12,11,12,11,10,9,10,9,10,9,10,9,8,7,8,7,8,7,8,7,6,5,6,5,6,5,6,5,4,3,4,3,4,3,4,3,2,2,2,2] #used for debbugging purposes
#War.deal(shuf) #used for debbugging purposes
