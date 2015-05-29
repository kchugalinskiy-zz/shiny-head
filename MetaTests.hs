module MetaTests where

import Graphics.UI.InterfaceDescription
import Test.Hspec

main :: IO ()
main = hspec $ do
  describe "Validate haqify function" $ do
    it "just should compile" $ do
    	let (InterfaceDescription () (FrameConfiguration Frame elems)) = test in elems `shouldBe` [Label "Class1" "SomeTextLabel", Button "Class2" "OkButton"]

test :: InterfaceDescription ()
test = do
	label "Class1" "SomeTextLabel"
	button "Class2" "OkButton"
