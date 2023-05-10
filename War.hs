module War (deal) where

import Data.List
import GHC.RTS.Flags (GCFlags(stkChunkBufferSize))


{--
Function stub(s) with type signatures for you to fill in are given below. 
Feel free to add as many additional helper functions as you want. 

The tests for these functions can be found in src/TestSuite.hs. 
You are encouraged to add your own tests in addition to those provided.

Run the tester by executing 'cabal test' from the war directory 
(the one containing war.cabal)
--}
    
deal :: [Int] -> [Int] --Deal function that inputs the shuffeled deck and will return the winner of game
deal shuf = 
    let (player1deck, player2deck) = reverseDecks (decks (changeAceTo14 shuf)) -- Gives each player there own deck by calling the reverseDecks function and changes the value of Ace (1 to 14) by using the function changeAceTo14 
        winner = changeAceTo1 (playWar player1deck player2deck []) -- Determines the winner of the game by calling playWar and changes the Ace value back to 1 by using the function changeAceTo1
    in winner -- winner is returned as the result of the deal function by using in



changeAceTo14 :: [Int] -> [Int] --Function that is used to change 1 to 14 as 1 is the highest card in the game system 
changeAceTo14 = map (\x -> if x == 1 then 14 else x) -- Maps the list and changes all the 1s to 14s 


changeAceTo1 :: [Int] -> [Int] --Function that is used to change 14 back to 1 as that is how ace is repersented in the system
changeAceTo1 = map (\x -> if x == 14 then 1 else x) -- Maps the list and changes all the 14s to 1s 

decks :: [Int] -> ([Int], [Int]) --Function that will be used to split the original deck into 2 hands (1 for each player)
decks [] = ([], []) -- if the input is empty than 2 empty lists to repersent each players deck
decks [card] = ([card],[]) --If the input has one card than it will go the first players deck
decks (card1:card2:cards) = (card1: player1_cards', card2: player2_cards') --If the input has 2 or more cards than the deck will be split into 2 decks alternating each card to each player 
    where(player1_cards', player2_cards') = decks cards -- Recusivley calls until the deck is empty

reverseDecks :: ([Int], [Int]) -> ([Int],[Int]) -- Function that gets both plays decks and flips them for them to be in the correct order to play and returns the decks that will they be using
reverseDecks (player1_deck, player2_deck) = (reverse player1_deck, reverse player2_deck) -- Reverse both players decks

playWar :: [Int] -> [Int] -> [Int] -> [Int] -- Function that will be used to play the game War takes 3 arguments player 1s deck player2 deck and the warchest
playWar [] [] warchest = warchest -- If both plays have no more cards remaining than it will return the warchest
playWar player1_deck [] warchest = player1_deck ++ reverse warchest -- If player2s deck is empty than player1 is the winner so it will return player1s deck with the contents in the warchest
playWar [] player2_deck warchest = player2_deck ++ reverse warchest -- If player1s deck is empty than player2 is the winner so it will return player2s deck with the contents in the warchest
playWar (p1_card:p1_deck) (p2_card: p2_deck) warchest = -- When both players have cards they are able to play the game War
    let 
        battleCards = reverse $ sort $ p1_card : p2_card : warchest -- Stores the cards that the players will be using to battle and ensures it is in decending order
    in 
        if p1_card > p2_card then -- When player1s card is bigger than player2s card
            playWar(p1_deck ++ battleCards) p2_deck [] -- Recalls playWar as the game is not done and adds the cards player1 has just won to the end of player1s deck in decsending order
        else if p2_card > p1_card then -- When player2s card is bigger than player1s card
            playWar p1_deck (p2_deck ++ battleCards) [] --Recalls playWar as the game is not done and adds the cards player2 has just won to the end of player2s deck in decsending order
        else if length p1_deck >=2 && length p2_deck >= 2 then -- If both player1 and player2 cards are equal than there is a war so we check to make sure that both players have more than 2 cards to continute playing
            let
                (p1FacedownCard:p1_deck') = p1_deck --Stores the first card in player1s deck to as the facedownCard as that is the card that will be wagered in the war
                (p2FacedownCard:p2_deck') = p2_deck --Stores the first card in player2s deck to as the facedownCard as that is the card that will be wagered in the war
            in
                playWar p1_deck' p2_deck' (battleCards ++ [p1FacedownCard, p2FacedownCard]) -- Recalls the playWar function as there is a war and winner will be taking all the cards added to battleCards
        else
            playWar p1_deck p2_deck battleCards --Recalls playWar if there cards are equal and have less than 2 cards to continue playing 
