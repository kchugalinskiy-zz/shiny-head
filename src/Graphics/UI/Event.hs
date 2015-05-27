module Graphics.UI.Event where

data EventCondition = 
	EventCondition

data EventTransaction =
	EventTransaction EventCondition [ComboEvent]

data ComboEvent =
	ComboEvent [SingleEventModifier]

data SingleEventModifier =
	ObligatoryEvent SingleEvent |
	OptionalEvent SingleEvent

data SingleEvent =
	KeyEvent |
	MouseEvent |
	UIEvent |
	DelayEvent
	deriving (Show, Eq, Ord)

type KeyCode = Int
type MouseKeyCode = Int
type TimeDelta = Integer

data DelayEvent =
	Delay TimeDelta

data UIEvent =
	CloseWindow

data MouseEvent =
	MouseEnter |
	MouseLeave |
	MouseKeyDown MouseKeyCode |
	MouseKeyUp MouseKeyCode
	deriving (Show, Eq, Ord)

data KeyEvent =
	KeyUp KeyCode |
	KeyDown KeyCode
	deriving (Show, Eq, Ord)