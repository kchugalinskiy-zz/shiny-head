module Graphics.UI.InterfaceDescription where

import Graphics.UI.InterfaceDatatypes

import Control.Monad (ap)
import Control.Applicative (Applicative(..))

data InterfaceDescription a =
	InterfaceDescription a [FrameElement]
	deriving (Show)

instance Applicative InterfaceDescription where
	pure = return
	(<*>) = ap

instance Monad InterfaceDescription where
	(>>=) oldState@(InterfaceDescription val _) func = 
				mergeUI oldState newState
			where
				newState = func val
	(>>) = mergeUI
	return val = InterfaceDescription val []

instance Functor InterfaceDescription where
	fmap f (InterfaceDescription value config) = InterfaceDescription (f value) config

getTopLevelElements :: InterfaceDescription a -> [FrameElement]
getTopLevelElements (InterfaceDescription _ value) = value

mergeUI :: InterfaceDescription a -> InterfaceDescription b -> InterfaceDescription b
mergeUI (InterfaceDescription _ frameElems1) (InterfaceDescription val frameElems2) =
	InterfaceDescription val $ frameElems1 ++ frameElems2

label :: Class -> Id -> InterfaceDescription ()
label cl identifier = InterfaceDescription () [Label cl identifier]

button :: Class -> Id -> InterfaceDescription ()
button cl identifier = InterfaceDescription () [Button cl identifier]

window :: Class -> Id -> InterfaceDescription a -> InterfaceDescription ()
window cl identifier (InterfaceDescription _ config) = InterfaceDescription () [Window cl identifier config]