{-# LANGUAGE CPP               #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE Trustworthy       #-}

module Lemmata.Monad (
    Monad((>>=), return)
  , MonadPlus(..)

  , (=<<)
  , (>=>)
  , (<=<)
  , (>>)
  , forever

  , join
  , mfilter
  , filterM
  , mapAndUnzipM
  , zipWithM
  , zipWithM_
  , foldM
  , foldM_
  , replicateM
  , replicateM_
  , concatMapM

  , guard
  , when
  , unless

  , liftM
  , liftM2
  , liftM3
  , liftM4
  , liftM5
  , liftM'
  , liftM2'
  , ap

  , (<$!>)
  ) where

import           Control.Monad
import           Data.List     (concat)
import           Lemmata.Base  (seq)

concatMapM :: Monad m => (a -> m [b]) -> [a] -> m [b]
concatMapM f xs = fmap concat (mapM f xs)

liftM' :: Monad m => (a -> b) -> m a -> m b
liftM' = (<$!>)
{-# INLINE liftM' #-}

liftM2' :: (Monad m) => (a -> b -> c) -> m a -> m b -> m c
liftM2' f a b = do
  x <- a
  y <- b
  let z = f x y
  z `seq` return z
{-# INLINE liftM2' #-}

#if !MIN_VERSION_base(4,8,0)
(<$!>) :: Monad m => (a -> b) -> m a -> m b
f <$!> m = do
  x <- m
  let z = f x
  z `seq` return z
{-# INLINE (<$!>) #-}
#endif
