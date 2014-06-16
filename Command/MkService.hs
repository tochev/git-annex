{- git-annex command, Windows specific
 -
 - Copyright 2014 Joey Hess <joey@kitenet.net>
 -
 - Licensed under the GNU GPL version 3 or higher.
 -}

module Command.MkService where

import Common.Annex
import Command
import Types.StandardGroups
import Annex.MakeRepo

def :: [Command]
def = [noCommit $ noRepo startNoRepo $ dontCheck repoExists $
	command "mkservice" paramPath seek SectionSetup "make windows service"]

seek :: CommandSeek
seek = withWords start

start :: [FilePath] -> CommandStart
start ps = do
	liftIO $ startNoRepo ps
	stop

startNoRepo :: [FilePath] -> IO ()
startNoRepo (dir:_) = do
	isnew <- Local.makeRepo dir False
	void $ Local.initRepo isnew True dir Nothing (Just ClientGroup)
	permHack dir
startNoRepo _ = error "specify repository path that service will use"

{- A Windows service runs as some special user, so that user needs write
 - access to the .git directory. So does whatever user is using the windows
 - desktop. -}
permHack :: FilePath -> IO ()
permHack dir = TODO
