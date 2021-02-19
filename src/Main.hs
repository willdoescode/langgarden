module Main where

import System.Environment (getArgs)
import System.IO
import Data.Word
import Text.Parsec
import Text.Parsec.String
import Control.Monad.State

data Gardens = Print
  | Add
  | Sub
  | NL
  | Loop [Gardens]
  deriving (Show)

generateParser :: Char -> Gardens -> Parser Gardens
generateParser x y = char x >> return y

parsePrint, parseAdd, parseSub, parseNL, parseLoop :: Parser Gardens
parsePrint = generateParser '|' Print
parseAdd = generateParser '{' Add
parseSub = generateParser '}' Sub
parseNL = generateParser '>' NL

parseLoop = do
  _ <- char '@'
  out <- parseGarden
  _ <- char '#'
  return $ Loop out

parseNotchar :: Parser ()
parseNotchar = do
  _ <- many $ noneOf "|{}>@#"
  return ()

gardenInstruction :: Parser Gardens
gardenInstruction = do
  parseNotchar
  i <- parseAdd <|> parseSub <|> parsePrint <|> parseNL <|> parseLoop
  parseNotchar
  return i

parseGarden :: Parser [Gardens]
parseGarden = many gardenInstruction

type GardenRunner = StateT Word8 IO ()
runGarden :: Gardens -> GardenRunner
runGardens :: [Gardens] -> GardenRunner
runGardens = mapM_ runGarden

runGarden Print = do
  stack <- get
  liftIO $ putChar $ toEnum $ fromIntegral stack
--  liftIO $ print $ stack

runGarden Add = modify (\stack -> toEnum $ fromIntegral $ stack + 1)
runGarden Sub = modify (\stack -> stack - 1)

runGarden loop@(Loop out) = do
  stack <- get
  case stack of
    0 -> return ()
    _ -> runGardens out >> runGarden loop

runGarden NL = do
  liftIO $ putStrLn ""

main :: IO ()
main = do
  args <- getArgs
  let fileName = head args
  file <- openFile fileName ReadMode
  contents <- hGetContents file
  case parse parseGarden fileName contents of
    Left e -> print e
    Right out -> evalStateT (runGardens out) 0
--    Right out -> print out
