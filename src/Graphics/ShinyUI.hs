module Graphics.ShinyUI (ShinyUI, Id, label, button, openNewWindow) where

import Control.Monad (ap)
import Control.Applicative (Applicative(..))

type Id = String

data FrameElement =
	Button Id |
	Label Id |
	Compound Id FrameConfiguration
	deriving (Show, Eq)

data FrameConfiguration =
	FrameConfiguration FrameType [FrameElement]
	deriving (Show, Eq)

data FrameType =
	Frame |
	Window
	deriving (Show, Eq, Ord)

data ShinyUI a =
	ShinyUI a FrameConfiguration
	deriving (Show)

instance Applicative ShinyUI where
	pure = return
	(<*>) = ap

instance Monad ShinyUI where
	(>>=) oldState@(ShinyUI val _) func = 
				mergeUI oldState newState
			where
				newState = func val
	(>>) = mergeUI
	return val = ShinyUI val $ FrameConfiguration Frame []

instance Functor ShinyUI where
	fmap f (ShinyUI value config) = ShinyUI (f value) config

mergeUI :: ShinyUI a -> ShinyUI b -> ShinyUI b
mergeUI (ShinyUI _ (FrameConfiguration frameType1 frameElems1)) (ShinyUI val (FrameConfiguration frameType2 frameElems2)) =
	ShinyUI val $ FrameConfiguration (if frameType1 > frameType2 then frameType1 else frameType2) $ frameElems1 ++ frameElems2

label :: Id -> ShinyUI ()
label identifier = ShinyUI () $ FrameConfiguration Frame $ [Label identifier]

button :: Id -> ShinyUI ()
button identifier = ShinyUI () $ FrameConfiguration Frame $ [Button identifier]

openNewWindow :: ShinyUI a -> ShinyUI Id
openNewWindow (ShinyUI _ config) = (ShinyUI generateNewWindowId config)

generateNewWindowId :: Id
generateNewWindowId = "lol"