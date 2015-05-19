module MetaTests where

mail :: IO ()
mail = return ()


----- implementation details

class PlatformSpecificInterface a where
	refresh :: IO ()

data PlatformSpecificInterfaceWin

instance PlatformSpecificInterface PlatformSpecificInterfaceWin where
	refresh = return () 


----- lib user interface


data EventState

data EventSequence

data EventTransaction

data EventPrecondition