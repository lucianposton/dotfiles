{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  XMonad.Layout.MultiToggle.MyTabBar
-- Copyright   :  
-- License     :  
--
-- Maintainer  :  
-- Stability   :  unstable
-- Portability :  unportable
--
-- Provides a transformer for use with "XMonad.Layout.MultiToggle" to
-- dynamically toggle "XMonad.Layout.TabBarDecoration".
-----------------------------------------------------------------------------

module XMonad.Layout.MultiToggle.MyTabBar (
    MyTabBar(..)
) where


import XMonad
import XMonad.Layout.Decoration
import XMonad.Layout.LayoutModifier
import XMonad.Layout.MultiToggle
import XMonad.Layout.TabBarDecoration
import XMonad.Util.Themes

-- $usage
-- To use this module with "XMonad.Layout.MultiToggle", add the @MYTABBAR@
-- to your layout For example, from a basic layout like
--
-- > layout = tiled ||| Full
--
-- Add @MYTABBAR@ by changing it this to
--
-- > layout = mkToggle (single MYTABBAR) (tiled ||| Full)
--
-- You can now dynamically toggle the transformation by adding a key binding
-- such as @mod-x@ as follows.
--
-- > ...
-- >   , ((modm,               xK_x     ), sendMessage $ Toggle MYTABBAR)
-- > ...

-- | Transformer for "XMonad.Layout.TabBarDecoration".
data MyTabBar = MYTABBAR deriving (Read, Show, Eq, Typeable)
instance Transformer MyTabBar Window where
    transform _ x k = k (myCustomTabBar x) (\(ModifiedLayout _ (ModifiedLayout _ x')) -> x')

myCustomTabBar :: Eq a => l a -> ModifiedLayout (Decoration TabBarDecoration DefaultShrinker)
                (ModifiedLayout ResizeScreen l) a
--myCustomTabBar = decoration shrinkText (theme darkTheme) (TabBar Bottom) . resizeVerticalBottom 15
myCustomTabBar = decoration shrinkText (theme darkTheme) (TabBar Top) . resizeVertical 15
