module Graphics.UI.InterfaceDescription where

import Graphics.UI.InterfaceDatatypes

import Control.Monad (ap)
import Control.Applicative (Applicative(..))

instance Applicative InterfaceDescription where
	pure = return
	(<*>) = ap

instance Monad InterfaceDescription where
	(>>=) oldState@(InterfaceDescription val _) func = 
				mergeUI oldState newState
			where
				newState = func val
	(>>) = mergeUI
	return val = InterfaceDescription val $ FrameConfiguration Frame []

instance Functor InterfaceDescription where
	fmap f (InterfaceDescription value config) = InterfaceDescription (f value) config

getFrameConfiguration :: InterfaceDescription a -> FrameConfiguration
getFrameConfiguration (InterfaceDescription _ value) = value

mergeUI :: InterfaceDescription a -> InterfaceDescription b -> InterfaceDescription b
mergeUI (InterfaceDescription _ (FrameConfiguration frameType1 frameElems1)) (InterfaceDescription val (FrameConfiguration frameType2 frameElems2)) =
	InterfaceDescription val $ FrameConfiguration (if frameType1 > frameType2 then frameType1 else frameType2) $ frameElems1 ++ frameElems2

label :: Class -> Id -> InterfaceDescription ()
label cl identifier = InterfaceDescription () $ FrameConfiguration Frame $ [Label cl identifier]

button :: Class -> Id -> InterfaceDescription ()
button cl identifier = InterfaceDescription () $ FrameConfiguration Frame $ [Button cl identifier]

window :: Class -> Id -> InterfaceDescription a -> InterfaceDescription ()
window cl identifier (InterfaceDescription _ config) = InterfaceDescription () $ FrameConfiguration Window [Compound cl identifier config]