module Main where

import System.Environment (getArgs)
import System.IO
import Data.Word
import Text.Parsec
import Text.Parsec.String
import Control.Monad.State

debug :: Bool
debug = False

data Gardens = Print
  | Add
  | Sub
  | NL
  | Loop [Gardens]
  | AddLoop
  | SubLoop
  deriving (Show)

generateParser :: Char -> Gardens -> Parser Gardens
generateParser x y = char x >> return y

parsePrint, parseAdd, parseSub, parseNL, parseLoop, parseAddLoop, parseSubLoop :: Parser Gardens
parsePrint = generateParser '|' Print
parseAdd = generateParser '{' Add
parseSub = generateParser '}' Sub
parseNL = generateParser '>' NL
parseAddLoop = generateParser '[' AddLoop
parseSubLoop = generateParser ']' SubLoop

parseLoop = do
  _ <- char '@'
  out <- parseGarden
  _ <- char '#'
  return $ Loop out

parseNotchar :: Parser ()
parseNotchar = do
  _ <- many $ noneOf "|{}>@#[]"
  return ()

gardenInstruction :: Parser Gardens
gardenInstruction = do
  parseNotchar
  i <- parseAdd <|> parseSub <|>
   parsePrint <|> parseNL <|>
   parseLoop <|> parseAddLoop <|>
   parseSubLoop
  parseNotchar
  return i

parseGarden :: Parser [Gardens]
parseGarden = many gardenInstruction

type GardenRunner = StateT (Word8, Int) IO ()
runGarden :: Gardens -> GardenRunner
runGardens :: [Gardens] -> GardenRunner
runGardens = mapM_ runGarden

runGarden Print = do
  (stack, _) <- get
  liftIO $ putChar $ toEnum $ fromIntegral stack
  if debug then
    liftIO $ print stack
  else liftIO $ putStr ""

runGarden Add = modify (\(stack, loopStack) -> (toEnum $ fromIntegral $ stack + 1, loopStack))
runGarden Sub = modify (\(stack, loopStack) -> (stack - 1, loopStack))
runGarden AddLoop = modify (\(stack, loopStack) -> (stack, loopStack + 1))
runGarden SubLoop = modify (\(stack, loopStack) -> (stack, loopStack - 1))

runGarden loop@(Loop out) = do
  (_, loopStack) <- get
  case loopStack of
    0 -> return ()
    _ -> runGardens out >> runGarden loop

runGarden NL = do
  liftIO $ putStrLn ""

shell :: IO ()
shell = do
  putStrLn ""
  putStr "> "
  i <- getLine
  case parse parseGarden "" i of
      Left e -> print e
      Right out -> evalStateT (runGardens out) (0, 0)
  shell

main :: IO ()
main = do
  args <- getArgs
  if null args then
    shell
    else do
      let fileName = head args
      file <- openFile fileName ReadMode
      contents <- hGetContents file
      case parse parseGarden fileName contents of
        Left e -> print e
        Right out -> evalStateT (runGardens out) (0, 0)
--    Right out -> print out
